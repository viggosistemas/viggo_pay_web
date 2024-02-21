import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/lazy_loading/ui/lazy_loading_view_model.dart';
import 'package:viggo_pay_admin/sync/domain/usecases/get_app_state_use_case.dart';

class LazyLoadingLocator {
  void setup() {
    // ViewModels
    locator.registerFactory(
      () => LazyLoadingViewModel(
        getAppState: locator.get<GetAppStateUseCase>(),
      ),
    );
  }
}
