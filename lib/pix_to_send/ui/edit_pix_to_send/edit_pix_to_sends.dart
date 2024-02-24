import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/edit_pix_to_send/edit_pix_to_sends_form/edit_pix_to_sends_form.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/edit_pix_to_send/edit_pix_to_sends_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class EditPixToSends {
  EditPixToSends({required this.context});

  final BuildContext context;
  final viewModel = locator.get<EditPixToSendViewModel>();

  clearFields() {
    viewModel.form.onAliasChange('');
    viewModel.form.onPspIdChange('');
    viewModel.form.onTaxIdendifierTaxIdChange('');
    viewModel.form.onTaxIdentifierCountryChange('');
    viewModel.form.onEndToEndIdQueryChange('');
    viewModel.form.onAccountDestinationBranchChange('');
    viewModel.form.onAccountDestinationAccountChange('');
    viewModel.form.onAccountDestinationAccountTypeChange('');
  }

  Future<void> addDialog() {
    clearFields();
    onSubmit() {
      viewModel.submit(null, showInfoMessage, context);
      // Navigator.of(context).pop();
    }

    viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Chave pix criada com sucesso!',
        'X',
        () {},
        Colors.white,
      );
      Navigator.pop(context, true);
    });

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
                    'Adicionando nova chave PIX',
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
                    TextButton.icon(
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
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.save_alt_outlined,
                          size: 20,
                        ),
                        label: const Text('Salvar'),
                        onPressed: () => onSubmit(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> editDialog(PixToSendApiDto entity) {
    clearFields();

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
                    TextButton.icon(
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
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.save_alt_outlined,
                          size: 20,
                        ),
                        label: const Text('Salvar'),
                        onPressed: () => onSubmit(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
