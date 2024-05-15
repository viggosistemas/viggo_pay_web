import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_pay_admin/application/ui/components/table_routes.dart';
import 'package:viggo_pay_admin/application/ui/edit_capability/edit_capability_view_model.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class EditCapabilityDialog {
  EditCapabilityDialog({
    required this.context,
    required this.disponiveis,
    required this.applicationId,
  });

  final BuildContext context;
  final viewModel = locator.get<EditCapabilityViewModel>();
  final List<RouteApiDto> disponiveis;
  final String applicationId;

  static const routesRowValues = ['name', 'url', 'method', 'bypass', 'sysadmin'];

  Future addDialog() {
    onSubmit(List<RouteApiDto> selecionadas) {
      viewModel.onAddCapabilities(
        showInfoMessage,
        context,
        selecionadas,
        applicationId,
      );
    }

    viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Capacidades adicionadas com sucesso!',
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
          viewModel.capabilitiesSelectedController.sink.add([]);
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width,
                        child: DataTableRoutes(
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
                              const Icon(Icons.polyline_outlined),
                            ],
                          ),
                          viewModel: viewModel,
                          fieldsData: routesRowValues,
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
                    StreamBuilder<List<RouteApiDto>>(
                        stream: viewModel.capabilitiesSelected,
                        builder: (context, selecionadas) {
                          return StreamBuilder<bool>(
                              stream: viewModel.capabilitiesSelectedValid,
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
                                      onPressed: () => snapshot.data == true ? onSubmit(selecionadas.data!) : {},
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
