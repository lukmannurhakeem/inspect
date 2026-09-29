import 'package:file_picker/file_picker.dart';
import 'package:inspect/data/model/area_model/area_model.dart';
import 'package:inspect/data/model/get_site_by_customer_id_model/get_site_by_customer_id_model.dart';
import 'package:inspect/data/model/get_site_model/get_site_model.dart';

abstract class SiteRepository {
  Future<GetSiteModel> fetchSite();

  Future<void> createSite({
    required String siteCode,
    required String siteName,
    required String division,
    required String customerCode,
    required String customerId,
    required String address,
    required String status,
    String? area,
    String? description,
    String? notes,
    PlatformFile? logoFile,
  });

  Future<GetSiteByCustomerIdModel> fetchSiteByCustomerId({
    required String customerId,
  });

  Future<void> updateSite({
    required String siteId,
    required String siteName,
    required String siteCode,
    required String customerId,
    String? customerCode,
    String? address,
    String? area,
    String? division,
    String? description,
    String? notes,
    String? status,
    PlatformFile? logoFile,
  });

  Future<void> deleteSite({required String siteId});

  Future<GetAreaModel> fetchAreas();

  Future<void> createArea({
    required String areaname,
    required String areacode,
    String? personnelid,
  });
}
