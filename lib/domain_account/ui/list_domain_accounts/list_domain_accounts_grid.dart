import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
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
  ListDomainAccountViewModel viewModel =
      locator.get<ListDomainAccountViewModel>();

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
    'uso_liberado'
  ];

  List<Map<String, dynamic>> searchFields = [
    {
      'label': 'Cliente',
      'search_field': 'client_name',
      'type': 'text',
      'icon': Icons.person_outline,
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
    return StreamBuilder<Object>(
      stream: viewModel.domainAccounts,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          onReload();
          return ProgressLoading(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          );
        } else {
          List<DomainAccountApiDto> items =
              (snapshot.data as List<DomainAccountApiDto>);
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
                          'Uso liberado',
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
                              var selecteds = viewModel.selectedItemsList
                                  .where((e) => e.selected == true)
                                  .toList();

                              if (selecteds.isEmpty || selecteds.length > 1) {
                                viewModel.clearSelectionConfig();
                              }

                              if (snapshot.data == null &&
                                  selecteds.length == 1) {
                                viewModel.getConfigInfo(selecteds[0].id);
                              }

                              return OnHoverButton(
                                child: IconButton.outlined(
                                  onPressed: () async {
                                    if (selecteds.length == 1) {
                                      if (snapshot.data == null) {
                                        var result = await ConfigDomainAccounts(
                                                context: context)
                                            .configDialog(
                                                viewModel.getEmptyConfigInfo(
                                                    selecteds[0].id));
                                        if (result != null && result == true) {
                                          viewModel.clearSelectionConfig();
                                          viewModel.clearSelectedItems.invoke();
                                        }
                                      } else {
                                        var result = await ConfigDomainAccounts(
                                                context: context)
                                            .configDialog(snapshot.data!);
                                        if (result != null && result == true) {
                                          viewModel.clearSelectionConfig();
                                          viewModel.clearSelectedItems.invoke();
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
        }
      },
    );
  }
}
