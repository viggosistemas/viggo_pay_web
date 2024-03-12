import 'package:flutter/material.dart';
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
  bool isPercentualTaxa = false;

  @override
  Widget build(BuildContext context) {
    final taxaFieldControll = TextEditingController();
    return Column(
      children: [
        StreamBuilder<String>(
          stream: widget.viewModel.formConfig.taxa,
          builder: (context, snapshot) {
            taxaFieldControll.value =
                taxaFieldControll.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: taxaFieldControll,
                decoration: InputDecoration(
                  labelText: 'Taxa',
                  suffixText: isPercentualTaxa ? ' %' : '',
                  prefixText: !isPercentualTaxa ? 'R\$ ' : '',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  widget.viewModel.formConfig.onTaxaChange(value);
                });
          },
        ),
        const SizedBox(height: 10),
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
    );
  }
}
