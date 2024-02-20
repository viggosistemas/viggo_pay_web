import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';

class HeaderSearchMain extends StatelessWidget {
  const HeaderSearchMain({
    super.key,
    required this.searchFields,
  });

  final List<Map<String, dynamic>> searchFields;

  @override
  Widget build(context) {
    return ChangeNotifierProvider(
      create: (_) => locator.get<HeaderSearchViewModel>(),
      child: HeaderSearch(
        searchFields: searchFields,
      ),
    );
  }
}
