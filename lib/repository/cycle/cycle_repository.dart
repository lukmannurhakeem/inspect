
import 'package:inspect/data/model/cycle_model/cycle_model.dart';

abstract class CycleRepository {
  Future<CycleModel> fetchCycles();

  Future<dynamic> createCycle({
    required String reportTypeId,
    String? categoryId,
    String? customerId,
    String? siteId,
    required String unit,
    required int length,
    int? minLength,
    int? maxLength,
  });

  Future<dynamic> updateCycle({
    required String cycleId,
    required String reportTypeId,
    String? categoryId,
    String? customerId,
    String? siteId,
    required String unit,
    required int length,
    int? minLength,
    int? maxLength,
  });

  Future<void> deleteCycle(String cycleId);

  Future<Map<String, dynamic>?> getCycleDetails(String cycleId);
}
