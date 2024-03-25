import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/capability/data/models/capability_api_dto.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/application/ui/edit_policy/edit_policy_view_model.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class EditPolicyDialog {
  EditPolicyDialog({
    required this.context,
    required this.disponiveis,
    required this.roleId,
  });

  final BuildContext context;
  final viewModel = locator.get<EditPolicyViewModel>();
  final List<CapabilityApiDto> disponiveis;
  final String roleId;

  static const routesRowValues = ['route', 'route', 'route', 'route', 'route'];

  static const routesListLabelInclude = [
    'name',
    'url',
    'method',
    'bypass',
    'sysadmin'
  ];
  Future addDialog() {
    onSubmit() {
      viewModel.onAddPolicies(
        showInfoMessage,
        context,
        // disponiveis.where((element) => element.selected).toList(),
        disponiveis,
        roleId,
      );
    }

    viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Políticas adicionadas com sucesso!',
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
                    'Adicionando capacidades',
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
                width: MediaQuery.of(context).size.width * 0.55,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: DataTablePaginated(
                          viewModel: viewModel,
                          streamList: null,
                          dialogs: null,
                          addReloadButton: false,
                          initialFilters: const {},
                          columnsDef: const [
                            DataColumn(
                              label: Text(
                                'Nome',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'URL',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Método',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Bypass',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Sysadmin',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          fieldsData: routesRowValues,
                          labelInclude: routesListLabelInclude,
                          validActionsList: const [],
                          items: disponiveis.map((e) {
                            return e.toJson();
                          }).toList(),
                        ),
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
                    OnHoverButton(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextButton.icon(
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 20,
                          ),
                          label: const Text('Confirmar'),
                          onPressed: () => onSubmit(),
                          style:
                              TextButton.styleFrom(foregroundColor: Colors.green),
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
