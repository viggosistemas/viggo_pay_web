import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/list_pix_to_send/list_pix_to_send_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class ListPixToSendGrid extends StatefulWidget {
  const ListPixToSendGrid({super.key});

  @override
  State<ListPixToSendGrid> createState() => _ListPixToSendGridState();
}

class _ListPixToSendGridState extends State<ListPixToSendGrid> {
  late ListPixToSendViewModel viewModel;

  List<Map<String, dynamic>> searchFields = [
    {
      'label': 'Alias',
      'search_field': 'alias',
      'type': 'text',
      'icon': Icons.key_outlined,
    },
  ];

  Map<String, String> filters = {
    'order_by': 'alias',
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
      <String, String>{'order_by': 'alias'}.entries,
    );

    viewModel.loadData(newFilters);
  }

  onReload(){
    viewModel.loadData(filters);
  }

  buildContent(List<PixToSendApiDto> items) {
    // final dialogs = EditDomainAccounts(context: context);
    if (items.isNotEmpty) {
      return SizedBox(
        width: double.infinity,
        child: DataTablePaginated(
          viewModel: viewModel,
          streamList: viewModel.pixToSends,
          initialFilters: filters,
          columnsDef: const [
            DataColumn(
                label: Center(
                    child: Text(
              'Psp ID',
              style: TextStyle(fontWeight: FontWeight.bold),
            ))),
            DataColumn(
                label: Center(
                    child: Text(
              'Alias',
              style: TextStyle(fontWeight: FontWeight.bold),
            ))),
          ],
          fieldsData: const ['psp_id', 'alias'],
          dialogs: null,
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
    viewModel = Provider.of<ListPixToSendViewModel>(context);
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
