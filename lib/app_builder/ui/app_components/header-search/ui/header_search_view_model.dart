import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_form_fields.dart';

class HeaderSearchViewModel extends ChangeNotifier {
  bool isLoading = false;
  final HeaderSearchFormFields form = HeaderSearchFormFields();

  HeaderSearchViewModel();

  void notifyLoading() {
    isLoading = !isLoading;
    // notifyListeners();
  }

  void onSearch(
    BuildContext context,
    List<Map<String, dynamic>> listFilters,
  ) {
    print(listFilters);
  }
}
