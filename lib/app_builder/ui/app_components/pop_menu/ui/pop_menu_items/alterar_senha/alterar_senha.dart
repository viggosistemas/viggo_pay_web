import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_items/alterar_senha/form_fields.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class AlterarSenha {
  AlterarSenha({required this.context});

  final BuildContext context;
  final viewModel = locator.get<PopMenuViewModel>();

  Future<void> showFormDialog() {
    onSubmit() {
      viewModel.onSubmitSenha(showInfoMessage, context);
      // Navigator.of(context).pop();
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
                    'Alterar senha',
                    style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.key,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              content: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FormFieldsAlterarSenha(
                        viewModel: viewModel,
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
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.save_alt_outlined,
                          size: 20,
                        ),
                        label: const Text('Salvar'),
                        onPressed: () {
                          var formFields = viewModel.formSenha.getValues();
                          var novaSenha = formFields?['novaSenha'] ?? '';
                          var confirmarSenha =
                              formFields?['confirmarSenha'] ?? '';
                          if (novaSenha == confirmarSenha) {
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
                        },
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
