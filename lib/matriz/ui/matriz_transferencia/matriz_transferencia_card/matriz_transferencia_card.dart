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

class TransferenciaCard extends StatefulWidget {
  const TransferenciaCard({
    super.key,
    required this.matrizAccount,
  });

  final DomainAccountApiDto matrizAccount;

  @override
  State<TransferenciaCard> createState() => _TransferenciaCardState();
}

class _TransferenciaCardState extends State<TransferenciaCard> {
  bool isObscureSaldo = true;

  @override
  Widget build(BuildContext context) {
    MatrizTransferenciaViewModel viewModel =
        locator.get<MatrizTransferenciaViewModel>();
    final dialogs = MatrizTransferenciaDialog(context: context);

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
                    'Transferência entre contas',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.move_up_outlined),
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
                                widget.matrizAccount.clientName,
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
                                'CNPJ: ${widget.matrizAccount.clientTaxIdentifierTaxId}',
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
                              viewModel
                                  .loadChavePix(widget.matrizAccount.materaId!);
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
                                      if (widget.matrizAccount.password ==
                                          null) {
                                        viewModel.formSenha.senhaAntiga
                                            .onValueChange('senha1');
                                      } else {
                                        viewModel.formSenha.senhaAntiga
                                            .onValueChange('');
                                      }
                                      viewModel.formSenha.novaSenha
                                          .onValueChange('');
                                      viewModel.formSenha.confirmarSenha
                                          .onValueChange('');
                                      DialogAlterarSenha(context: context)
                                          .showFormDialog(
                                              widget.matrizAccount.password !=
                                                  null);
                                    },
                                    icon: const Icon(Icons.lock_outline),
                                    tooltip:
                                        widget.matrizAccount.password != null
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
                              viewModel.loadUltimatransacao(
                                  widget.matrizAccount.materaId!);
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
                          viewModel.loadSaldo(widget.matrizAccount.materaId!);
                          return const CircularProgressIndicator();
                        } else {
                          return Column(
                            children: [
                              Container(
                                width: 180.0,
                                height: 180.0,
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
                                      isObscureSaldo
                                          ? 'R\$ ${saldoData.data!.real.toString().replaceAll(RegExp(r"."), "*")}'
                                          : 'R\$ ${saldoData.data!.real.toString()}',
                                      style: GoogleFonts.lato(
                                        fontSize: 24,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          'Saldo disponível',
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            isObscureSaldo
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isObscureSaldo = !isObscureSaldo;
                                            });
                                          },
                                        ),
                                      ],
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
                                        widget.matrizAccount.id,
                                      );
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
                                          onPressed: () async {
                                            if (saldoData.data!.real > 0) {
                                              var result = await dialogs
                                                  .transferenciaDialog(
                                                saldo: saldoData.data!,
                                                pixToSendList:
                                                    pixToSendData.data!,
                                              );
                                              if (result != null &&
                                                  result == true &&
                                                  context.mounted) {
                                                showInfoMessage(
                                                  context,
                                                  2,
                                                  Colors.green,
                                                  'Transferência realizada com sucesso!',
                                                  'X',
                                                  () {},
                                                  Colors.white,
                                                );
                                              }
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
