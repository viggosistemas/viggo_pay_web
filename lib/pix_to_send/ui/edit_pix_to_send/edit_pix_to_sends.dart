import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/destinatario_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/edit_pix_to_send/edit_pix_to_sends_form/edit_pix_to_sends_form.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/edit_pix_to_send/edit_pix_to_sends_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class EditPixToSends {
  EditPixToSends({required this.context});

  final BuildContext context;
  final viewModel = locator.get<EditPixToSendViewModel>();

  clearFields(String? alias) {
    if (alias == null) {
      viewModel.form.alias.onValueChange('');
    } else {
      viewModel.form.alias.onValueChange(alias);
    }
    viewModel.form.aliasType.onValueChange('');
    viewModel.onDestinatarioChange(null);
  }

  preencherDestinatario(PixToSendApiDto entity) {
    Map<String, dynamic> destinatario = {
      'alias': entity.alias,
      'aliasType': entity.aliasType,
      'aliasAccountHolder': {
        'name': entity.holderName,
        'taxIdentifier': {
          'taxId': entity.holderTaxIdentifierTaxId,
          'country': entity.holderTaxIdentifierCountry,
          'taxIdMasked': entity.holderTaxIdentifierTaxIdMasked,
        }
      },
      'accountDestination': {
        'branch': entity.destinationBranch,
        'account': entity.destinationAccount,
        'accountType': entity.destinationAccountType,
      },
      'psp': {
        'name': entity.pspName,
        'id': entity.pspId,
        'country': entity.pspCountry,
      }
    };
    viewModel.onDestinatarioChange(DestinatarioApiDto.fromJson(destinatario));
  }

  Future addDialog(String? alias) {
    viewModel.catchDomainAccount();
    clearFields(alias);
    onSubmit() {
      viewModel.submit(null, showInfoMessage, context);
      // Navigator.of(context).pop();
    }

    viewModel.pixToSendSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Chave pix criada com sucesso!',
        'X',
        () {},
        Colors.white,
      );
      Navigator.pop(context, value);
    });

    // viewModel.isSuccess.listen((value) {
    //   showInfoMessage(
    //     context,
    //     2,
    //     Colors.green,
    //     'Chave pix criada com sucesso!',
    //     'X',
    //     () {},
    //     Colors.white,
    //   );
    //   Navigator.pop(context, true);
    // });

    viewModel.errorMessage.listen(
      (value) {
        if (value.isNotEmpty && context.mounted) {
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
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) return;
              // Navigator.pop(context, true);
            },
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Row(
                children: [
                  Text(
                    'Adicionando chave PIX',
                    style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(Icons.key_outlined),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: EditPixToSendsForm(
                    viewModel: viewModel,
                  ),
                ),
              ),
              actions: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OnHoverButton(
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 20,
                        ),
                        label: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                    StreamBuilder<DestinatarioApiDto?>(
                        stream: viewModel.destinatarioInfo,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return StreamBuilder<bool>(
                                stream: viewModel.form.isValid,
                                builder: (context, snapshot) {
                                  return OnHoverButton(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: TextButton.icon(
                                        icon: const Icon(
                                          Icons.search_outlined,
                                          size: 20,
                                        ),
                                        label: const Text('Consultar'),
                                        onPressed: () => snapshot.data != null &&
                                                snapshot.data == true
                                            ? viewModel.loadInfoDestinatario(
                                                'BR',
                                                viewModel.form
                                                    .getValues()!['alias']!,
                                              )
                                            : {},
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              snapshot.data != null &&
                                                      snapshot.data == true
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return OnHoverButton(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextButton.icon(
                                  icon: const Icon(
                                    Icons.save_alt_outlined,
                                    size: 20,
                                  ),
                                  label: const Text('Salvar'),
                                  onPressed: () =>
                                      snapshot.data != null ? onSubmit() : {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: snapshot.data != null
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> editDialog(PixToSendApiDto entity) {
    var jaPreencheu = false;
    viewModel.catchDomainAccount();
    clearFields(null);

    onSubmit() {
      viewModel.submit(entity.id, showInfoMessage, context);
      // Navigator.of(context).pop();
    }

    viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Chave pix editada com sucesso!',
        'X',
        () {},
        Colors.white,
      );
      Navigator.pop(context, true);
    });

    viewModel.errorMessage.listen(
      (value) {
        if (value.isNotEmpty && context.mounted) {
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

    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) return;
              Navigator.pop(context, true);
            },
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Row(
                children: [
                  Text(
                    'Editando chave PIX',
                    style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(Icons.key_outlined),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: EditPixToSendsForm(
                    entity: entity,
                    viewModel: viewModel,
                  ),
                ),
              ),
              actions: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OnHoverButton(
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 20,
                        ),
                        label: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                    StreamBuilder<DestinatarioApiDto?>(
                        stream: viewModel.destinatarioInfo,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            if (!jaPreencheu) {
                              jaPreencheu = true;
                              preencherDestinatario(entity);
                            }
                            return StreamBuilder<bool>(
                                stream: viewModel.form.isValid,
                                builder: (context, snapshot) {
                                  return OnHoverButton(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: TextButton.icon(
                                        icon: const Icon(
                                          Icons.search_outlined,
                                          size: 20,
                                        ),
                                        label: const Text('Consultar'),
                                        onPressed: () => snapshot.data != null &&
                                                snapshot.data == true
                                            ? viewModel.loadInfoDestinatario(
                                                'BR',
                                                viewModel.form
                                                    .getValues()!['alias']!,
                                              )
                                            : {},
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              snapshot.data != null &&
                                                      snapshot.data == true
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return OnHoverButton(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextButton.icon(
                                  icon: const Icon(
                                    Icons.save_alt_outlined,
                                    size: 20,
                                  ),
                                  label: const Text('Salvar'),
                                  onPressed: () =>
                                      snapshot.data != null ? onSubmit() : {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: snapshot.data != null
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> infoDataDialog(PixToSendApiDto entity) {
    viewModel.catchDomainAccount();

    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) return;
              Navigator.pop(context, true);
            },
            child: SimpleDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'Detalhes da chave PIX',
                        style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(Icons.key_outlined),
                    ],
                  ),
                  OnHoverButton(
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_outlined,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: 500,
                    child: SingleChildScrollView(
                      child: EditPixToSendsForm(
                        entity: entity,
                        viewModel: viewModel,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
