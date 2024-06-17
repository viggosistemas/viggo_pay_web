import 'package:viggo_core_frontend/token/domain/usecases/get_token_use_case.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/lazy_loading/ui/lazy_loading_view_model.dart';

class LazyLoadingLocator {
  void setup() {
    // ViewModels
    locator.registerFactory(
      () => LazyLoadingViewModel(
        getToken: locator.get<GetTokenUseCase>(),
      ),
    );
  }
}
