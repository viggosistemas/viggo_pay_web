import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/role/data/models/role_api_dto.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/card/list_view_mode_card.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/table/data_table_paginated.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/role/ui/edit_roles/edit_roles.dart';
import 'package:viggo_pay_admin/role/ui/list_roles/list_role_web_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class ListRolesGrid extends StatefulWidget {
  const ListRolesGrid({super.key});

  @override
  State<ListRolesGrid> createState() => _ListRolesGridState();
}

class _ListRolesGridState extends State<ListRolesGrid> {
  ListRoleWebViewModel viewModel = locator.get<ListRoleWebViewModel>();

  final List<Map<String, dynamic>> itemSelect = [
    {
      'value': RoleDataView.DOMAIN.name,
      'label': RoleDataView.DOMAIN.name,
      'type': 'enum',
    },
    {
      'value': RoleDataView.MULTI_DOMAIN.name,
      'label': RoleDataView.MULTI_DOMAIN.name.replaceAll('_', ' '),
      'type': 'enum',
    },
  ];

  static const rolesValidActions = [
    {
      'backendUrl': '/roles',
      'method': 'POST',
    },
    {
      'backendUrl': '/roles/<id>',
      'method': 'PUT',
    },
    {
      'backendUrl': '/roles/<id>',
      'method': 'DELETE',
    },
  ];

  static const rolesRowValues = ['name', 'dataView'];

  List<Map<String, dynamic>> searchFields = [
    {
      'label': 'Nome',
      'search_field': 'name',
      'type': 'text',
      'icon': Icons.abc,
    },
    {
      'label': 'Tipo',
      'search_field': 'data_view',
      'type': 'enum',
      'icon': Icons.shape_line_outlined,
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
    final dialogs = EditRoles(context: context);
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
    return StreamBuilder<List<RoleApiDto>>(
      stream: viewModel.roles,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          onReload();
          return ProgressLoading(
            color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
          );
        } else {
          List<RoleApiDto> items = (snapshot.data as List<RoleApiDto>);
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
                      itemsSelect: itemSelect,
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
                                fieldsSubtitleData: 'dataView',
                                validActionsList: rolesValidActions,
                                items: items.map((e) {
                                  return e.toJson();
                                }).toList(),
                              ),
                            )
                          : DataTablePaginated(
                              viewModel: viewModel,
                              streamList: viewModel.roles,
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
                                    'Tipo',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              fieldsData: rolesRowValues,
                              validActionsList: rolesValidActions,
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
