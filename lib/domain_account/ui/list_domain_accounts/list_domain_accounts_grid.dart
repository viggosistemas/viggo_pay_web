import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
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

  buildContent(List<DomainAccountApiDto> items) {
    if (items.isNotEmpty) {
      return SizedBox(
        width: double.infinity,
        child: DataTablePaginated(
          viewModel: viewModel,
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
          items: items.map((e) {
            return e.toJson();
          }).toList(),
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
    viewModel.loadData(filters);

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
          viewModel.loadData(filters);
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
