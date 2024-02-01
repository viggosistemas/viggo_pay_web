import 'package:get_it/get_it.dart';
import 'package:viggo_pay_admin/login/locator.dart';
import 'package:viggo_pay_admin/sync/locator.dart';
import 'package:viggo_pay_core_frontend/di/locator.dart';

var locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.allowReassignment = true;
  locator = await CoreLocator().setup(locator);
  LoginLocator().setup();
  SyncLocator().setup();
  CoreLocator().setCoreLocator(locator);
}