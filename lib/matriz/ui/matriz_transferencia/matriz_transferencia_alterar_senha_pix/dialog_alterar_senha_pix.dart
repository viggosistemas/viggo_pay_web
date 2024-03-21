import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_alterar_senha_pix/form_fields.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class DialogAlterarSenha {
  DialogAlterarSenha({required this.context});

  final BuildContext context;
  final viewModel = locator.get<MatrizTransferenciaViewModel>();

  Future<void> showFormDialog(bool jaTemSenha) {
    onSubmit() {
      viewModel.onSubmitSenha(showInfoMessage, context);
      // Navigator.of(context).pop();
    }

    validarForm(bool isValid) {
      var formFields = viewModel.formSenha.getValues();
      var novaSenha = formFields?['novaSenha'] ?? '';
      var confirmarSenha = formFields?['confirmarSenha'] ?? '';
      if (novaSenha == confirmarSenha && isValid) {
        onSubmit();
      } else {
        showInfoMessage(
          context,
          2,
          Colors.red,
          'Senhas não coincidem!',
          'X',
          () {},
          Colors.white,
        );
      }
    }

    viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Senha alterada com sucesso!',
        'X',
        () {},
        Colors.white,
      );
      Navigator.pop(context, true);
    });

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
                    'Alterar senha da chave PIX',
                    style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.lock_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FormFieldsAlterarSenhaPix(
                        viewModel: viewModel,
                        jaTemSenha: jaTemSenha,
                      ),
                    ],
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
                    StreamBuilder<bool>(
                        stream: viewModel.formSenha.isValid,
                        builder: (context, snapshot) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextButton.icon(
                              icon: const Icon(
                                Icons.save_alt_outlined,
                                size: 20,
                              ),
                              label: const Text('Salvar'),
                              onPressed: () => validarForm(
                                  snapshot.data != null &&
                                      snapshot.data == true),
                              style: TextButton.styleFrom(
                                foregroundColor: snapshot.data != null &&
                                        snapshot.data == true
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
