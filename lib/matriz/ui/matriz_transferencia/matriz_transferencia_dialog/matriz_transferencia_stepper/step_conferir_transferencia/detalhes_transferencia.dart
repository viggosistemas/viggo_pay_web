import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_dialog/matriz_transferencia_stepper/step_conferir_transferencia/dialog_novo_valor.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/destinatario_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';

class StepTransferenciaDetalhe extends StatelessWidget {
  StepTransferenciaDetalhe({
    super.key,
    required this.changePage,
    required this.currentPage,
    required this.saldo,
  });

  final Function(int index) changePage;
  final int currentPage;
  final SaldoApiDto saldo;
  final viewModel = locator.get<MatrizTransferenciaViewModel>();

  getValorTaxa(String valor) {
    if (viewModel.taxaMediatorFee['porcentagem']) {
      return double.parse(valor) * viewModel.taxaMediatorFee['taxa'];
    } else {
      return viewModel.taxaMediatorFee['taxa'];
    }
  }

  getValorTotal(String valor) {
    var taxa = getValorTaxa(valor);
    return double.parse(valor) + taxa;
  }

  @override
  Widget build(BuildContext context) {
    var valorTransferido =
        viewModel.formStepValor.getValues()!['valor'].toString();
    final pixSelected = PixToSendApiDto.fromJson(jsonDecode(
        viewModel.formStepSelectPix.getValues()!['pixSelect'].toString()));

    return StreamBuilder<DestinatarioApiDto>(
        stream: viewModel.destinatarioInfo,
        builder: (context, destinatarioData) {
          if (destinatarioData.data == null) {
            viewModel.loadInfoDestinatario(
              pixSelected.holderTaxIdentifierCountry,
              pixSelected.alias,
            );
            return const ProgressLoading();
          } else {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Transferindo',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        StreamBuilder<String>(
                            stream: viewModel.formStepValor.valor.field,
                            builder: (context, snapshot) {
                              return Text(
                                'R\$ ${snapshot.data ?? valorTransferido}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              );
                            }),
                        OnHoverButton(
                          child: IconButton(
                            onPressed: () async {
                              var result = await DialogNovoValor(
                                context: context,
                                saldo: saldo,
                              ).openDialog();
                              if (result != true) {
                                viewModel.formStepValor.valor
                                    .onValueChange(valorTransferido);
                              }
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                    StreamBuilder<String>(
                        stream: viewModel.formStepValor.valor.field,
                        builder: (context, snapshot) {
                          return Text(
                            'Valor a ser debitado pelos encargos será R\$ ${getValorTaxa(snapshot.data ?? valorTransferido)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          );
                        }),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Chave PIX',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          pixSelected.alias,
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Enviando para',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          destinatarioData.data!.aliasHolderName,
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'CPF/CNPJ',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          destinatarioData.data!.aliasHolderTaxIdMasked,
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Intituição',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          destinatarioData.data!.pspName,
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Agência',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          destinatarioData.data!.accountBranchDestination,
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Conta',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          destinatarioData.data!.accountDestination,
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Tipo da conta',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          destinatarioData.data!.accountTypeDestination,
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                      ],
                    ),
                    StreamBuilder<String>(
                        stream: viewModel.formStepValor.valor.field,
                        builder: (context, snapshot) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Valor total debitado',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'R\$ ${getValorTotal(snapshot.data ?? valorTransferido)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          );
                        }),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OnHoverButton(
                      child: ElevatedButton.icon(
                        onPressed: () => changePage(currentPage - 1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        icon: const Icon(
                          Icons.arrow_back_outlined,
                          size: 18,
                        ),
                        label: const Text('Voltar'),
                      ),
                    ),
                    OnHoverButton(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          onPressed: () => changePage(currentPage + 1),
                          icon: const Icon(
                            Icons.arrow_back_outlined,
                            size: 18,
                          ),
                          label: const Text('Próximo'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        });
  }
}
