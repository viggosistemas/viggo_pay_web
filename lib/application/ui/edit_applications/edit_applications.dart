import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/application/data/models/application_api_dto.dart';
import 'package:viggo_pay_admin/application/ui/edit_applications/edit_applications_form/edit_applications_form.dart';
import 'package:viggo_pay_admin/application/ui/edit_applications/edit_applications_view_model.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class EditApplications {
  EditApplications({required this.context});

  final BuildContext context;
  final viewModel = locator.get<EditApplicationsViewModel>();

  clearFields() {
    viewModel.form.name.onValueChange('');
    viewModel.form.description.onValueChange('');
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
        'Aplicação criada com sucesso!',
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
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Row(
                children: [
                  Text(
                    'Adicionando aplicação',
                    style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(Icons.domain_outlined),
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
                      EditApplicationsForm(
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
                    StreamBuilder<bool>(
                        stream: viewModel.form.isValid,
                        builder: (context, snapshot) {
                          return OnHoverButton(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextButton.icon(
                                icon: const Icon(
                                  Icons.save_alt_outlined,
                                  size: 20,
                                ),
                                label: const Text('Salvar'),
                                onPressed: () {
                                  if (snapshot.data != null && snapshot.data == true) {
                                    onSubmit();
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: snapshot.data != null && snapshot.data == true ? Colors.green : Colors.grey,
                                ),
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

  Future<void> editDialog(ApplicationApiDto entity) {
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
        'Aplicação editada com sucesso!',
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
                    'Editando Aplicação',
                    style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(Icons.domain_outlined),
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
                      EditApplicationsForm(
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
                    StreamBuilder<bool>(
                        stream: viewModel.form.isValid,
                        builder: (context, snapshot) {
                          return OnHoverButton(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextButton.icon(
                                icon: const Icon(
                                  Icons.save_alt_outlined,
                                  size: 20,
                                ),
                                label: const Text('Salvar'),
                                onPressed: () {
                                  if (snapshot.data != null && snapshot.data == true) {
                                    onSubmit();
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: snapshot.data != null && snapshot.data == true ? Colors.green : Colors.grey,
                                ),
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
