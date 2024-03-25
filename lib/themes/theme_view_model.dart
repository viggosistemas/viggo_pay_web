import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';

class ThemeViewModel extends BaseViewModel {
  SharedPreferences sharedPrefs;

  final StreamController<String?> _streamControllerThemeMode =
      StreamController<String?>.broadcast();
  Stream<String?> get theme => _streamControllerThemeMode.stream;

  ThemeViewModel({
    required this.sharedPrefs,
  });

  String get themePrefs {
    return sharedPrefs.getString('THEME_MODE') ?? 'dark';
  }

  changeTheme(String themeMode) {
    sharedPrefs.setString('THEME_MODE', themeMode);
    _streamControllerThemeMode.sink.add(themeMode);
  }

  get backgroundAsset {
    return themePrefs == 'dark'
        ? 'assets/images/login-bg.png'
        : 'assets/images/login-bg.png';
  }

  get logoAsset {
    return themePrefs == 'dark'
        ? 'assets/images/logo_dark.png'
        : 'assets/images/logo.png';
  }
}
