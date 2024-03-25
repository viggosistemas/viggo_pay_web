import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:viggo_pay_admin/application/ui/edit_capability/edit_capability_page.dart';
import 'package:viggo_pay_admin/application/ui/edit_policy/edit_policy_page.dart';
import 'package:viggo_pay_admin/application/ui/list_applications/list_applications_page.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
import 'package:viggo_pay_admin/dashboard/ui/dashboard_page.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain/ui/list_domains/list_domains_page.dart';
import 'package:viggo_pay_admin/domain_account/ui/list_domain_accounts/list_domain_accounts_page.dart';
import 'package:viggo_pay_admin/extrato/ui/timeline_extrato_page.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_page.dart';
import 'package:viggo_pay_admin/funcionario/ui/list_funcionario/list_funcionario_page.dart';
import 'package:viggo_pay_admin/lazy_loading/ui/lazy_loading_page/lazy_loading_page.dart';
import 'package:viggo_pay_admin/login/ui/login_page.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/matriz_info.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/list_pix_to_send/list_pix_to_send_page.dart';
import 'package:viggo_pay_admin/role/ui/list_roles/list_roles_page.dart';
import 'package:viggo_pay_admin/route/ui/list_routes/list_routes_page.dart';
import 'package:viggo_pay_admin/themes/dark_theme.dart';
import 'package:viggo_pay_admin/themes/light_theme.dart';
import 'package:viggo_pay_admin/themes/theme_view_model.dart';
import 'package:viggo_pay_admin/user/ui/list_users/list_users_page.dart';
import 'package:viggo_pay_admin/usuarios_por_dominio/ui/list_users_domain_page.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

//CONFIGURACAO DOS CARDS DO DASHBOARD
const defaultPadding = 16.0;

const kLightBlue = Color(0xffEBF6FF);
const kDarkBlue = Color(0xff369FFF);
const kGreen = Color(0xff8AC53E);
const kOrange = Color(0xffFF993A);
const kYellow = Color(0xffFFD143);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(ViggoPayWeb());
}

// ignore: must_be_immutable
class ViggoPayWeb extends StatelessWidget {
  ViggoPayWeb({super.key});

  ThemeViewModel themeViewModel = locator.get<ThemeViewModel>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: themeViewModel.theme,
      builder: (context, themeData) {
        if (themeData.data == null) {
          themeViewModel.changeTheme(themeViewModel.themePrefs);
          return const ProgressLoading();
        } else {
          return MaterialApp(
            title: Constants.APP_NAME,
            theme: LightTheme().theme,
            darkTheme: DarkTheme().theme,
            routes: {
              Routes.HOME: (ctx) => const LazyLoadingPage(),
              Routes.LOGIN_PAGE: (ctx) => const LoginPage(),
              Routes.FORGET_PASSWORD: (ctx) => const ForgetPassPage(),
              Routes.WORKSPACE: (ctx) => const DashboardPage(),
              //sysadmin
              Routes.DOMAINS: (ctx) => const ListDomainsPage(),
              Routes.USERS: (ctx) => const ListUsersPage(),
              Routes.USERS_FOR_DOMAIN: (ctx) => const ListUsersDomainPage(),
              Routes.ROLES: (ctx) => const ListRolesPage(),
              Routes.ROUTES: (ctx) => const ListRoutesPage(),
              Routes.APPLICATIONS: (ctx) => const ListApplicationsPage(),
              Routes.EDIT_CAPABILITY: (ctx) => const EditCapabilityPage(),
              Routes.EDIT_POLICY: (ctx) => const EditPolicyPage(),
              //admin
              Routes.DOMAIN_ACCOUNTS: (ctx) => const ListDomainAccountPage(),
              Routes.PIX: (ctx) => const ListPixToSendPage(),
              Routes.EXTRATO: (ctx) => const TimelineExtratoPage(),
              Routes.MATRIZ: (ctx) => const MatrizInfoPage(),
              Routes.MATRIZ_TRANSFERENCIA: (ctx) => MatrizTransferenciaPage(),
              Routes.FUNCIONARIO: (ctx) => const ListFuncionarioPage(),
            },
            themeMode:
                themeData.data == 'dark' ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('pt', 'BR'),
              Locale('pt_BR'),
            ],
          );
        }
      },
    );
  }
}
