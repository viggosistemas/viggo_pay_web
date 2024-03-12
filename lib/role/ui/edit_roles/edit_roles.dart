import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/role/ui/edit_roles/edit_roles_form/edit_roles_form.dart';
import 'package:viggo_pay_admin/role/ui/edit_roles/edit_roles_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';
import 'package:viggo_pay_core_frontend/role/data/models/role_api_dto.dart';

class EditRoles {
  EditRoles({required this.context});

  final BuildContext context;
  final viewModel = locator.get<EditRolesViewModel>();

  clearFields() {
    viewModel.form.onNameChange('');
    viewModel.form.onMultiDomainChange(null);
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
        'Papel de usuário criado com sucesso!',
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
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Row(
                children: [
                  Text(
                    'Adicionando papel de usuário',
                    style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(Icons.supervisor_account_outlined),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      EditRolesForm(
                        viewModel: viewModel,
                      )
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
                        stream: viewModel.form.isValid,
                        builder: (context, snapshot) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextButton.icon(
                              icon: const Icon(
                                Icons.save_alt_outlined,
                                size: 20,
                              ),
                              label: const Text('Salvar'),
                              onPressed: () {
                                if (snapshot.data != null &&
                                    snapshot.data == true) {
                                  onSubmit();
                                }
                              },
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

  Future<void> editDialog(RoleApiDto entity) {
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
        'Papel de usuário editado com sucesso!',
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
                    'Editando papel de usuário',
                    style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(Icons.supervisor_account_outlined),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      EditRolesForm(
                        entity: entity,
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
                    StreamBuilder<bool>(
                        stream: viewModel.form.isValid,
                        builder: (context, snapshot) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextButton.icon(
                              icon: const Icon(
                                Icons.save_alt_outlined,
                                size: 20,
                              ),
                              label: const Text('Salvar'),
                              onPressed: () {
                                if (snapshot.data != null &&
                                    snapshot.data == true) {
                                  onSubmit();
                                }
                              },
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
