import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/ui/list_domain_accounts/list_domain_accounts_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class ListDomainAccountsGrid extends StatefulWidget {
  const ListDomainAccountsGrid({super.key});

  @override
  State<ListDomainAccountsGrid> createState() => _ListDomainAccountsGridState();
}

class _ListDomainAccountsGridState extends State<ListDomainAccountsGrid> {
  //TODO: COLOCAR DINAMICA DE LIST NO VIEW MODEL DA DOMAIN ACCOUNTS
  late ListDomainAccountViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<ListDomainAccountViewModel>(context);
    viewModel.loadData();

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
          viewModel.loadData();
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
        } else if (snapshot.data != null &&
            (snapshot.data as List<DomainAccountApiDto>).isNotEmpty) {
          List<DomainAccountApiDto> items = (snapshot.data as List<DomainAccountApiDto>);
          return SizedBox(
            height: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const HeaderSearchMain(
                    searchFields: [
                      {
                        'label': 'Nome',
                        'search_field': 'name',
                        'icon': Icons.abc,
                      },
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DataTablePaginated(
                      viewModel: viewModel,
                      columnsDef: const [
                        DataColumn(label: Center(child: Text('Id', style: TextStyle(fontWeight: FontWeight.bold),))),
                        DataColumn(label: Center(child: Text('Cliente', style: TextStyle(fontWeight: FontWeight.bold),))),
                        DataColumn(label: Center(child: Text('Matera', style: TextStyle(fontWeight: FontWeight.bold),))),
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
                  ),
                  // DataTableNotPaginated(
                  //   viewModel: viewModel,
                  //   items: items,
                  // ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox(
            height: double.infinity,
            child: Column(
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
      },
    );
  }
}
