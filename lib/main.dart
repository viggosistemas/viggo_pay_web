import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:viggo_pay_admin/dashboard/ui/dashboard_page.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain/ui/list_domains/list_domains_page.dart';
import 'package:viggo_pay_admin/domain_account/ui/list_domain_accounts/list_domain_accounts_page.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_page.dart';
import 'package:viggo_pay_admin/historico/ui/timeline_historico_transacao.dart';
import 'package:viggo_pay_admin/login/ui/login_page.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/list_pix_to_send/list_pix_to_send_page.dart';
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
          color: kColorScheme.primary,
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
        //admin
        Routes.DOMAIN_ACCOUNTS: (ctx) =>
            ListDomainAccountPage(changeTheme: changeTheme),
        Routes.PIX: (ctx) => ListPixToSendPage(changeTheme: changeTheme),
        Routes.HISTORICO: (ctx) => TimelineTransacaoPage(changeTheme: changeTheme),
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
