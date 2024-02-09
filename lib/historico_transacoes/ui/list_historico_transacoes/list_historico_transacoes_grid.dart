import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';
import 'package:viggo_pay_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_core_frontend/domain/ui/list_domain_view_model.dart';

class ListHistoricoTransacoesGrid extends StatefulWidget {
  const ListHistoricoTransacoesGrid({super.key});

  @override
  State<ListHistoricoTransacoesGrid> createState() => _ListHistoricoTransacoesGridState();
}

class _ListHistoricoTransacoesGridState extends State<ListHistoricoTransacoesGrid> {
  late ListDomainViewModel viewModel; //TODO: COLOCAR DINAMICA DE LIST NO VIEW MODEL DA HISTORICO TRANSACOES

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<ListDomainViewModel>(context);
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
      stream: viewModel.domains,
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
            (snapshot.data as List<DomainApiDto>).isNotEmpty) {
          List<DomainApiDto> items = (snapshot.data as List<DomainApiDto>);
          return SizedBox(
            height: double.maxFinite,
            child: DataTablePaginated(
              viewModel: viewModel,
              columnsDef: const [
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('ApplicationId')),
              ],
              fieldsData: const [
                'id',
                'name',
                'application_id',
              ],
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
          return const Center(
            child: Text('Nenhum resultado encontrado!'),
          );
        }
      },
    );
  }
}
