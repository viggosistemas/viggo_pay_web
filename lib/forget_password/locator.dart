import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_view_model.dart';

class ForgetPasswordLocator {
  void setup(){
    // ViewModel
    locator.registerFactory(
      () => ForgetPasswordViewModel(),
    );
  }
}
