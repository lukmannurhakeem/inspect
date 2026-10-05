import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:inspect/data/repository/agent/agent_impl.dart';
import 'package:inspect/data/repository/agent/agent_repository.dart';
import 'package:inspect/data/repository/category/category_impl.dart';
import 'package:inspect/data/repository/category/category_repository.dart';
import 'package:inspect/data/repository/customer/customer_impl.dart';
import 'package:inspect/data/repository/customer/customer_repository.dart';
import 'package:inspect/data/repository/cycle/cycle_impl.dart';
import 'package:inspect/data/repository/cycle/cycle_repository.dart';
import 'package:inspect/data/repository/job/job_impl.dart';
import 'package:inspect/data/repository/job/job_repository.dart';
import 'package:inspect/data/repository/personnel/personnel_impl.dart';
import 'package:inspect/data/repository/personnel/personnel_repository.dart';
import 'package:inspect/data/repository/planner/planner_impl.dart';
import 'package:inspect/data/repository/planner/planner_repository.dart';
import 'package:inspect/data/repository/site/site_impl.dart';
import 'package:inspect/data/repository/site/site_repository.dart';
import 'package:inspect/data/repository/system/system_impl.dart';
import 'package:inspect/data/repository/system/system_repository.dart';
import 'package:inspect/data/repository/user/user_impl.dart';
import 'package:inspect/data/repository/user/user_repository.dart';
import 'package:inspect/network/api_client.dart';
import 'package:inspect/storage/local_storage.dart';
import 'package:inspect/storage/token_storage.dart';

class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator _instance = ServiceLocator._();

  factory ServiceLocator() => _instance;

  VoidCallback? _onSessionExpired;
  bool _initialized = false;

  late final TokenStorage tokenStorage;
  late final ApiClient apiClient;
  late final UserRepository userRepository;
  late final AgentRepository agentRepository;
  late final CycleRepository cycleRepository;
  late final CategoryRepository categoryRepository;
  late final SiteRepository siteRepository;
  late final SystemRepository systemRepository;
  late final CustomerRepository customerRepository;
  late final JobRepository jobRepository;
  late final PersonnelRepository personnelRepository;
  late final PlannerRepository plannerRepository;

  bool get isInitialized => _initialized;

  // ignore: use_setters_to_change_properties
  void setSessionExpiredHandler(VoidCallback handler) {
    _onSessionExpired = handler;
  }

  Future<void> init({String? baseUrl}) async {
    if (_initialized) return;

    await LocalStorage.init();

    tokenStorage = TokenStorage();
    apiClient = ApiClient(
      baseUrl: baseUrl,
      tokenStorage: tokenStorage,
      onSessionExpired: () => _onSessionExpired?.call(),
    );

    userRepository = UserImpl(apiClient, tokenStorage);
    agentRepository = AgentImpl(apiClient);
    cycleRepository = CycleImpl(apiClient);
    categoryRepository = CategoryImpl(apiClient);
    siteRepository = SiteImpl(apiClient);
    systemRepository = SystemImpl(apiClient);
    customerRepository = CustomerImpl(apiClient);
    jobRepository = JobImpl(apiClient);
    personnelRepository = PersonnelImpl(apiClient);
    plannerRepository = PlannerImpl(apiClient);

    _initialized = true;
  }
}