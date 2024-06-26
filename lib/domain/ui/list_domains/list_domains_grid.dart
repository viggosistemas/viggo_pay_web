import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/card/list_view_mode_card.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/table/data_table_paginated.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain/ui/edit_domains/edit_domains.dart';
import 'package:viggo_pay_admin/domain/ui/list_domains/list_domain_web_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class ListDomainsGrid extends StatefulWidget {
  const ListDomainsGrid({super.key});

  @override
  State<ListDomainsGrid> createState() => _ListDomainsGridState();
}

class _ListDomainsGridState extends State<ListDomainsGrid> {
  ListDomainWebViewModel viewModel = locator.get<ListDomainWebViewModel>();

  static const domainsValidActions = [
    {
      'backendUrl': '/domains',
      'method': 'POST',
    },
    {
      'backendUrl': '/domains/<id>',
      'method': 'PUT',
    },
    {
      'backendUrl': '/domains/<id>',
      'method': 'DELETE',
    },
  ];

  static const domainsRowsValues = ['name', 'display_name', 'application'];

  static const domainsListLabelIncludes = ['name'];

  List<Map<String, dynamic>> searchFields = [
    {
      'label': 'Nome',
      'search_field': 'name',
      'type': 'text',
      'icon': Icons.abc,
    },
    {
      'label': 'Nome formal',
      'search_field': 'display_name',
      'type': 'text',
      'icon': Icons.abc,
    },
    {
      'label': 'Aplicação',
      'search_field': 'application.name',
      'type': 'text',
      'icon': Icons.domain_outlined,
    },
  ];

  Map<String, String> filters = {
    'order_by': 'name',
    'list_options': ListOptions.ACTIVE_ONLY.name,
  };

  void onSearch(List<Map<String, dynamic>> params) {
    filters = {};
    var newParams = params
        .map((e) => {
              'search_field': e['search_field'],
              'value': e['value'],
              'type': e['type'],
            })
        .toList();

    for (var element in newParams) {
      if (element['value'].toString().isNotEmpty) {
        var fieldValue = '';

        if (element['type'] == 'text') {
          fieldValue = '%${element['value']}%';
        } else {
          fieldValue = element['value'];
        }
        filters.addEntries(
          <String, String>{element['search_field']: fieldValue}.entries,
        );
      }
    }

    filters.addEntries(
      <String, String>{'order_by': 'name'}.entries,
    );

    viewModel.loadData(filters);
  }

  onReload() {
    viewModel.loadData(filters);
  }

  @override
  Widget build(BuildContext context) {
    final dialogs = EditDomains(context: context);
    onReload();

    viewModel.errorMessage.listen(
      (value) {
        if (value.isNotEmpty && context.mounted) {
          viewModel.clearError();
          showInfoMessage(
            context,
            2,
            Colors.red,
            value,
            'X',
            () {},
            Colors.white,
          );
        }
      },
    );
    return StreamBuilder<List<DomainApiDto>>(
      stream: viewModel.domains,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          onReload();
          return ProgressLoading(
            color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
          );
        } else {
          List<DomainApiDto> items = (snapshot.data as List<DomainApiDto>);
          return LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              height: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    HeaderSearchMain(
                      onReload: onReload,
                      onSearch: onSearch,
                      searchFields: searchFields,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: constraints.maxWidth <= 960
                          ? Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: ListViewCard(
                                onReloadData: onReload,
                                viewModel: viewModel,
                                dialogs: dialogs,
                                fieldsData: 'name',
                                fieldsSubtitleData: 'application.name',
                                validActionsList: domainsValidActions,
                                items: items.map((e) {
                                  return e.toJson();
                                }).toList(),
                              ),
                            )
                          : DataTablePaginated(
                              viewModel: viewModel,
                              streamList: viewModel.domains,
                              dialogs: dialogs,
                              initialFilters: filters,
                              columnsDef: const [
                                DataColumn(
                                  label: Text(
                                    'Nome',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Nome formal',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Aplicação',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              labelInclude: domainsListLabelIncludes,
                              fieldsData: domainsRowsValues,
                              validActionsList: domainsValidActions,
                              items: items.map((e) {
                                return e.toJson();
                              }).toList(),
                            ),
                    ),
                    // DataTableNotPaginated(
                    //   viewModel: viewModel,
                    //   items: items,
                    // ),
                  ],
                ),
              ),
            );
          });
        }
      },
    );
  }
}
