import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_core_frontend/util/constants.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/card/list_view_mode_card.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/table/data_table_paginated.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/user/ui/edit_users/edit_users.dart';
import 'package:viggo_pay_admin/user/ui/list_users/list_users_web_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

// ignore: must_be_immutable
class ListUsersGrid extends StatefulWidget {
  ListUsersGrid({
    super.key,
    domain,
  }) {
    if (domain != null) {
      this.domain = domain;
    }
  }

  // ignore: avoid_init_to_null
  late DomainApiDto? domain = null;

  @override
  State<ListUsersGrid> createState() => _ListUsersGridState();
}

class _ListUsersGridState extends State<ListUsersGrid> {
  ListUserWebViewModel viewModel = locator.get<ListUserWebViewModel>();

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
    {
      'label': 'Domínio',
      'search_field': 'domain.name',
      'type': 'text',
      'icon': Icons.cases_outlined,
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

    if (widget.domain != null) {
      filters.addEntries(
        <String, String>{'domain_id': widget.domain!.id}.entries,
      );
    }

    viewModel.loadData(filters);
  }

  onReload() {
    if (widget.domain != null) {
      filters.addEntries(
        <String, String>{'domain_id': widget.domain!.id}.entries,
      );
    }
    viewModel.loadData(filters);
  }

  disabledToSysadmin(List<Map<String, dynamic>> selected) {
    if (selected.length == 1) {
      var selectedSysadmin = selected.where((e) => e['name'].toLowerCase() == 'sysadmin').toList();
      if (selectedSysadmin.isNotEmpty) {
        showInfoMessage(
          context,
          2,
          Colors.red,
          'Não é permitido realizar ações com usuário sysadmin!',
          'X',
          () {},
          Colors.white,
        );
        return !selectedSysadmin.isNotEmpty;
      }
      return true;
    }
    return false;
  }

  disabledActions(List<Map<String, dynamic>> selected) {
    if (selected.isNotEmpty) {
      String? userJson = viewModel.sharedPrefs.getString(CoreUserPreferences.USER);
      UserApiDto user = UserApiDto.fromJson(jsonDecode(userJson!));
      var selectedSysadmin = selected.where((e) => e['name'].toLowerCase() == 'sysadmin').toList();
      var selectedIsUser = selected.where((e) => e['id'] == user.id).toList();
      if (selectedSysadmin.isNotEmpty) {
        showInfoMessage(
          context,
          2,
          Colors.red,
          'Não é permitido realizar ações com usuário sysadmin!',
          'X',
          () {},
          Colors.white,
        );
        return !selectedSysadmin.isNotEmpty;
      }
      if (selectedIsUser.isNotEmpty) {
        showInfoMessage(
          context,
          2,
          Colors.red,
          'Não é permitido realizar esse tipo de alteração no usuário logado!',
          'X',
          () {},
          Colors.white,
        );
        return !selectedIsUser.isNotEmpty;
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final dialogs = EditUsers(
      context: context,
      domain: widget.domain,
    );
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
    return StreamBuilder<List<UserApiDto>>(
      stream: viewModel.users,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          onReload();
          return ProgressLoading(
            color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
          );
        } else {
          List<UserApiDto> items = (snapshot.data as List<UserApiDto>);
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
                                fieldsSubtitleData: 'domain.name',
                                validActionsList: usersValidActions,
                                items: items.map((e) {
                                  return e.toJson();
                                }).toList(),
                              ),
                            )
                          : DataTablePaginated(
                              viewModel: viewModel,
                              streamList: viewModel.users,
                              dialogs: dialogs,
                              initialFilters: filters,
                              disabledActionFunction: (List<Map<String, dynamic>> selected) => disabledActions(selected),
                              disabledChangeActiveFunction: (List<Map<String, dynamic>> selected) => disabledActions(selected),
                              disabledEditFunction: (List<Map<String, dynamic>> selected) => disabledToSysadmin(selected),
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
          });
        }
      },
    );
  }
}
