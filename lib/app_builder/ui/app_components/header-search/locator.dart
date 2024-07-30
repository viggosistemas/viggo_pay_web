import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';

class HeaderSearchLocator {
  void setup() {
    // ViewModels
    locator.registerFactory(
      () => HeaderSearchViewModel(),
    );
  }
}
