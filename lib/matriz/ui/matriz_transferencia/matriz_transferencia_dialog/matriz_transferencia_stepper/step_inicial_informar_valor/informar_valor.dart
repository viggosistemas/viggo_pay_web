import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';

class StepInformarValor extends StatelessWidget {
  StepInformarValor({super.key, required this.changePage, required this.currentPage, required this.saldo});

  final Function(int index) changePage;
  final int currentPage;
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
        StreamBuilder<String>(
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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                  signed: false,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  viewModel.formStepValor.valor.onValueChange(removerMaskValor(value));
                },
              );
            }),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OnHoverButton(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  size: 18,
                ),
                label: const Text('Cancelar'),
              ),
            ),
            StreamBuilder<bool>(
                stream: viewModel.formStepValor.isValid,
                builder: (context, snapshot) {
                  return OnHoverButton(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: snapshot.data != null &&
                                  snapshot.data == true &&
                                  valorTransferenciaControll.text.isNotEmpty &&
                                  double.parse(removerMaskValor(valorTransferenciaControll.text)) < saldo.real &&
                                  double.parse(removerMaskValor(valorTransferenciaControll.text)) > 0
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                        onPressed: () {
                          if (snapshot.data != null &&
                              snapshot.data == true &&
                              valorTransferenciaControll.text.isNotEmpty &&
                              double.parse(removerMaskValor(valorTransferenciaControll.text)) < saldo.real &&
                              double.parse(removerMaskValor(valorTransferenciaControll.text)) > 0) {
                            changePage(currentPage + 1);
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back_outlined,
                          size: 18,
                        ),
                        label: const Text('Próximo'),
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
