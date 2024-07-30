import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts_view_model.dart';

class EditConfigForm extends StatefulWidget {
  const EditConfigForm({
    super.key,
    required this.viewModel,
    required this.entity,
  });

  final EditDomainAccountViewModel viewModel;
  final DomainAccountConfigApiDto entity;

  @override
  State<EditConfigForm> createState() => _EditConfigFormState();
}

class _EditConfigFormState extends State<EditConfigForm> {
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
  void initState() {
    isPercentualTaxa = widget.entity.porcentagem!;
    widget.viewModel.formConfig.taxa.onValueChange(widget.entity.taxa!.toString());
    widget.viewModel.formConfig.porcentagem.onValueChange(widget.entity.porcentagem!.toString());
    super.initState();
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

    return Column(
      children: [
        StreamBuilder<String>(
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
        const SizedBox(height: 10),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     StreamBuilder<String>(
        //       stream: widget.viewModel.formConfig.porcentagem.field,
        //       builder: (context, snapshot) {
        //         isPercentualTaxa =
        //             snapshot.data?.parseBool() ?? widget.entity.porcentagem!;
        //         return OnHoverButton(
        //           child: Checkbox(
        //             value:
        //                 snapshot.data?.parseBool() ?? widget.entity.porcentagem!,
        //             onChanged: (value) {
        //               widget.viewModel.formConfig.porcentagem
        //                   .onValueChange(value!.toString());
        //               setState(() {
        //                 isPercentualTaxa = value;
        //               });
        //             },
        //           ),
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
