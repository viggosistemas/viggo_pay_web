import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/card/list_view_mode_card.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/table/data_table_paginated.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/edit_funcionario.dart';
import 'package:viggo_pay_admin/funcionario/ui/list_funcionario/list_funcionario_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class ListFuncionarioGrid extends StatefulWidget {
  const ListFuncionarioGrid({super.key});

  @override
  State<ListFuncionarioGrid> createState() => _ListFuncionarioGridState();
}

class _ListFuncionarioGridState extends State<ListFuncionarioGrid> {
  ListFuncionarioViewModel viewModel = locator.get<ListFuncionarioViewModel>();

  static const funcionariosValidActions = [
    {
      'backendUrl': '/funcionarios',
      'method': 'POST',
    },
    {
      'backendUrl': '/funcionarios/<id>',
      'method': 'PUT',
    },
    {
      'backendUrl': '/funcionarios/<id>',
      'method': 'DELETE',
    },
  ];

  static const funcionariosRowsValues = ['parceiro', 'parceiro', 'user'];

  static const funcionariosListLabelInclude = ['nome_razao_social', 'cpf_cnpj', 'name'];

  List<Map<String, dynamic>> searchFields = [
    {
      'label': 'Nome',
      'search_field': 'parceiro.nome_razao_social',
      'type': 'text',
      'icon': Icons.person_outline,
    },
    {
      'label': 'CPF/CNPJ',
      'search_field': 'parceiro.cpf_cnpj',
      'type': 'cpf_cnpj',
      'icon': Icons.numbers_outlined,
    },
  ];

  Map<String, String> filters = {
    'order_by': 'id',
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
        } else if (element['type'] == 'cpf_cnpj') {
          fieldValue = element['value'].replaceAll('.', '').replaceAll('-', '').replaceAll('/', '');
        } else {
          fieldValue = element['value'];
        }
        filters.addEntries(
          <String, String>{element['search_field']: fieldValue}.entries,
        );
      }
    }

    filters.addEntries(
      <String, String>{'order_by': 'id'}.entries,
    );

    viewModel.loadData(filters);
  }

  onReload() {
    viewModel.loadData(filters);
  }

  @override
  Widget build(BuildContext context) {
    final dialogs = EditFuncionario(context: context);
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
    return StreamBuilder<List<FuncionarioApiDto>>(
      stream: viewModel.funcionarios,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          onReload();
          return ProgressLoading(
            color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
          );
        } else {
          List<FuncionarioApiDto> items = (snapshot.data as List<FuncionarioApiDto>);
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
                      onSearch: onSearch,
                      onReload: onReload,
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
                                fieldsData: 'parceiro.nome_razao_social',
                                fieldsSubtitleData: 'parceiro.cpf_cnpj',
                                iconCard: Icons.engineering_outlined,
                                validActionsList: funcionariosValidActions,
                                items: items.map((e) {
                                  return e.toJson();
                                }).toList(),
                              ),
                            )
                          : DataTablePaginated(
                              viewModel: viewModel,
                              streamList: viewModel.funcionarios,
                              initialFilters: filters,
                              columnsDef: const [
                                DataColumn(
                                  label: Center(
                                    child: Text(
                                      'Nome razão social',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Center(
                                    child: Text(
                                      'CPF/CNPJ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Center(
                                    child: Text(
                                      'Usuário',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              labelInclude: funcionariosListLabelInclude,
                              fieldsData: funcionariosRowsValues,
                              validActionsList: funcionariosValidActions,
                              dialogs: dialogs,
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
