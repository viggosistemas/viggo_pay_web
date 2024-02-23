import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/config_domain_accounts/config_domain_accounts.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts.dart';
import 'package:viggo_pay_admin/domain_account/ui/list_domain_accounts/list_domain_accounts_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class ListDomainAccountsGrid extends StatefulWidget {
  const ListDomainAccountsGrid({super.key});

  @override
  State<ListDomainAccountsGrid> createState() => _ListDomainAccountsGridState();
}

class _ListDomainAccountsGridState extends State<ListDomainAccountsGrid> {
  late ListDomainAccountViewModel viewModel;

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
    Map<String, String> newFilters = {};
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
      newFilters.addEntries(
        <String, String>{element['search_field']: fieldValue}.entries,
      );
    }

    newFilters.addEntries(
      <String, String>{'order_by': 'client_name'}.entries,
    );

    viewModel.loadData(newFilters);
  }

  onReload(){
    viewModel.loadData(filters);
  }

  buildContent(List<DomainAccountApiDto> items) {
    final dialogs = EditDomainAccounts(context: context);
    if (items.isNotEmpty) {
      return SizedBox(
        width: double.infinity,
        child: DataTablePaginated(
          viewModel: viewModel,
          streamList: viewModel.domainAccounts,
          initialFilters: filters,
          columnsDef: const [
            DataColumn(
                label: Center(
                    child: Text(
              'Id',
              style: TextStyle(fontWeight: FontWeight.bold),
            ))),
            DataColumn(
                label: Center(
                    child: Text(
              'Cliente',
              style: TextStyle(fontWeight: FontWeight.bold),
            ))),
            DataColumn(
                label: Center(
                    child: Text(
              'Matera',
              style: TextStyle(fontWeight: FontWeight.bold),
            ))),
          ],
          fieldsData: const [
            'id',
            'client_name',
            'matera_id',
          ],
          dialogs: dialogs,
          items: items.map((e) {
            return e.toJson();
          }).toList(),
          actions: [
            const SizedBox(
              width: 10,
            ),
            StreamBuilder<DomainAccountConfigApiDto?>(
                stream: viewModel.configDomainAccount,
                builder: (context, snapshot) {
                  var selecteds = viewModel.selectedItemsList
                      .where((e) => e.selected == true)
                      .toList();

                  if (selecteds.isEmpty || selecteds.length > 1) {
                    viewModel.clearSelectionConfig();
                  }

                  if (snapshot.data == null && selecteds.length == 1) {
                    viewModel.getConfigInfo(selecteds[0].id);
                  }

                  return IconButton.outlined(
                    onPressed: () {
                      if (selecteds.length == 1) {
                        if (snapshot.data == null) {
                          ConfigDomainAccounts(context: context).configDialog(
                              viewModel.getEmptyConfigInfo(selecteds[0].id));
                        } else {
                          ConfigDomainAccounts(context: context)
                              .configDialog(snapshot.data!);
                        }
                      }
                    },
                    tooltip: 'Configurações',
                    icon: const Icon(
                      Icons.settings,
                    ),
                  );
                })
          ],
        ),
      );
      // DataTableNotPaginated(
      //   viewModel: viewModel,
      //   items: items,
      // ),
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.black,
            ),
            SizedBox(
              height: 10,
            ),
            Text('Nenhum resultado encontrado!')
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<ListDomainAccountViewModel>(context);
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
      stream: viewModel.domainAccounts,
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
                  buildContent(items),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
