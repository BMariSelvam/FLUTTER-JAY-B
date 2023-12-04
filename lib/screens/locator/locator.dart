import 'package:get_it/get_it.dart';

import 'cart_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<ProductListService>(ProductListService());
}
