import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/edit_pix_to_send/edit_pix_to_sends.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/list_pix_to_send/list_pix_to_send_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class ListPixToSendGrid extends StatefulWidget {
  const ListPixToSendGrid({super.key});

  @override
  State<ListPixToSendGrid> createState() => _ListPixToSendGridState();
}

class _ListPixToSendGridState extends State<ListPixToSendGrid> {
  ListPixToSendViewModel viewModel = locator.get<ListPixToSendViewModel>();
  static const pixToSendsValidActions = [
    {
      'backendUrl': '/pix_to_sends/<id>',
      'method': 'GET',
    },
    {
      'backendUrl': '/pix_to_sends/<id>',
      'method': 'DELETE',
    },
  ];

  static const pixToSendRowsValues = ['alias', 'holder_name', 'psp_name'];

  List<Map<String, dynamic>> searchFields = [
    {
      'label': 'Chave',
      'search_field': 'alias',
      'type': 'text',
      'icon': Icons.key_outlined,
    },
  ];

  Map<String, String> filters = {
    'order_by': 'holder_name',
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
      <String, String>{'order_by': 'holder_name'}.entries,
    );

    viewModel.loadData(filters);
  }

  onReload() {
    viewModel.loadData(filters);
  }

  @override
  Widget build(BuildContext context) {
    final dialogs = EditPixToSends(context: context);
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
    return StreamBuilder<Object>(
      stream: viewModel.pixToSends,
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
          List<PixToSendApiDto> items =
              (snapshot.data as List<PixToSendApiDto>);
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
                      streamList: viewModel.pixToSends,
                      initialFilters: filters,
                      columnsDef: const [
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Chave',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Proprietário',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Instituição',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                      addFunction: () => dialogs.addDialog(null),
                      validActionsList: pixToSendsValidActions,
                      fieldsData: pixToSendRowsValues,
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
