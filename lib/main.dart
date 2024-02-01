import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:viggo_pay_admin/dashboard/ui/dashboard_page.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/login/ui/login_page.dart';
import 'package:viggo_pay_admin/utils/constants.dart';


// PRIMEIRO CRIEI O LOCATOR QUE INSTANCIA O LOCATOR DO CORE
// DEPOIS CRIEI A CLASSE DE CONTANTS COM AS ROTAS E VARIAVEIS CONSTS
// DEPOIS CRIEI O PACOTE SYNC
// DEPOIS CRIEI O PACOTE DOMAIN
// E POR FIM O PACOTE USER

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
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kColorSchemeDark,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorSchemeDark.inversePrimary,
          foregroundColor: kColorSchemeDark.onPrimaryContainer,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      routes: {
        Routes.HOME: (ctx) => const LoginPage(),
        Routes.LOGIN_PAGE: (ctx) => const LoginPage(),
        Routes.WORKSPACE: (ctx) => const DashboardPage(),
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
