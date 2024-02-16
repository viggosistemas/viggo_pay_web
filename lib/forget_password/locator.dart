import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_view_model.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/restore_password_use_case.dart';

class ForgetPasswordLocator {
  void setup(){
    // ViewModel
    locator.registerFactory(
      () => ForgetPasswordViewModel(
        restorePassword: locator.get<RestorePasswordUseCase>(),
      ),
    );
  }
}
