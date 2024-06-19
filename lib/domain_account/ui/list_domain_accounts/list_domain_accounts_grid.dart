// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/card/list_view_mode_card.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/table/data_table_paginated.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/config_domain_accounts/config_domain_accounts.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts.dart';
import 'package:viggo_pay_admin/domain_account/ui/list_domain_accounts/list_domain_accounts_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class ListDomainAccountsGrid extends StatefulWidget {
  const ListDomainAccountsGrid({super.key});

  @override
  State<ListDomainAccountsGrid> createState() => _ListDomainAccountsGridState();
}

class _ListDomainAccountsGridState extends State<ListDomainAccountsGrid> {
  ListDomainAccountViewModel viewModel = locator.get<ListDomainAccountViewModel>();

  static const domainAccountsValidActions = [
    {
      'backendUrl': '/domain_accounts/<id>',
      'method': 'GET',
    },
    {
      'backendUrl': '/domain_accounts/<id>',
      'method': 'DELETE',
    },
  ];

  static const domainAccountRowsValues = [
    'matera_id',
    'client_name',
    'client_tax_identifier_tax_id',
    'tem_chave_pix',
    'tem_taxa',
    'status',
  ];

  List<Map<String, dynamic>> searchFields = [
    {
      'label': 'Cliente',
      'search_field': 'client_name',
      'type': 'text',
      'icon': Icons.person_outline,
    },
    {
      'label': 'CNPJ',
      'search_field': 'client_tax_identifier_tax_id',
      'type': 'cnpj',
      'icon': Icons.numbers_outlined,
    },
    {
      'label': 'Possui chave pix',
      'search_field': 'tem_chave_pix',
      'type': 'bool',
      'icon': Icons.pix_outlined,
    },
    {
      'label': 'Possui taxa cadastrada',
      'search_field': 'tem_taxa',
      'type': 'bool',
      'icon': Icons.percent_outlined,
    },
    {
      'label': 'Status',
      'search_field': 'status',
      'type': 'enum',
      'icon': Icons.check_outlined,
    },
  ];

  final List<Map<String, dynamic>> itemSelect = [
    {
      'value': 'Sim',
      'label': 'Sim',
      'type': 'bool',
    },
    {
      'value': 'Nao',
      'label': 'Não',
      'type': 'bool',
    },
    {
      'value': DomainAccountStatus.UNKNOWN.name,
      'label': DomainAccountStatus.UNKNOWN.name,
      'type': 'enum',
    },
    {
      'value': DomainAccountStatus.CRIADA.name,
      'label': DomainAccountStatus.CRIADA.name,
      'type': 'enum',
    },
    {
      'value': DomainAccountStatus.REGULAR.name,
      'label': DomainAccountStatus.REGULAR.name,
      'type': 'enum',
    },
    {
      'value': DomainAccountStatus.ERRO.name,
      'label': DomainAccountStatus.ERRO.name,
      'type': 'enum',
    },
    {
      'value': DomainAccountStatus.REJEITADA.name,
      'label': DomainAccountStatus.REJEITADA.name,
      'type': 'enum',
    },
    {
      'value': DomainAccountStatus.CRIANDO.name,
      'label': DomainAccountStatus.CRIANDO.name,
      'type': 'enum',
    },
    {
      'value': DomainAccountStatus.LIBERADA.name,
      'label': DomainAccountStatus.LIBERADA.name,
      'type': 'enum',
    },
  ];

  Map<String, String> filters = {
    'order_by': 'client_name',
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
        } else if (element['type'] == 'cnpj') {
          fieldValue = element['value'].replaceAll('.', '').replaceAll('-', '').replaceAll('/', '');
        } else {
          fieldValue = element['value'];
        }
        if (element['type'] == 'bool') {
          filters.addEntries(
            <String, String>{element['search_field']: fieldValue == 'Sim' ? 'true' : 'false'}.entries,
          );
        } else {
          filters.addEntries(
            <String, String>{element['search_field']: fieldValue}.entries,
          );
        }
      }
    }

    filters.addEntries(
      <String, String>{'order_by': 'client_name'}.entries,
    );

    viewModel.loadData(filters);
  }

  onReload() {
    viewModel.loadData(filters);
  }

  @override
  Widget build(BuildContext context) {
    final dialogs = EditDomainAccounts(context: context);
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

    onConfigAccount(entity) async {
      var config = await viewModel.getConfigInfo(entity['id']);
      if (config == null) {
        var result = await ConfigDomainAccounts(context: context).configDialog(viewModel.getEmptyConfigInfo(entity['id']));
        if (result != null && result == true) {
          viewModel.clearSelectionConfig();
          viewModel.clearSelectedItems.invoke();
          onReload();
        }
      } else {
        var result = await ConfigDomainAccounts(context: context).configDialog(config);
        if (result != null && result == true) {
          viewModel.clearSelectionConfig();
          viewModel.clearSelectedItems.invoke();
          onReload();
        }
      }
    }

    return StreamBuilder<List<DomainAccountApiDto>>(
      stream: viewModel.domainAccounts,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          onReload();
          return ProgressLoading(
            color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
          );
        } else {
          List<DomainAccountApiDto> items = (snapshot.data as List<DomainAccountApiDto>);
          return LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              height: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    HeaderSearchMain(onSearch: onSearch, onReload: onReload, searchFields: searchFields, itemsSelect: itemSelect),
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
                                actions: [
                                  PopupMenuItem<dynamic>(
                                    value: {'action': onConfigAccount, 'type': 'EDIT'},
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Configurações",
                                          style: TextStyle(
                                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        Icon(
                                          Icons.settings,
                                          size: 18,
                                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                fieldsData: 'client_name',
                                fieldsSubtitleData: 'tem_taxa',
                                validActionsList: domainAccountsValidActions,
                                items: items.map((e) {
                                  return e.toJson();
                                }).toList(),
                              ),
                            )
                          : DataTablePaginated(
                              viewModel: viewModel,
                              streamList: viewModel.domainAccounts,
                              initialFilters: filters,
                              columnsDef: const [
                                DataColumn(
                                    label: Center(
                                        child: Text(
                                  'Matera',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))),
                                DataColumn(
                                    label: Center(
                                        child: Text(
                                  'Cliente',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))),
                                DataColumn(
                                    label: Center(
                                        child: Text(
                                  'CNPJ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))),
                                DataColumn(
                                    label: Center(
                                        child: Text(
                                  'Possui chave PIX',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))),
                                DataColumn(
                                    label: Center(
                                        child: Text(
                                  'Possui taxa cadastrada',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))),
                                DataColumn(
                                    label: Center(
                                        child: Text(
                                  'Status',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))),
                              ],
                              fieldsData: domainAccountRowsValues,
                              validActionsList: domainAccountsValidActions,
                              dialogs: dialogs,
                              items: items.map((e) {
                                return e.toJson();
                              }).toList(),
                              actions: [
                                StreamBuilder<DomainAccountConfigApiDto?>(
                                    stream: viewModel.configDomainAccount,
                                    builder: (context, snapshot) {
                                      var selecteds = viewModel.selectedItemsList.where((e) => e.selected == true).toList();

                                      if (selecteds.isEmpty || selecteds.length > 1) {
                                        viewModel.clearSelectionConfig();
                                      }

                                      if (snapshot.data == null && selecteds.length == 1) {
                                        viewModel.getConfigInfo(selecteds[0].id);
                                      }

                                      return OnHoverButton(
                                        child: IconButton.outlined(
                                          onPressed: () async {
                                            if (selecteds.length == 1) {
                                              if (snapshot.data == null) {
                                                var result = await ConfigDomainAccounts(context: context)
                                                    .configDialog(viewModel.getEmptyConfigInfo(selecteds[0].id));
                                                if (result != null && result == true) {
                                                  viewModel.clearSelectionConfig();
                                                  viewModel.clearSelectedItems.invoke();
                                                  onReload();
                                                }
                                              } else {
                                                var result = await ConfigDomainAccounts(context: context).configDialog(snapshot.data!);
                                                if (result != null && result == true) {
                                                  viewModel.clearSelectionConfig();
                                                  viewModel.clearSelectedItems.invoke();
                                                  onReload();
                                                }
                                              }
                                            }
                                          },
                                          tooltip: 'Configurações',
                                          icon: const Icon(
                                            Icons.settings,
                                          ),
                                        ),
                                      );
                                    }),
                                const SizedBox(
                                  width: 10,
                                ),
                                OnHoverButton(
                                  child: IconButton.outlined(
                                    onPressed: () {
                                      var selecteds = viewModel.selectedItemsList.where((e) => e.selected == true).toList();

                                      if (selecteds.isEmpty || selecteds.length > 1) return;

                                      if (selecteds.length == 1) {
                                        final dataController = Get.put(DataController());
                                        dataController.getData(selecteds[0].id);
                                        Clipboard.setData(ClipboardData(text: dataController.data.value));
                                        showInfoMessage(
                                          context,
                                          2,
                                          Colors.green,
                                          'Domain_id copiado com sucesso!',
                                          'X',
                                          () {},
                                          Colors.white,
                                        );
                                      }
                                    },
                                    tooltip: 'Copiar domain_id',
                                    icon: const Icon(
                                      Icons.copy,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
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

class DataController extends GetxController {
  DataController();

  var data = ''.obs;

  void getData(newData) {
    data.value = newData;
  }
}
