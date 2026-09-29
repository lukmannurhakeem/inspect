import 'package:flutter/material.dart';
import 'package:inspect/screen/route_not_found.dart';

class NavigationRoutes{

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
 switch(routeName){
   default:
     return (_) => const RouteNotFoundScreen();
 }
}

}