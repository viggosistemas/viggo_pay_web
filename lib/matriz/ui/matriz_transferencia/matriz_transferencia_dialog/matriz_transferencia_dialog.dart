import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_dialog/matriz_transferencia_stepper/matriz_transferencia_stepper.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';

class MatrizTransferenciaDialog {
  MatrizTransferenciaDialog({required this.context});

  final BuildContext context;
  final viewModel = locator.get<MatrizTransferenciaViewModel>();

  Future transferenciaDialog({
    required SaldoApiDto saldo,
    required List<PixToSendApiDto> pixToSendList,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return ScaffoldMessenger(
          child: Builder(
            builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child: GestureDetector(
                    onTap: () => {},
                    child: PopScope(
                      canPop: false,
                      onPopInvoked: (bool didPop) {
                        if (didPop) return;
                        Navigator.pop(context, true);
                      },
                      child: SimpleDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Transferindo saldo',
                                  style: Theme.of(ctx)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Icon(Icons.attach_money_outlined),
                              ],
                            ),
                            OnHoverButton(
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: MatrizTransferenciaStepper(
                                    saldo: saldo,
                                    pixToSendList: pixToSendList,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
