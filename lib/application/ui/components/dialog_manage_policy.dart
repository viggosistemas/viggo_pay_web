import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/capability/data/models/capability_api_dto.dart';
import 'package:viggo_pay_admin/application/ui/components/table_list_manage_policy.dart';
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
  late List<CapabilityApiDto> disponiveis = [];
  late List<CapabilityApiDto> bckDisponiveis = disponiveis;
  final String roleId;

  Future addDialog() {
    onSubmit(List<CapabilityApiDto> selecionadas) {
      viewModel.onAddPolicies(
        showInfoMessage,
        context,
        selecionadas,
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
          var width = MediaQuery.of(context).size.width * 0.55;
          viewModel.policiesSelectedController.sink.add([]);
          return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) return;
              Navigator.pop(context, true);
            },
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              content: SizedBox(
                width: width,
                child: SingleChildScrollView(
                  child: TableListPolicy(
                    bckDisponiveis: bckDisponiveis,
                    disponiveis: disponiveis,
                    width: width,
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
                    StreamBuilder<List<CapabilityApiDto>>(
                        stream: viewModel.policiesSelected,
                        builder: (context, seleciondas) {
                          return StreamBuilder<bool>(
                              stream: viewModel.policiesSelectedValid,
                              builder: (context, snapshot) {
                                return OnHoverButton(
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.check_circle_outline,
                                        size: 20,
                                      ),
                                      label: const Text('Confirmar'),
                                      onPressed: () => snapshot.data == true ? onSubmit(seleciondas.data!) : {},
                                      style: ElevatedButton.styleFrom(backgroundColor: snapshot.data == true ? Colors.green : Colors.grey),
                                    ),
                                  ),
                                );
                              });
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
