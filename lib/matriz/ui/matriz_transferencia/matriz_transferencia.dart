import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_card/matriz_transferencia_card.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_timeline/matriz_transferencia_timeline.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/transacoes_api_dto.dart';
import 'package:viggo_pay_admin/utils/container.dart';

// ignore: must_be_immutable
class MatrizTransferenciaPage extends StatelessWidget {
  MatrizTransferenciaPage({super.key});

  final MatrizTransferenciaViewModel viewModel =
      locator.get<MatrizTransferenciaViewModel>();

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      child: StreamBuilder<DomainAccountApiDto?>(
          stream: viewModel.matriz,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              viewModel.catchEntity();
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: SizedBox(
                  height: ContainerClass().maxHeightContainer(context, false, heightPlus: 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TransferenciaCard(
                        matrizAccount: snapshot.data!,
                      ),
                      StreamBuilder<List<TransacaoApiDto>>(
                        stream: viewModel.transacoes,
                        builder: (context, snapshotTimeline) {
                          if (snapshotTimeline.data == null) {
                            viewModel.loadTransacoes(snapshot.data!.materaId!);
                            return const CircularProgressIndicator();
                          } else {
                            return Expanded(
                              child: TimelineMatriz(
                                listTransferencia: snapshotTimeline.data!,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
