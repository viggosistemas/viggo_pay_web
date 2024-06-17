import 'package:get_it/get_it.dart';
import 'package:viggo_core_frontend/di/locator.dart';
import 'package:viggo_pay_admin/app_builder/locator.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/locator.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/locator.dart';
import 'package:viggo_pay_admin/application/locator.dart';
import 'package:viggo_pay_admin/dashboard/locator.dart';
import 'package:viggo_pay_admin/domain/locator.dart';
import 'package:viggo_pay_admin/domain_account/locator.dart';
import 'package:viggo_pay_admin/extrato/locator.dart';
import 'package:viggo_pay_admin/forget_password/locator.dart';
import 'package:viggo_pay_admin/funcionario/locator.dart';
import 'package:viggo_pay_admin/lazy_loading/locator.dart';
import 'package:viggo_pay_admin/login/locator.dart';
import 'package:viggo_pay_admin/matriz/locator.dart';
import 'package:viggo_pay_admin/parceiro/locator.dart';
import 'package:viggo_pay_admin/pay_facs/locator.dart';
import 'package:viggo_pay_admin/pix_to_send/locator.dart';
import 'package:viggo_pay_admin/role/locator.dart';
import 'package:viggo_pay_admin/route/locator.dart';
import 'package:viggo_pay_admin/sync/locator.dart';
import 'package:viggo_pay_admin/themes/locator.dart';
import 'package:viggo_pay_admin/user/locator.dart';
import 'package:viggo_pay_admin/usuarios_por_dominio/locator.dart';

var locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.allowReassignment = true;
  locator = await CoreLocator().setup(locator);
  //pages
  LazyLoadingLocator().setup();
  LoginLocator().setup();
  ForgetPasswordLocator().setup();
  SyncLocator().setup();
  //sysadmin
  DomainLocator().setup();
  UsersLocator().setup();
  RoleLocator().setup();
  RouteLocator().setup();
  ApplicationLocator().setup();
  UsersDomainLocator().setup();

  //admin
  MatrizAccountLocator().setup();
  DomainAccountLocator().setup();
  PixToSendLocator().setup();
  ExtratoLocator().setup();
  PayFacsLocator().setup();
  FuncionarioLocator().setup();
  ParceiroLocator().setup();
  DashboardLocator().setup();

  //appBuilder
  AppBuilderLocator().setup();
  PopMenuLocator().setup();
  HeaderSearchLocator().setup();
  ThemeLocator().setup();
  CoreLocator().setCoreLocator(locator);
}
