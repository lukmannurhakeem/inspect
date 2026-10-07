import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect/data/model/area_model/area_model.dart';
import 'package:inspect/data/model/get_site_by_customer_id_model/get_site_by_customer_id_model.dart';
import 'package:inspect/data/model/get_site_model/get_site_model.dart';
import 'package:inspect/data/repository/site/site_repository.dart';
import 'package:inspect/locator/locator.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/storage/local_storage.dart';
import 'package:inspect/storage/local_storage_constant.dart';

enum SiteStatus {
  Active('Active'),
  InActive('InActive');

  const SiteStatus(this.label);

  final String label;
}

class SiteProvider extends ChangeNotifier {
  final SiteRepository _siteRepository = ServiceLocator().siteRepository;

  final nameController = TextEditingController();
  final siteCodeController = TextEditingController();
  final customerCodeController = TextEditingController();
  final areaController = TextEditingController();
  final descriptionController = TextEditingController();
  final notesController = TextEditingController();
  final divisionController = TextEditingController();
  final addressController = TextEditingController();
  final statusController = TextEditingController();
  final customerIdController = TextEditingController();

  late final List<TextEditingController> _controllers = [
    nameController,
    siteCodeController,
    customerCodeController,
    areaController,
    descriptionController,
    notesController,
    divisionController,
    addressController,
    statusController,
    customerIdController,
  ];

  static const int pageSize = 10;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  bool _hasError = false;
  String? _errorMessage;

  List<Site> _sites = [];
  List<SiteCustomer> _sitesCustomerList = [];
  List<AreaModel> _areas = [];

  GetSiteModel? _getSiteModel;
  GetSiteByCustomerIdModel? _getSiteByCustomerIdModel;

  String? selectedCustomerId;
  String? selectedCustomerName;
  String? selectedCustomerIdSite = '';
  String? selectedCustomerSiteName;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  bool get hasData => _sites.isNotEmpty;
  bool get hasAreas => _areas.isNotEmpty;

  List<Site> get sites => _sites;
  List<SiteCustomer> get sitesCustomerList => _sitesCustomerList;
  List<AreaModel> get areas => _areas;
  GetSiteModel? get getSiteModel => _getSiteModel;
  GetSiteByCustomerIdModel? get getSiteByCustomerId =>
      _getSiteByCustomerIdModel;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _hasError = message != null;
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _hasError = false;
    _errorMessage = null;
  }

  Future<T?> _guard<T>(
      Future<T> Function() action, {
        bool rethrowError = false,
      }) async {
    _clearError();
    _setLoading(true);
    try {
      return await action();
    } catch (e) {
      _setError(e.toString());
      if (rethrowError) rethrow;
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void setSelectedCustomer(String? customerId, {String? name}) {
    selectedCustomerId = customerId;
    selectedCustomerName = name;
    selectedCustomerIdSite = null;
    selectedCustomerSiteName = null;
    _sitesCustomerList = [];
    notifyListeners();
  }

  void setSelectedCustomerById(String? siteId, {String? name}) {
    selectedCustomerIdSite = siteId;
    selectedCustomerSiteName = name;
    notifyListeners();
  }

  Future<void> fetchSite(BuildContext context) => _guard(() async {
    _page = 1;
    _hasMore = true;
    _getSiteModel = await _siteRepository.fetchSite(page: 1, limit: pageSize);
    _sites = _getSiteModel?.sites ?? [];
    _hasMore = _sites.length >= pageSize;
  });

  Future<void> fetchMoreSites() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();
    try {
      final nextPage = _page + 1;
      final model = await _siteRepository.fetchSite(
        page: nextPage,
        limit: pageSize,
      );
      final incoming = model.sites ?? [];
      final existingIds = _sites.map((s) => s.siteid).toSet();
      final fresh =
      incoming.where((s) => !existingIds.contains(s.siteid)).toList();
      debugPrint('page=$nextPage incoming=${incoming.length} fresh=${fresh.length} hasMore=$_hasMore');
      _page = nextPage;
      _sites = [..._sites, ...fresh];
      _hasMore = incoming.length >= pageSize && fresh.isNotEmpty;
    } catch (e) {
      debugPrint('SiteProvider: failed to load more sites: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> fetchSiteByCustomerId(
      BuildContext context,
      dynamic customerId,
      ) async {
    final id = customerId.toString();
    _sitesCustomerList = [];
    notifyListeners();

    try {
      if (!await _isOnline()) {
        _applyCachedSites(id);
        return;
      }

      final model = await _siteRepository.fetchSiteByCustomerId(
        customerId: id,
      );
      _getSiteByCustomerIdModel = model;
      _sitesCustomerList = model.siteCustomers ?? [];
      _cacheSites(id, _sitesCustomerList);
      _autoSelectSingleSite();
      notifyListeners();
    } catch (e) {
      if (!_applyCachedSites(id)) _setError(e.toString());
    }
  }

  Future<bool> _isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  bool _applyCachedSites(String customerId) {
    final cached = _loadSitesFromCache(customerId);
    if (cached.isEmpty) return false;
    _sitesCustomerList = cached;
    _autoSelectSingleSite();
    notifyListeners();
    return true;
  }

  void _autoSelectSingleSite() {
    if (_sitesCustomerList.length != 1) return;
    final site = _sitesCustomerList.first;
    selectedCustomerIdSite = site.siteid;
    selectedCustomerSiteName = site.siteName ?? site.siteCode;
  }

  String _cacheKey(String customerId) =>
      '${LocalStorageConstant.cachedSites}_$customerId';

  void _cacheSites(String customerId, List<SiteCustomer> sites) {
    try {
      LocalStorage.setString(
        _cacheKey(customerId),
        jsonEncode(sites.map((s) => s.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('SiteProvider: failed to cache sites: $e');
    }
  }

  List<SiteCustomer> _loadSitesFromCache(String customerId) {
    try {
      final raw = LocalStorage.getString(_cacheKey(customerId));
      if (raw.isEmpty) return [];
      return (jsonDecode(raw) as List)
          .map((e) => SiteCustomer.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('SiteProvider: failed to load cached sites: $e');
      return [];
    }
  }

  Future<void> createSite(
      BuildContext context, {
        PlatformFile? logoFile,
      }) => _guard(() async {
    await _siteRepository.createSite(
      status: statusController.text,
      siteCode: siteCodeController.text,
      division: divisionController.text,
      customerId: selectedCustomerId ?? '',
      customerCode: customerCodeController.text,
      address: addressController.text,
      siteName: nameController.text,
      area: areaController.text,
      description: descriptionController.text,
      notes: notesController.text,
      logoFile: logoFile,
    );
    await fetchSite(context);
    NavigationService().goBack();
  });

  Future<void> updateSite(
      BuildContext context, {
        required String siteId,
        PlatformFile? logoFile,
      }) => _guard(() async {
    await _siteRepository.updateSite(
      siteId: siteId,
      status: statusController.text,
      siteCode: siteCodeController.text,
      division: divisionController.text,
      customerId: selectedCustomerId ?? '',
      customerCode: customerCodeController.text,
      address: addressController.text,
      siteName: nameController.text,
      area: areaController.text,
      description: descriptionController.text,
      notes: notesController.text,
      logoFile: logoFile,
    );
    await fetchSite(context);
    NavigationService().goBack();
  });

  Future<bool> deleteSite(BuildContext context, String siteId) async {
    final deleted = await _guard(() async {
      await _siteRepository.deleteSite(siteId: siteId);
      _sites.removeWhere((site) => site.siteid == siteId);
      notifyListeners();
      return true;
    });
    await fetchSite(context);
    return deleted ?? false;
  }

  Future<void> fetchAreas() => _guard(() async {
    final model = await _siteRepository.fetchAreas();
    _areas = model.areas;
  });

  Future<void> createArea({
    required String areaname,
    required String areacode,
    String? personnelid,
  }) => _guard(() async {
    await _siteRepository.createArea(
      areaname: areaname,
      areacode: areacode,
      personnelid: personnelid,
    );
    await fetchAreas();
  }, rethrowError: true);

  void clearControllers() {
    for (final controller in _controllers) {
      controller.clear();
    }
    selectedCustomerId = null;
    selectedCustomerName = null;
    selectedCustomerIdSite = null;
    selectedCustomerSiteName = null;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}