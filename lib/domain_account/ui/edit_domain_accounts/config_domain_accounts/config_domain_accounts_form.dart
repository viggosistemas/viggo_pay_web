import 'package:flutter/material.dart';
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
  bool isPercentualTaxa = false;

  @override
  void initState() {
    isPercentualTaxa = widget.entity.porcentagem!;
    widget.viewModel.formConfig.porcentagem
        .onValueChange(widget.entity.porcentagem!.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final taxaFieldControll = TextEditingController();
    taxaFieldControll.text = widget.entity.taxa.toString();

    return Column(
      children: [
        StreamBuilder<String>(
          stream: widget.viewModel.formConfig.taxa.field,
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
                  widget.viewModel.formConfig.taxa.onValueChange(value);
                });
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<String>(
              stream: widget.viewModel.formConfig.porcentagem.field,
              builder: (context, snapshot) {
                isPercentualTaxa =
                    snapshot.data?.parseBool() ?? widget.entity.porcentagem!;
                return Checkbox(
                  value:
                      snapshot.data?.parseBool() ?? widget.entity.porcentagem!,
                  onChanged: (value) {
                    widget.viewModel.formConfig.porcentagem
                        .onValueChange(value!.toString());
                    setState(() {
                      isPercentualTaxa = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(width: 6),
            const Text('Taxa em porcentagem'),
          ],
        ),
      ],
    );
  }
}
