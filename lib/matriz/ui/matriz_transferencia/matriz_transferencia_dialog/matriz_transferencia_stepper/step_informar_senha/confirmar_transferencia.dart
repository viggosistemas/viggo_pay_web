import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_dialog/matriz_transferencia_stepper/step_informar_senha/comprovante_pdv_viewer.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_dialog/matriz_transferencia_stepper/step_informar_senha/pin_input_senha.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';

class StepInformarSenha extends StatelessWidget {
  StepInformarSenha({
    super.key,
    required this.changePage,
    required this.currentPage,
  });

  final Function(int index) changePage;
  final int currentPage;
  final viewModel = locator.get<MatrizTransferenciaViewModel>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirmar transferência',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Informe a senha de 6 dígitos da sua conta no MATERA!',
              style: Theme.of(context).textTheme.titleSmall!,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: PinInputSenha(
                viewModel: viewModel,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OnHoverButton(
              child: ElevatedButton.icon(
                onPressed: () => changePage(currentPage - 1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  size: 18,
                ),
                label: const Text('Voltar'),
              ),
            ),
            StreamBuilder<String>(
                stream: viewModel.formStepSenha.senha.field,
                builder: (context, snapshot) {
                  return OnHoverButton(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              snapshot.data != null && snapshot.data!.length == 6
                                  ? Colors.green
                                  : Colors.grey,
                        ),
                        onPressed: () async {
                          var result = await showDialog(
                            context: context,
                            builder: (BuildContext ctx) => Dialog.fullscreen(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: ComprovantePdfViewer(),
                              ),
                            ),
                          );
                          if(result == true && context.mounted){
                            Navigator.pop(context, true);
                          }
                        },
                        icon: const Icon(
                          Icons.attach_money_outlined,
                          size: 18,
                        ),
                        label: const Text('Transferir'),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ],
    );
  }
}
