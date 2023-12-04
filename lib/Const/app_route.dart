import 'package:JNB/screens/add_catalogue/add_catalogue_screen.dart';
import 'package:JNB/screens/cart/cart_screen.dart';
import 'package:JNB/screens/catalogue/catalogue_screen.dart';
import 'package:JNB/screens/customer/customer_list_screen.dart';
import 'package:JNB/screens/dash_board/dashBoard_screen.dart';
import 'package:JNB/screens/login/loginscreen.dart';
import 'package:JNB/screens/sales_order/print_preview.dart';
import 'package:JNB/screens/sales_order/sales_order_screen/sales_order_screen.dart';
import 'package:JNB/screens/sales_order/sales_order_screen/sales_order_successfully_screen.dart';
import 'package:JNB/screens/signature/signature_screen.dart';
import 'package:JNB/screens/splash/splash_screen.dart';
import 'package:JNB/screens/visited/visited_screen.dart';
import 'package:JNB/widgets/bottom_nav_bar.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../screens/sales_order/sales_order_create/sales_order_product/sales_order_product_screen.dart';
import '../screens/sales_order/sales_order_create/sales_order_summary/sales_order_summery_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splashScreen';
  static const String dashBoardScreen = '/DashBoardScreen';
  static const String loginScreen = '/LoginScreen';
  static const String customerListScreen = '/CustomerListScreen';
  static const String addCatalogue = '/AddCatalogue';
  static const String catalogueScreen = '/CatalogueScreen';
  static const String salesOrderScreen = '/SalesOrderScreen';
  static const String cartScreen = '/CartScreen';
  static const String visitedScreen = '/VisitorScreen';

  static const String bottomNavBar = '/BottomNavBar';
  static const String customerScreen = '/AddScreen';
  static const String productScreen = '/ProductScreen';
  static const String summaryScreen = '/SummaryScreen';
  static const String signatureScreen = '/SignatureScreen';
  static const String salesOrderSuccessfullyScreen =
      '/salesOrderSuccessfullyScreen';
  static const String PrintPreviewScreen = '/PrintPreviewScreen';
  static const String bottomNavBar0 = '/bottomNavBar0';
  static const String bottomNavBar1 = '/bottomNavBar1';
  static const String bottomNavBar2 = '/bottomNavBar2';
  static const String bottomNavBar3 = '/bottomNavBar3';
}

final screens = [
  GetPage(name: AppRoutes.splashScreen, page: () => const SplashScreen()),
  GetPage(name: AppRoutes.dashBoardScreen, page: () => const DashBoardScreen()),
  GetPage(name: AppRoutes.loginScreen, page: () => const LoginScreen()),
  GetPage(
      name: AppRoutes.customerListScreen,
      page: () => const CustomerListScreen()),
  GetPage(name: AppRoutes.addCatalogue, page: () => const AddCatalogue()),
  GetPage(name: AppRoutes.catalogueScreen, page: () => const CatalogueScreen()),
  GetPage(
      name: AppRoutes.salesOrderScreen, page: () => const SalesOrderScreen()),
  GetPage(name: AppRoutes.cartScreen, page: () => const CartScreen()),
  GetPage(name: AppRoutes.visitedScreen, page: () => const VisitedScreen()),
  GetPage(name: AppRoutes.bottomNavBar, page: () => BottomNavBar()),
  GetPage(
      name: AppRoutes.productScreen,
      page: () => const SalesOrderProductScreen()),
  GetPage(
      name: AppRoutes.summaryScreen,
      page: () => const SalesOrderSummaryScreen()),
  GetPage(name: AppRoutes.signatureScreen, page: () => const SignatureScreen()),
  GetPage(
      name: AppRoutes.salesOrderSuccessfullyScreen,
      page: () => const SalesOrderSuccessfullyScreen()),
  GetPage(
      name: AppRoutes.PrintPreviewScreen,
      page: () => const PrintPreviewScreen()),
  // GetPage(
  //     name: AppRoutes.bottomNavBar0,
  //     page: () => BottomNavBar(
  //           intex: 0,
  //         )),
  // GetPage(
  //     name: AppRoutes.bottomNavBar1,
  //     page: () => BottomNavBar(
  //           intex: 1,
  //         )),
  // GetPage(
  //     name: AppRoutes.bottomNavBar2,
  //     page: () => BottomNavBar(
  //           intex: 2,
  //         )),
];
