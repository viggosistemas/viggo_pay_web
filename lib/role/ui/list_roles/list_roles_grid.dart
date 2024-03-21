import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/role/data/models/role_api_dto.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
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

  static const rolesRowValues = ['name'];

  List<Map<String, dynamic>> searchFields = [
    {
      'label': 'Nome',
      'search_field': 'name',
      'type': 'text',
      'icon': Icons.abc,
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
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Carregando...'),
              SizedBox(
                height: 10,
              ),
              CircularProgressIndicator(),
            ],
          );
        } else {
          List<RoleApiDto> items = (snapshot.data as List<RoleApiDto>);
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
                    child: DataTablePaginated(
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
        }
      },
    );
  }
}
