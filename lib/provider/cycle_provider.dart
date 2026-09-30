
import 'package:flutter/material.dart';
import 'package:inspect/data/model/cycle_model/cycle_model.dart';
import 'package:inspect/data/repository/cycle/cycle_repository.dart';
import 'package:inspect/locator/locator.dart';

class CycleProvider extends ChangeNotifier {
  CycleProvider({CycleRepository? cycleRepository})
      : _cycleRepository = cycleRepository ?? ServiceLocator().cycleRepository;

  final CycleRepository _cycleRepository;

  CycleModel? _cycleModel;
  bool _isLoading = false;
  String? _errorMessage;
  int _sortColumnIndex = 0;

  CycleModel? get cycleModel => _cycleModel;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get sortColumnIndex => _sortColumnIndex;

  set sortColumnIndex(int value) {
    _sortColumnIndex = value;
    notifyListeners();
  }

  Future<void> _run(
      BuildContext context,
      Future<void> Function() action, {
        required String errorPrefix,
        String? successMessage,
      }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await action();
      if (successMessage != null) _showMessage(context, successMessage);
    } catch (e) {
      _errorMessage = e.toString();
      _showMessage(context, '$errorPrefix: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _loadCycles() async {
    _cycleModel = await _cycleRepository.fetchCycles();
  }

  Future<void> fetchCycles(BuildContext context) {
    return _run(context, _loadCycles, errorPrefix: 'Error fetching cycles');
  }

  Future<void> createCycle(
      BuildContext context, {
        required String reportTypeId,
        String? categoryId,
        String? customerId,
        String? siteId,
        required String unit,
        required int length,
        int? minLength,
        int? maxLength,
      }) {
    return _run(
      context,
          () async {
        await _cycleRepository.createCycle(
          reportTypeId: reportTypeId,
          categoryId: categoryId,
          customerId: customerId,
          siteId: siteId,
          unit: unit,
          length: length,
          minLength: minLength,
          maxLength: maxLength,
        );
        await _loadCycles();
      },
      errorPrefix: 'Error creating cycle',
      successMessage: 'Cycle created successfully',
    );
  }

  Future<void> updateCycle(
      BuildContext context, {
        required String cycleId,
        required String reportTypeId,
        String? categoryId,
        String? customerId,
        String? siteId,
        required String unit,
        required int length,
        int? minLength,
        int? maxLength,
      }) {
    return _run(
      context,
          () async {
        await _cycleRepository.updateCycle(
          cycleId: cycleId,
          reportTypeId: reportTypeId,
          categoryId: categoryId,
          customerId: customerId,
          siteId: siteId,
          unit: unit,
          length: length,
          minLength: minLength,
          maxLength: maxLength,
        );
        await _loadCycles();
      },
      errorPrefix: 'Error updating cycle',
      successMessage: 'Cycle updated successfully',
    );
  }

  Future<void> deleteCycle(BuildContext context, String? cycleId) async {
    if (cycleId == null) return;

    await _run(
      context,
          () async {
        await _cycleRepository.deleteCycle(cycleId);
        _cycleModel?.data?.removeWhere((c) => c.cycleId == cycleId);
      },
      errorPrefix: 'Error deleting cycle',
      successMessage: 'Cycle deleted successfully',
    );
  }

  CycleData? getCycleById(String cycleId) {
    return _cycleModel?.data?.firstWhere(
          (c) => c.cycleId == cycleId,
      orElse: () => CycleData(),
    );
  }

  void clearData() {
    _cycleModel = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}