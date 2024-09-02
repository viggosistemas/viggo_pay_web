import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viggo_pay_admin/components/dialogs.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_alterar_senha_pix/dialog_alterar_senha_pix.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_view_model.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/chave_pix_api_dto.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class EditChavePix extends StatefulWidget {
  const EditChavePix({
    super.key,
    required this.materaId,
    required this.viewModel,
  });

  final MatrizViewModel viewModel;
  final String materaId;

  @override
  State<EditChavePix> createState() => _EditChavePixState();
}

class _EditChavePixState extends State<EditChavePix> {
  bool isPercentualTaxa = false;

  @override
  Widget build(BuildContext context) {
    widget.viewModel.isSuccessPix.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Chave pix antiga removida e nova chave alterada com sucesso!',
        'X',
        () {},
        Colors.white,
      );
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  StreamBuilder<List<ChavePixApiDto>>(
                      stream: widget.viewModel.chavePix,
                      builder: (context, chavePixData) {
                        if (chavePixData.data == null) {
                          // widget.viewModel.onCreateChavePix(context, widget.materaId);
                          widget.viewModel.loadChavePix(widget.materaId);
                          return const Text('');
                        } else if (chavePixData.data!.isEmpty) {
                          return Row(
                            children: [
                              const Icon(
                                Icons.key,
                                color: Colors.yellow,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Tooltip(
                                message: constraints.maxWidth < 960 ? 'Chave PIX: ${chavePixData.data![0].name}' : '',
                                child: Text(
                                  'Sem chave PIX cadastrada!',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              widget.viewModel.validarPelasRotas('POST', '/pay_facs/add_chave_pix')
                                  ? OnHoverButton(
                                      child: IconButton(
                                        onPressed: () async {
                                          var result = await Dialogs(context: context).showConfirmDialog(
                                            {
                                              'title_text': 'Adicionar chave pix',
                                              'title_icon': Icons.pix,
                                              'message':
                                                  'Ao confirmar a adição de uma chave PIX será necessário aguardar uns instantes para a validação da nova chave registrada para sua conta. Deseja prosseguir?'
                                            },
                                            width: 500,
                                          );
                                          if (result && context.mounted) {
                                            var result2 = await widget.viewModel.onCreateChavePix(
                                              context,
                                              widget.materaId,
                                            );
                                            if (result2) {
                                              widget.viewModel.loadChavePix(widget.materaId);
                                            }
                                          }
                                        },
                                        icon: Icon(
                                          Icons.add_box_outlined,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        tooltip: 'Adicionar nova chave PIX',
                                      ),
                                    )
                                  : const Text(''),
                            ],
                          );
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
                              Tooltip(
                                message: constraints.maxWidth < 960 ? 'Chave PIX: ${chavePixData.data![0].name}' : '',
                                child: Text(
                                  constraints.maxWidth < 960
                                      ? 'Chave PIX: ${chavePixData.data![0].name.substring(0, 20)}...'
                                      : 'Chave PIX: ${chavePixData.data![0].name}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              widget.viewModel.validarPelasRotas('PUT', '/domain_accounts/<id>/update_password')
                                  ? OnHoverButton(
                                      child: chavePixData.data![0].status != 'ACTIVE'
                                          ? IconButton(
                                              onPressed: () => {},
                                              icon: const Icon(
                                                Icons.warning_amber_outlined,
                                                color: Colors.orangeAccent,
                                              ),
                                              tooltip: 'Chave inutilizada!',
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                if (widget.viewModel.matrizAccount.password == null) {
                                                  widget.viewModel.formSenha.senhaAntiga.onValueChange('senha1');
                                                } else {
                                                  widget.viewModel.formSenha.senhaAntiga.onValueChange('');
                                                }
                                                widget.viewModel.formSenha.novaSenha.onValueChange('');
                                                widget.viewModel.formSenha.confirmarSenha.onValueChange('');
                                                DialogAlterarSenha(
                                                  context: context,
                                                  domainAccountId: widget.viewModel.matrizAccount.id,
                                                ).showFormDialog(
                                                  widget.viewModel.matrizAccount.password != null,
                                                );
                                              },
                                              icon: const Icon(Icons.lock_outline),
                                              tooltip: widget.viewModel.matrizAccount.password != null ? 'Alterar senha' : 'Criar senha',
                                            ),
                                    )
                                  : const Text(''),
                              widget.viewModel.validarPelasRotas('POST', '/pay_facs/deletar_chave_pix') &&
                                      widget.viewModel.validarPelasRotas('POST', '/pay_facs/add_chave_pix') &&
                                      chavePixData.data![0].status == 'ACTIVE'
                                  ? OnHoverButton(
                                      child: IconButton(
                                        onPressed: () async {
                                          var result = await Dialogs(context: context).showConfirmDialog(
                                            {
                                              'title_text': 'Remover chave pix',
                                              'title_icon': Icons.pix,
                                              'message':
                                                  'Ao confirmar a remoção da chave pix do Matera uma nova será gerada para fins de manter o funcionamento de transferências do sistema. Deseja confirmar essa ação?'
                                            },
                                            width: 500,
                                          );
                                          if (result && context.mounted) {
                                            var result2 = await widget.viewModel.onRemoveChavePix(
                                              context,
                                              chavePixData.data![0].name,
                                              widget.materaId,
                                            );
                                            if (result2) {
                                              widget.viewModel.loadChavePix(widget.materaId);
                                            }
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                        tooltip: 'Remover chave',
                                      ),
                                    )
                                  : const Text(''),
                            ],
                          );
                        }
                      }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
