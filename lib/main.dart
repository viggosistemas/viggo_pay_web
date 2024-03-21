import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viggo_pay_admin/application/ui/edit_capability/edit_capability_page.dart';
import 'package:viggo_pay_admin/application/ui/edit_policy/edit_policy_page.dart';
import 'package:viggo_pay_admin/application/ui/list_applications/list_applications_page.dart';
import 'package:viggo_pay_admin/dashboard/ui/dashboard_page.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain/ui/list_domains/list_domains_page.dart';
import 'package:viggo_pay_admin/domain_account/ui/list_domain_accounts/list_domain_accounts_page.dart';
import 'package:viggo_pay_admin/extrato/ui/timeline_extrato_page.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_page.dart';
import 'package:viggo_pay_admin/funcionario/ui/list_funcionario/list_funcionario_page.dart';
import 'package:viggo_pay_admin/login/ui/login_page.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/matriz_info.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/list_pix_to_send/list_pix_to_send_page.dart';
import 'package:viggo_pay_admin/role/ui/list_roles/list_roles_page.dart';
import 'package:viggo_pay_admin/route/ui/list_routes/list_routes_page.dart';
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

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF324581),
  primary: const Color(0xFF324581),
  secondary: const Color(0xFFEED333),
);

var kColorSchemeDark = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 5, 99, 125),
  primary: const Color(0xFF324581),
  secondary: const Color(0xFFEED333),
  brightness: Brightness.dark,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const ViggoPayWeb());
}

class ViggoPayWeb extends StatefulWidget {
  const ViggoPayWeb({super.key});

  @override
  State<ViggoPayWeb> createState() {
    return _ViggoPayWebState();
  }
}

class _ViggoPayWebState extends State<ViggoPayWeb> {
  var _themeMode = ThemeMode.light;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.APP_NAME,
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.primary,
          foregroundColor: kColorScheme.primaryContainer,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black,
          elevation: 10,
        ),
        dataTableTheme: const DataTableThemeData(
          dataRowColor: MaterialStatePropertyAll(
            Colors.white,
          ),
          headingRowColor: MaterialStatePropertyAll(
            Colors.white,
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: kColorScheme.primary,
            focusColor: kColorScheme.primary,
            surfaceTintColor: kColorScheme.primary,
          ),
        ),
        iconTheme: const IconThemeData().copyWith(
          color: kColorScheme.primary
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.lato(),
          titleMedium: GoogleFonts.lato(),
          titleSmall: GoogleFonts.lato(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primary,
            foregroundColor: kColorScheme.onPrimary,
            padding: const EdgeInsets.all(16),
            textStyle: GoogleFonts.lato(
              color: kColorScheme.onPrimary,
              fontSize: 16,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            surfaceTintColor: kColorScheme.onPrimary,
            foregroundColor: kColorScheme.primary,
            textStyle: GoogleFonts.roboto(
              color: kColorScheme.onPrimary,
              fontSize: 18,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kColorSchemeDark,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorSchemeDark.inversePrimary,
          foregroundColor: kColorSchemeDark.onPrimaryContainer,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
        ),
        dataTableTheme: const DataTableThemeData(
          dataRowColor: MaterialStatePropertyAll(
            Colors.white,
          ),
          headingRowColor: MaterialStatePropertyAll(
            Colors.white,
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: kColorScheme.primary,
            focusColor: kColorScheme.primary,
            surfaceTintColor: kColorScheme.primary,
          ),
        ),
        iconTheme: const IconThemeData().copyWith(
          color: kColorScheme.primary,
        ),
      ),
      routes: {
        Routes.HOME: (ctx) => LoginPage(changeTheme: changeTheme),
        Routes.LOGIN_PAGE: (ctx) => LoginPage(changeTheme: changeTheme),
        Routes.FORGET_PASSWORD: (ctx) =>
            ForgetPassPage(changeTheme: changeTheme),
        Routes.WORKSPACE: (ctx) => DashboardPage(changeTheme: changeTheme),
        //sysadmin
        Routes.DOMAINS: (ctx) => ListDomainsPage(changeTheme: changeTheme),
        Routes.USERS: (ctx) => ListUsersPage(changeTheme: changeTheme),
        Routes.USERS_FOR_DOMAIN: (ctx) => ListUsersDomainPage(changeTheme: changeTheme),
        Routes.ROLES: (ctx) => ListRolesPage(changeTheme: changeTheme),
        Routes.ROUTES: (ctx) => ListRoutesPage(changeTheme: changeTheme),
        Routes.APPLICATIONS: (ctx) => ListApplicationsPage(changeTheme: changeTheme),
        Routes.EDIT_CAPABILITY: (ctx) => EditCapabilityPage(changeTheme: changeTheme),
        Routes.EDIT_POLICY: (ctx) => EditPolicyPage(changeTheme: changeTheme),
        //admin
        Routes.DOMAIN_ACCOUNTS: (ctx) =>
            ListDomainAccountPage(changeTheme: changeTheme),
        Routes.PIX: (ctx) => ListPixToSendPage(changeTheme: changeTheme),
        Routes.EXTRATO: (ctx) =>
            TimelineExtratoPage(changeTheme: changeTheme),
        Routes.MATRIZ: (ctx) => MatrizInfoPage(changeTheme: changeTheme),
        Routes.MATRIZ_TRANSFERENCIA: (ctx) => MatrizTransferenciaPage(changeTheme: changeTheme),
        Routes.FUNCIONARIO: (ctx) => ListFuncionarioPage(changeTheme: changeTheme),
      },
      themeMode: _themeMode,
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

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
