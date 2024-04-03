import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/card/list_view_mode_card.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/table/data_table_paginated.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
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
    {
      'label': 'Proprietário',
      'search_field': 'holder_name',
      'type': 'text',
      'icon': Icons.person_outline,
    },
    {
      'label': 'Instituição',
      'search_field': 'psp_name',
      'type': 'text',
      'icon': Icons.domain_outlined,
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
    return StreamBuilder<List<PixToSendApiDto>>(
      stream: viewModel.pixToSends,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          onReload();
          return ProgressLoading(
            color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
          );
        } else {
          List<PixToSendApiDto> items = (snapshot.data as List<PixToSendApiDto>);
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
                                fieldsData: 'alias',
                                iconCard: Icons.key,
                                fieldsSubtitleData: 'holder_name',
                                validActionsList: pixToSendsValidActions,
                                items: items.map((e) {
                                  return e.toJson();
                                }).toList(),
                              ),
                            )
                          : DataTablePaginated(
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
          });
        }
      },
    );
  }
}
