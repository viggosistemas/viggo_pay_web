import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/themes/theme_view_model.dart';

class ThemeLocator {
  void setup() {
    locator.registerLazySingleton(
      () => ThemeViewModel(
        sharedPrefs: locator.get<SharedPreferences>(),
      ),
    );
  }
}
