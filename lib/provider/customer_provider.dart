import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect/data/model/dashboard_model/dashboard_model.dart';
import 'package:inspect/data/model/get_customer_model/get_customer_model.dart';
import 'package:inspect/data/repository/customer/customer_repository.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/storage/local_storage.dart';
import 'package:inspect/storage/local_storage_constant.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:uuid/uuid.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerRepository _customerRepository =
      ServiceLocator().customerRepository;

  final customerIdController = TextEditingController();
  final siteCodeController = TextEditingController();
  final customerCodeController = TextEditingController();
  final divisionController = TextEditingController();
  final customerNameController = TextEditingController();
  final addressController = TextEditingController();
  final agentController = TextEditingController();
  final notesController = TextEditingController();
  final logoController = TextEditingController();

  late final List<TextEditingController> _controllers = [
    customerIdController,
    siteCodeController,
    customerCodeController,
    divisionController,
    customerNameController,
    addressController,
    agentController,
    notesController,
    logoController,
  ];

  final uuid = const Uuid();

  GetCustomerModel? _getCustomerModel;
  List<Customer> _customers = [];

  DashboardModel? _dashboardData;
  StatisticsData? _statisticsData;
  List<ItemData> _itemsData = [];

  bool _isLoading = false;
  bool _isFetching = false;
  bool _isCreating = false;
  bool _isDashboardLoading = false;

  CustomerRepository get customerRepository => _customerRepository;
  GetCustomerModel? get getCustomerModel => _getCustomerModel;
  List<Customer> get customers => _customers;

  DashboardModel? get dashboardData => _dashboardData;
  StatisticsData? get statisticsData => _statisticsData;
  List<ItemData> get itemsData => _itemsData;

  bool get isLoading => _isLoading;
  bool get isFetching => _isFetching;
  bool get isCreating => _isCreating;
  bool get isDashboardLoading => _isDashboardLoading;

  void _setFetching(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  void _setSubmitting(bool value) {
    _isCreating = value;
    _isLoading = value;
    notifyListeners();
  }

  void _setDashboardLoading(bool value) {
    _isDashboardLoading = value;
    notifyListeners();
  }

  Future<bool> _isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  String? _textOrNull(TextEditingController controller) =>
      controller.text.isEmpty ? null : controller.text;

  Future<void> fetchCustomers(BuildContext context) async {
    _setFetching(true);
    try {
      if (!await _isOnline()) {
        _loadCustomersFromCache();
        if (_customers.isEmpty && context.mounted) {
          CommonSnackbar.showError(
            context,
            'Offline: No cached customer data available.',
          );
        }
        return;
      }

      final model = await _customerRepository.fetchCustomer();
      _getCustomerModel = model;
      _customers = model.customers ?? [];
      _cacheCustomers(_customers);
      notifyListeners();
    } catch (e) {
      _loadCustomersFromCache();
      if (context.mounted) {
        CommonSnackbar.showError(
          context,
          _customers.isEmpty ? e.toString() : 'Offline: showing cached customers.',
        );
      }
    } finally {
      _setFetching(false);
    }
  }

  void _cacheCustomers(List<Customer> customers) {
    try {
      LocalStorage.setString(
        LocalStorageConstant.cachedCustomers,
        jsonEncode(customers.map((c) => c.toJson()).toList()),
      );
      LocalStorage.setString(
        LocalStorageConstant.lastCustomerSyncTimestamp,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      debugPrint('CustomerProvider: failed to cache customers: $e');
    }
  }

  void _loadCustomersFromCache() {
    try {
      final raw = LocalStorage.getString(
        LocalStorageConstant.cachedCustomers,
      );
      if (raw.isEmpty) return;
      _customers =
          (jsonDecode(raw) as List<dynamic>)
              .map((e) => Customer.fromJson(e as Map<String, dynamic>))
              .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('CustomerProvider: failed to load cached customers: $e');
    }
  }

  Future<void> _submit(
      BuildContext context,
      Future<void> Function() action,
      ) async {
    _setSubmitting(true);
    try {
      await action();
    } catch (e) {
      CommonSnackbar.showError(context, e.toString());
    } finally {
      _setSubmitting(false);
    }
  }

  Future<void> createCustomer(
      BuildContext context, {
        PlatformFile? logoFile,
      }) => _submit(context, () async {
    await _customerRepository.createCustomer(
      customerId: uuid.v4(),
      customerName: customerNameController.text,
      siteCode: siteCodeController.text,
      accountCode: customerCodeController.text,
      divisionId: divisionController.text,
      agent: _textOrNull(agentController),
      notes: _textOrNull(notesController),
      logo: _textOrNull(logoController),
      address: _textOrNull(addressController),
      logoFile: logoFile,
    );
    await fetchCustomers(context);
    NavigationService().goBack();
    CommonSnackbar.showSuccess(context, 'Customer created successfully');
    _clearControllers();
  });

  Future<void> updateCustomer(
      BuildContext context, {
        required String customerId,
        PlatformFile? logoFile,
      }) => _submit(context, () async {
    await _customerRepository.updateCustomer(
      customerId: customerId,
      customerName: customerNameController.text,
      siteCode: siteCodeController.text,
      accountCode: customerCodeController.text,
      divisionId: divisionController.text,
      agent: _textOrNull(agentController),
      notes: _textOrNull(notesController),
      logo: _textOrNull(logoController),
      address: _textOrNull(addressController),
      logoFile: logoFile,
    );
    await fetchCustomers(context);
    NavigationService().goBack();
    CommonSnackbar.showSuccess(context, 'Customer updated successfully');
  });

  Future<void> deleteCustomer(BuildContext context, String customerId) async {
    try {
      await _customerRepository.deleteCustomer(customerId: customerId);
      _customers.removeWhere((c) => c.customerid == customerId);
      notifyListeners();
      CommonSnackbar.showSuccess(context, 'Customer deleted successfully');
      await fetchCustomers(context);
    } catch (e) {
      await fetchCustomers(context);
      CommonSnackbar.showError(context, e.toString());
    }
  }

  dynamic _dataOrNull(Map response) =>
      response['success'] == true ? response['data'] : null;

  dynamic _unwrap(Map response, String fallbackMessage) {
    final data = _dataOrNull(response);
    if (data == null) throw Exception(response['message'] ?? fallbackMessage);
    return data;
  }

  List<ItemData> _parseItems(dynamic data) =>
      (data as List).map((item) => ItemData.fromJson(item)).toList();

  void _showDashboardError(BuildContext context, String label, Object error) {
    if (!context.mounted) return;
    CommonSnackbar.showError(context, 'Failed to load $label: $error');
  }

  Future<void> fetchDashboardData(
      BuildContext context,
      String customerId,
      ) async {
    _setDashboardLoading(true);
    try {
      final response = await _customerRepository.getDashboardCustomer(
        customerId,
      );
      _dashboardData = DashboardModel.fromJson(
        _unwrap(response, 'Failed to load dashboard data'),
      );
      notifyListeners();
    } catch (e) {
      _showDashboardError(context, 'dashboard', e);
    } finally {
      _setDashboardLoading(false);
    }
  }

  Future<void> fetchStatistics(BuildContext context, String customerId) async {
    try {
      final response = await _customerRepository.getDashboardStatistic(
        customerId,
      );
      _statisticsData = StatisticsData.fromJson(
        _unwrap(response, 'Failed to load statistics'),
      );
      notifyListeners();
    } catch (e) {
      _showDashboardError(context, 'statistics', e);
    }
  }

  Future<void> fetchItems(BuildContext context, String customerId) async {
    try {
      final response = await _customerRepository.getDashboardItems(customerId);
      _itemsData = _parseItems(_unwrap(response, 'Failed to load items'));
      notifyListeners();
    } catch (e) {
      _showDashboardError(context, 'items', e);
    }
  }

  Future<void> fetchAllDashboardData(
      BuildContext context,
      String customerId,
      ) async {
    _setDashboardLoading(true);
    try {
      final results = await Future.wait([
        _customerRepository.getDashboardCustomer(customerId),
        _customerRepository.getDashboardStatistic(customerId),
        _customerRepository.getDashboardItems(customerId),
      ]);

      final dashboard = _dataOrNull(results[0]);
      final statistics = _dataOrNull(results[1]);
      final items = _dataOrNull(results[2]);

      if (dashboard != null) _dashboardData = DashboardModel.fromJson(dashboard);
      if (statistics != null) {
        _statisticsData = StatisticsData.fromJson(statistics);
      }
      if (items != null) _itemsData = _parseItems(items);
      notifyListeners();
    } catch (e) {
      _showDashboardError(context, 'dashboard data', e);
    } finally {
      _setDashboardLoading(false);
    }
  }

  void clearDashboardData() {
    _dashboardData = null;
    _statisticsData = null;
    _itemsData = [];
    notifyListeners();
  }

  void _clearControllers() {
    for (final controller in _controllers) {
      controller.clear();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}