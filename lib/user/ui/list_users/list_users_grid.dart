import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/user/ui/edit_users/edit_users.dart';
import 'package:viggo_pay_admin/user/ui/list_users/list_users_web_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';
import 'package:viggo_pay_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class ListUsersGrid extends StatefulWidget {
  const ListUsersGrid({super.key});

  @override
  State<ListUsersGrid> createState() => _ListUsersGridState();
}

class _ListUsersGridState extends State<ListUsersGrid> {
  late ListUserWebViewModel viewModel;

  static const usersValidActions = [
    {
      'backendUrl': '/users',
      'method': 'POST',
    },
    {
      'backendUrl': '/users/<id>',
      'method': 'PUT',
    },
    {
      'backendUrl': '/users/<id>',
      'method': 'DELETE',
    },
  ];

  static const usersRowsValues = ['name', 'email', 'domain'];

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
    viewModel = Provider.of<ListUserWebViewModel>(context);
    final dialogs = EditUsers(context: context);
    onReload();

    viewModel.error.listen(
      (value) {
        showInfoMessage(
          context,
          2,
          Colors.red,
          value,
          'X',
          () {},
          Colors.white,
        );
      },
    );
    return StreamBuilder<Object>(
      stream: viewModel.users,
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
          List<UserApiDto> items = (snapshot.data as List<UserApiDto>);
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
                      streamList: viewModel.users,
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
                            'Email',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Domínio',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      labelInclude: const ['name'],
                      fieldsData: usersRowsValues,
                      validActionsList: usersValidActions,
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
