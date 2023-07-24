import 'package:get_it/get_it.dart';
import 'package:memo_app/services/http_service.dart';

final locator = GetIt.instance;

initLocator() {
  locator.registerSingleton<HttpService>(HttpService());
}
