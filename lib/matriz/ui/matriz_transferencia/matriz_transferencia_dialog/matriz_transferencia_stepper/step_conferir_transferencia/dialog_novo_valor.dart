import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';

class DialogNovoValor {
  DialogNovoValor({
    required this.context,
    required this.saldo,
  });

  final BuildContext context;
  final SaldoApiDto saldo;
  final viewModel = locator.get<MatrizTransferenciaViewModel>();
  final valorTransferenciaControll = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );

  getError(String? msg, String valor) {
    if (msg != null || valor.isEmpty) {
      return msg;
    } else if (valor.isNotEmpty) {
      if (double.parse(valor) > saldo.real) {
        return 'Valor não pode ser maior que o saldo atual!';
      } else if (double.parse(valor) == 0) {
        return 'Valor não pode ser igual a 0!';
      }
    }
  }

  removerMaskValor(String value) {
    return value
        .replaceAll(valorTransferenciaControll.leftSymbol, '')
        .replaceAll(valorTransferenciaControll.thousandSeparator, '')
        .replaceAll(valorTransferenciaControll.decimalSeparator, '.');
  }

  Future openDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          // valorTransferenciaControll.text =
          // viewModel.formStepValor.getValues()!['valor'].toString();

          return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) return;
            },
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Qual é o valor da transferência?',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Saldo disponível em conta R\$ ${saldo.real}',
                    style: Theme.of(context).textTheme.titleSmall!,
                  ),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: StreamBuilder<String>(
                    stream: viewModel.formStepValor.valor.field,
                    builder: (context, snapshot) {
                      valorTransferenciaControll.value = valorTransferenciaControll.value.copyWith(text: snapshot.data);
                      return TextFormField(
                        controller: valorTransferenciaControll,
                        decoration: InputDecoration(
                          labelText: 'Valor',
                          border: const OutlineInputBorder(),
                          errorText: getError(
                            snapshot.error?.toString(),
                            removerMaskValor(valorTransferenciaControll.value.text),
                          ),
                        ),
                        onChanged: (value) {
                          viewModel.formStepValor.valor.onValueChange(removerMaskValor(value));
                        },
                      );
                    }),
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
                        onPressed: () => Navigator.pop(context, false),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                    StreamBuilder<bool>(
                        stream: viewModel.formStepValor.isValid,
                        builder: (context, snapshot) {
                          return OnHoverButton(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextButton.icon(
                                icon: const Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 20,
                                ),
                                label: const Text('Confirmar'),
                                onPressed: () {
                                  if (snapshot.data != null &&
                                      snapshot.data == true &&
                                      valorTransferenciaControll.text.isNotEmpty &&
                                      double.parse(removerMaskValor(valorTransferenciaControll.text)) < saldo.real &&
                                      double.parse(removerMaskValor(valorTransferenciaControll.text)) > 0) {
                                    Navigator.pop(context, true);
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: snapshot.data != null &&
                                          snapshot.data == true &&
                                          valorTransferenciaControll.text.isNotEmpty &&
                                          double.parse(removerMaskValor(valorTransferenciaControll.text)) < saldo.real &&
                                          double.parse(removerMaskValor(valorTransferenciaControll.text)) > 0
                                      ? Colors.green
                                      : Colors.grey,
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
