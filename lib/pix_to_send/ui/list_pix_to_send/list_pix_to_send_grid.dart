import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/list_pix_to_send/list_pix_to_send_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class ListPixToSendGrid extends StatefulWidget {
  const ListPixToSendGrid({super.key});

  @override
  State<ListPixToSendGrid> createState() => _ListPixToSendGridState();
}

class _ListPixToSendGridState extends State<ListPixToSendGrid> {
  late ListPixToSendViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<ListPixToSendViewModel>(context);
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
      stream: viewModel.pixToSends,
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
            (snapshot.data as List<PixToSendApiDto>).isNotEmpty) {
          List<PixToSendApiDto> items =
              (snapshot.data as List<PixToSendApiDto>);
          return SizedBox(
            height: double.maxFinite,
            child: DataTablePaginated(
              viewModel: viewModel,
              columnsDef: const [
                DataColumn(label: Text('Psp ID')),
                DataColumn(label: Text('Alias'))
              ],
              fieldsData: const ['psp_id', 'alias'],
              items: items.map((e) {
                return e.toJson();
              }).toList(),
            ),
            // DataTableNotPaginated(
            //   viewModel: viewModel,
            //   items: items,
            // ),
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
