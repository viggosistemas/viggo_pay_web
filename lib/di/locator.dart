import 'package:get_it/get_it.dart';
import 'package:viggo_pay_admin/app_builder/locator.dart';
import 'package:viggo_pay_admin/chaves_pix/locator.dart';
import 'package:viggo_pay_admin/empresas/locator.dart';
import 'package:viggo_pay_admin/forget_password/locator.dart';
import 'package:viggo_pay_admin/historico_transacoes/locator.dart';
import 'package:viggo_pay_admin/login/locator.dart';
import 'package:viggo_pay_admin/sync/locator.dart';
import 'package:viggo_pay_admin/transacao_contas/locator.dart';
import 'package:viggo_pay_core_frontend/di/locator.dart';

var locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.allowReassignment = true;
  locator = await CoreLocator().setup(locator);
  LoginLocator().setup();
  SyncLocator().setup();
  AppBuilderLocator().setup();
  DomainAccountLocator().setup();
  ChavePixLocator().setup();
  HistoricoTransacoesLocator().setup();
  TransacaoContaLocator().setup();
  ForgetPasswordLocator().setup();
  CoreLocator().setCoreLocator(locator);
}