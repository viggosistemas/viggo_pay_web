import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_alterar_senha_pix/dialog_alterar_senha_pix.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_dialog/matriz_transferencia_dialog.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/chave_pix_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/transacoes_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class TransferenciaCard extends StatelessWidget {
  const TransferenciaCard({
    super.key,
    required this.matrizAccount,
  });

  final DomainAccountApiDto matrizAccount;

  @override
  Widget build(BuildContext context) {
    MatrizTransferenciaViewModel viewModel =
        locator.get<MatrizTransferenciaViewModel>();
    final dialogs = MatrizTransferenciaDialog(context: context);

    viewModel.isError.listen(
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

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: MediaQuery.of(context).size.width * 0.5,
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Transferências entre contas',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.transfer_within_a_station_outlined),
                ],
              ),
              Divider(
                height: 10,
                thickness: 0,
                indent: 0,
                endIndent: 0,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.domain_outlined),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                matrizAccount.clientName,
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.numbers),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'CNPJ: ${matrizAccount.clientTaxIdentifierTaxId}',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      StreamBuilder<ChavePixApiDto>(
                          stream: viewModel.chavePix,
                          builder: (context, chavePixData) {
                            if (chavePixData.data == null) {
                              viewModel.loadChavePix(matrizAccount.materaId!);
                              return const Text('');
                            } else {
                              return Row(
                                children: [
                                  const Icon(
                                    Icons.key,
                                    color: Colors.yellow,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Chave PIX: ${chavePixData.data!.name}',
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (matrizAccount.password == null) {
                                        viewModel.formSenha
                                            .onSenhaAntigaChange('senha1');
                                      } else {
                                        viewModel.formSenha
                                            .onSenhaAntigaChange('');
                                      }
                                      viewModel.formSenha.onNovaSenhaChange('');
                                      viewModel.formSenha.onConfirmarSenha('');
                                      DialogAlterarSenha(context: context)
                                          .showFormDialog(
                                              matrizAccount.password != null);
                                    },
                                    icon: const Icon(Icons.lock_outline),
                                    tooltip: matrizAccount.password != null
                                        ? 'Alterar senha'
                                        : 'Criar senha',
                                  ),
                                ],
                              );
                            }
                          }),
                      StreamBuilder<TransacaoApiDto>(
                          stream: viewModel.ultimaTransacao,
                          builder: (context, ultimaTransacaoData) {
                            if (ultimaTransacaoData.data == null) {
                              viewModel
                                  .loadUltimatransacao(matrizAccount.materaId!);
                              return const Text('');
                            } else {
                              return Row(
                                children: [
                                  const Icon(
                                    Icons.attach_money_outlined,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Última transação: R\$ ${ultimaTransacaoData.data!.totalAmount ?? 0.0}",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
                    ],
                  ),
                  StreamBuilder<SaldoApiDto>(
                      stream: viewModel.saldo,
                      builder: (context, saldoData) {
                        if (saldoData.data == null) {
                          viewModel.loadSaldo(matrizAccount.materaId!);
                          return const CircularProgressIndicator();
                        } else {
                          return Column(
                            children: [
                              Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'R\$ ${saldoData.data!.real.toString()}',
                                      style: GoogleFonts.lato(
                                        fontSize: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    Text(
                                      'Saldo disponível',
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              StreamBuilder<List<PixToSendApiDto>>(
                                  stream: viewModel.chavePixToSends,
                                  builder: (context, pixToSendData) {
                                    if (pixToSendData.data == null) {
                                      viewModel.loadChavePixToSends(
                                          matrizAccount.id);
                                      return const CircularProgressIndicator();
                                    }
                                    return Tooltip(
                                      message: saldoData.data!.real == 0
                                          ? 'Não há saldo disponível!'
                                          : '',
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  saldoData.data!.real > 0
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : Colors.grey),
                                          icon: const Icon(
                                            Icons.attach_money_outlined,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            if (saldoData.data!.real > 0) {
                                              dialogs.transferenciaDialog(
                                                saldo: saldoData.data!,
                                                pixToSendList:
                                                    pixToSendData.data!,
                                              );
                                            }
                                          },
                                          label: const Text('Transferir'),
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          );
                        }
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
