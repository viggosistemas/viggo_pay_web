import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_view_model.dart';

class EditTaxaEmpresa extends StatefulWidget {
  const EditTaxaEmpresa({
    super.key,
    required this.viewModel,
  });

  final MatrizViewModel viewModel;

  @override
  State<EditTaxaEmpresa> createState() => _EditTaxaEmpresaState();
}

class _EditTaxaEmpresaState extends State<EditTaxaEmpresa> {
  var taxaFieldControll = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );
  bool isPercentualTaxa = false;

  removerMaskValor(String value) {
    return value
        .replaceAll(taxaFieldControll.leftSymbol, '')
        .replaceAll(taxaFieldControll.thousandSeparator, '')
        .replaceAll(taxaFieldControll.decimalSeparator, '.');
  }

  @override
  Widget build(BuildContext context) {
    if (isPercentualTaxa) {
      taxaFieldControll = MoneyMaskedTextController(
        decimalSeparator: ',',
        thousandSeparator: '.',
        rightSymbol: ' %',
      );
    } else {
      taxaFieldControll = MoneyMaskedTextController(
        decimalSeparator: ',',
        thousandSeparator: '.',
        leftSymbol: 'R\$ ',
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(
                    width: constraints.maxWidth >= 960 ? constraints.maxWidth * 0.2 : constraints.maxWidth,
                    child: StreamBuilder<String>(
                      stream: widget.viewModel.formConfig.taxa.field,
                      builder: (context, snapshot) {
                        taxaFieldControll.updateValue(double.parse(snapshot.data ?? '0'));
                        return TextFormField(
                            controller: taxaFieldControll,
                            decoration: InputDecoration(
                              labelText: 'Taxa',
                              border: const OutlineInputBorder(),
                              errorText: snapshot.error?.toString(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                              signed: false,
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              widget.viewModel.formConfig.taxa.onValueChange(removerMaskValor(value));
                            });
                      },
                    ),
                  ),
                  // const SizedBox(height: 10),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     StreamBuilder<bool>(
                  //       stream: widget.viewModel.formConfig.porcentagem,
                  //       builder: (context, snapshot) {
                  //         isPercentualTaxa = snapshot.data ?? false;
                  //         return Checkbox(
                  //           value: snapshot.data ?? false,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               widget.viewModel.formConfig.onPorcentagemChange(value!);
                  //               isPercentualTaxa = value;
                  //             });
                  //           },
                  //         );
                  //       },
                  //     ),
                  //     const SizedBox(width: 6),
                  //     const Text('Taxa em porcentagem'),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
