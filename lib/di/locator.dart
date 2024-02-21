import 'package:get_it/get_it.dart';
import 'package:viggo_pay_admin/app_builder/locator.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/locator.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/locator.dart';
import 'package:viggo_pay_admin/domain_account/locator.dart';
import 'package:viggo_pay_admin/forget_password/locator.dart';
import 'package:viggo_pay_admin/lazy_loading/locator.dart';
import 'package:viggo_pay_admin/login/locator.dart';
import 'package:viggo_pay_admin/pix_to_send/locator.dart';
import 'package:viggo_pay_admin/sync/locator.dart';
import 'package:viggo_pay_core_frontend/di/locator.dart';

var locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.allowReassignment = true;
  locator = await CoreLocator().setup(locator);
  //pages
  LazyLoadingLocator().setup();
  LoginLocator().setup();
  SyncLocator().setup();
  DomainAccountLocator().setup();
  PixToSendLocator().setup();
  ForgetPasswordLocator().setup();
  
  //appBuilder
  AppBuilderLocator().setup();
  PopMenuLocator().setup();
  HeaderSearchLocator().setup();
  CoreLocator().setCoreLocator(locator);
}