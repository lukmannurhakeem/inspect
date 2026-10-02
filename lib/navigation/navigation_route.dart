import 'package:flutter/material.dart';
import 'package:inspect/data/model/get_company_division/get_company_division.dart';
import 'package:inspect/data/model/get_customer_model/get_customer_model.dart';
import 'package:inspect/data/model/get_site_model/get_site_model.dart';
import 'package:inspect/data/model/job_register_model/job_register_model.dart';
import 'package:inspect/screen/auth/forgot_password_screen.dart';
import 'package:inspect/screen/auth/login_screen.dart';
import 'package:inspect/screen/auth/reset_password_screen.dart';
import 'package:inspect/screen/categories/categories_create_screen.dart';
import 'package:inspect/screen/categories/categories_screen.dart';
import 'package:inspect/screen/categories/category_details.dart';
import 'package:inspect/screen/customer/customer_create_screen.dart';
import 'package:inspect/screen/customer/customer_details_screen.dart';
import 'package:inspect/screen/customer/customer_screen.dart';
import 'package:inspect/screen/cycle/create_cycle_screen.dart';
import 'package:inspect/screen/dashboard/dashboard_screen.dart';
import 'package:inspect/screen/home_screen.dart';
import 'package:inspect/screen/job/job_add_new_details_screen.dart';
import 'package:inspect/screen/job/job_add_new_screen.dart';
import 'package:inspect/screen/job/job_item_create/job_item_create_screen.dart';
import 'package:inspect/screen/job/job_item_details/job_item_details_screen.dart';
import 'package:inspect/screen/job/job_item_details/report_field_screen.dart';
import 'package:inspect/screen/job/job_register/job_register_screen.dart';
import 'package:inspect/screen/job/job_screen.dart';
import 'package:inspect/screen/personnel/personnel_create_screen.dart';
import 'package:inspect/screen/personnel/personnel_detail_screen.dart';
import 'package:inspect/screen/personnel/personnel_screen.dart';
import 'package:inspect/screen/personnel/personnel_team_create_screen.dart';
import 'package:inspect/screen/personnel/personnel_team_screen.dart';
import 'package:inspect/screen/planner/planner_screen.dart';
import 'package:inspect/screen/planner/team_planner_screen.dart';
import 'package:inspect/screen/profile/profile_screen.dart';
import 'package:inspect/screen/route_not_found.dart';
import 'package:inspect/screen/settings/access/acccess_view_screen.dart';
import 'package:inspect/screen/settings/access/accesss_create_screen.dart';
import 'package:inspect/screen/settings/company/agent_create_screen.dart';
import 'package:inspect/screen/settings/company/agent_screen.dart';
import 'package:inspect/screen/settings/company/division_crete_screen.dart';
import 'package:inspect/screen/settings/report_setup/report_create_screen.dart';
import 'package:inspect/screen/settings/report_setup/report_types_detail_screen.dart';
import 'package:inspect/screen/site/site_create_new_screen.dart';
import 'package:inspect/screen/site/site_detail_screen.dart';
import 'package:inspect/screen/site/site_screen.dart';
import 'package:inspect/screen/splash_screen.dart';


class NavigationRoutes {
  NavigationRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String planner = '/planner';
  static const String teamPlanner = '/teamPlanner';
  static const String job = '/job';
  static const String jobRegister = '/jobRegister';
  static const String jobAddNewScreen = '/jobAddNewScreen';
  static const String jobAddNewDetailsScreen = '/jobAddNewDetailsScreen';
  static const String jobItemDetails = '/jobItemOverview';
  static const String jobItemCreateScreen = '/jobItemCreateScreen';

  static const String personnel = '/personnel';
  static const String teamPersonnel = '/teamPersonnel';
  static const String createPersonnel = '/createPersonnel';
  static const String createTeamPersonnel = '/createTeamPersonnel';
  static const String personnelDetails = '/personnelDetails';
  static const String site = '/site';
  static const String siteDetails = '/siteDetails';
  static const String createSite = '/createSite';
  static const String categories = '/categories';
  static const String createCategories = '/createCategories';
  static const String categoryDetails = '/categoryDetails';
  static const String profile = '/profile';
  static const String customer = '/customer';
  static const String customerDetails = '/customerDetails';
  static const String createCustomer = '/createCustomer';
  static const String companyCreateDivision = '/companyCreateDivision';
  static const String reportCreate = '/reportCreate';
  static const String reportTypeDetails = '/reportTypeDetails';
  static const String accessScreen = '/accessScreen';
  static const String accessView = '/accessView';
  static const String reportFieldsScreen = '/reportFieldsScreen';
  static const String createCycle = '/createCycle';
  static const String agentScreen = '/agentScreen';
  static const String agentCreateScreen = '/agentCreateScreen';

  static WidgetBuilder getBuilder(String routeName, Object? arguments) {
    final args = arguments is Map<String, dynamic> ? arguments : null;

    switch (routeName) {
      case splash:
        return (_) => const SplashScreen();

      case login:
        return (_) => const LoginScreen();

      case forgotPassword:
        return (_) => const ForgotPasswordScreen();

      case resetPassword:
        return (_) => const ResetPasswordScreen();

      case home:
        return (_) => HomeScreen(
          showWelcomeDialog: args?['showWelcomeDialog'] ?? false,
          userName: args?['userName'],
        );

      case dashboard:
        return (_) => const DashboardScreen();

      case planner:
        return (_) => const PlannerScreen();

      case teamPlanner:
        return (_) => const TeamPlannerScreen();

      case job:
        return (_) => const JobScreen();

      case jobRegister:
        return (_) => JobRegisterScreen(
          jobId: args?['jobId'],
          job: args?['job'],
        );

      case jobAddNewScreen:
        return (_) => const JobAddNewScreen();

    // Create mode: customerId, customerName, siteId, siteName only.
    // Edit mode: full arg set with isEditMode: true and the existing job.
      case jobAddNewDetailsScreen:
        return (_) => JobAddNewDetailsScreen(
          customerId: args?['customerId'] ?? '',
          customerName: args?['customerName'] ?? '',
          siteId: args?['siteId'] ?? '',
          siteName: args?['siteName'] ?? '',
          isEditMode: args?['isEditMode'] as bool? ?? false,
          job: args?['job'],
        );

    // Two navigation paths:
    //   1. API job register   -> {'item': Item, 'jobId': String}
    //   2. Local storage list -> {'itemMap': Map, 'jobId': String}
      case jobItemDetails:
        final item = args?['item'] as Item?;
        final itemMap = args?['itemMap'] as Map<String, dynamic>?;
        final jobId = args?['jobId'] as String? ??
            itemMap?['jobId']?.toString() ??
            itemMap?['jobID']?.toString() ??
            itemMap?['job_id']?.toString() ??
            '';

        assert(
        item != null || itemMap != null,
        'jobItemDetails route requires either "item" (Item) or '
            '"itemMap" (Map<String, dynamic>) in arguments',
        );

        return (_) => JobItemDetailsScreen(
          item: item,
          itemMap: itemMap,
          jobId: jobId,
        );

      case jobItemCreateScreen:
        final a = arguments as Map<String, dynamic>;
        return (_) => JobItemCreateScreen(
          jobId: a['jobId'],
          selectedCategory: a['selectedCategory'],
          preloadedFields: a['preloadedFields'] ?? [],
          isEditMode: a['isEditMode'] as bool? ?? false,
          existingItem: a['existingItem'] as Map<String, dynamic>?,
        );

      case personnel:
        return (_) => const PersonnelScreen();

      case createPersonnel:
        return (_) => const PersonnelCreateScreen();

      case teamPersonnel:
        return (_) => const PersonnelTeamScreen();

      case createTeamPersonnel:
        final teamId = arguments as String?;
        return (_) => PersonnelCreateTeamScreen(teamPersonnelId: teamId);

      case personnelDetails:
        return (_) => PersonnelDetailScreen(personnelId: args?['personnelId']);

      case site:
        return (_) => const SiteScreen();

      case siteDetails:
        final siteArg = arguments as Site;
        return (_) => SiteDetailsScreen(site: siteArg);

      case createSite:
        return (_) => const SiteCreateNewScreen();

      case categories:
        return (_) => const CategoriesScreen();

      case profile:
        return (_) => const ProfileScreen();

      case createCategories:
        return (_) => CategoriesCreateScreen(
          categoryId: args?['categoryId'] ?? '',
          parentCategoryId: args?['parentCategoryId'],
          parentCategoryName: args?['parentCategoryName'],
        );

      case categoryDetails:
        return (_) => const CategoryDetails();

      case customer:
        return (_) => const CustomerScreen();

      case customerDetails:
        final customerArg = arguments as Customer;
        return (_) => CustomerDetailsScreen(customer: customerArg);

      case createCustomer:
        return (_) => const CustomerCreateNewScreen();

      case createCycle:
        return (_) => const CreateCycleScreen();

      case companyCreateDivision:
        if (arguments is GetCompanyDivision) {
          return (_) => CompanyCreateDivision(division: arguments);
        }
        if (args != null) {
          return (_) => CompanyCreateDivision(id: args['id'] as String?);
        }
        return (_) => const CompanyCreateDivision();

      case reportCreate:
        return (_) => const ReportCreateScreen();

      case reportTypeDetails:
        return (_) => ReportTypesDetails(
          reportTypeID: args?['reportTypeID'] ?? '',
        );

      case accessScreen:
        return (_) => const AccessScreen();

      case accessView:
        return (_) => const AccessViewScreen();

      case reportFieldsScreen:
        return (_) => ReportFieldsScreen(
          reportTypeId: args?['reportTypeId'] ?? '',
          reportName: args?['reportName'] ?? '',
          item: args?['item'],
          reportData: args?['reportData'] as Map<String, dynamic>?,
          isViewMode: args?['isViewMode'] as bool? ?? false,
          isCopyMode: args?['isCopyMode'] as bool? ?? false,
        );

      case agentScreen:
        return (_) => const AgentScreen();

      case agentCreateScreen:
        return (_) => const AgentCreateScreen();

      default:
        return (_) => const RouteNotFoundScreen();
    }
  }
}