import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/update_user_use_case.dart';

class PopMenuLocator {
  void setup() {
    // ViewModels
    locator.registerFactory(
      () => PopMenuViewModel(
        userUpdateUseCase: locator.get<UpdateUserUseCase>(),
      ),
    );
  }
}
