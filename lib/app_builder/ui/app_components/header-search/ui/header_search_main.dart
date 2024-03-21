import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';

// ignore: must_be_immutable
class HeaderSearchMain extends StatelessWidget {
  HeaderSearchMain({
    super.key,
    required this.searchFields,
    required this.onSearch,
    required this.onReload,
    notShowAdvancedFilters,
  }){
    if(notShowAdvancedFilters != null){
      this.notShowAdvancedFilters = notShowAdvancedFilters;
    }
  }

  final List<Map<String, dynamic>> searchFields;
  final Function(List<Map<String,dynamic>> params) onSearch;
  final Function onReload;
  bool notShowAdvancedFilters = false;

  @override
  Widget build(context) {
    return ChangeNotifierProvider(
      create: (_) => locator.get<HeaderSearchViewModel>(),
      child: HeaderSearch(
        searchFields: searchFields,
        onSearch: onSearch,
        onReload: onReload,
        notShowAdvancedFilters: notShowAdvancedFilters,
      ),
    );
  }
}
