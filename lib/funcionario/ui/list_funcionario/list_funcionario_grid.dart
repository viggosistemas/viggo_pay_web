import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/edit_funcionario.dart';
import 'package:viggo_pay_admin/funcionario/ui/list_funcionario/list_funcionario_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class ListFuncionarioGrid extends StatefulWidget {
  const ListFuncionarioGrid({super.key});

  @override
  State<ListFuncionarioGrid> createState() => _ListFuncionarioGridState();
}

class _ListFuncionarioGridState extends State<ListFuncionarioGrid> {
  late ListFuncionarioViewModel viewModel;

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

  static const funcionariosListLabelInclude = [
    'nome_razao_social',
    'cpf_cnpj',
    'name'
  ];

  List<Map<String, dynamic>> searchFields = [
    {
      'label': 'Nome',
      'search_field': 'parceiro.nome_razao_social',
      'type': 'text',
      'icon': Icons.person_outline,
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
      <String, String>{'order_by': 'id'}.entries,
    );

    viewModel.loadData(filters);
  }

  onReload() {
    viewModel.loadData(filters);
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<ListFuncionarioViewModel>(context);
    final dialogs = EditFuncionario(context: context);
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
      stream: viewModel.funcionarios,
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
          List<FuncionarioApiDto> items =
              (snapshot.data as List<FuncionarioApiDto>);
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
                    child: DataTablePaginated(
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
        }
      },
    );
  }
}
