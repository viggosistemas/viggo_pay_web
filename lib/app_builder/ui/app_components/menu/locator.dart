import 'package:viggo_core_frontend/user/domain/usecases/get_user_use_case.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/ui/menu_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';

class MenuLocator {
  void setup() {
    // ViewModels
    locator.registerFactory(
      () => MenuViewModel(
        getUserFromSettings: locator.get<GetUserUseCase>(),
      ),
    );
  }
}
