import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts_view_model.dart';
import 'package:viggo_pay_admin/domain_account/ui/list_domain_accounts/list_domain_accounts_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class ConfigDomainAccounts {
  ConfigDomainAccounts({required this.context});

  final BuildContext context;
  final viewModelList = locator.get<ListDomainAccountViewModel>();
  final viewModel = locator.get<EditDomainAccountViewModel>();


  Future<void> configDialog(DomainAccountConfigApiDto entity) {
    final taxaFieldControll = TextEditingController();
    taxaFieldControll.text = entity.taxa.toString();
    viewModel.formConfig.onPorcentagemChange(entity.porcentagem!);

    onSubmit() {
      viewModel.submitConfig(
        entity,
        showInfoMessage,
        context,
      );
      // Navigator.of(context).pop();
    }

    viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Configuração atualizada com sucesso!',
        'X',
        () {},
        Colors.white,
      );
      viewModelList.clearSelectionConfig();
      viewModelList.clearSelectedItems.invoke();
      Navigator.pop(context, true);
    });

    viewModel.isError.listen(
      (value) {
        showInfoMessage(
          context,
          2,
          Colors.red,
          value,
          'X',
          () {},
          Colors.white,
        );
      },
    );

    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) return;
              Navigator.pop(context, true);
            },
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Row(
                children: [
                  Text(
                    // ignore: unnecessary_null_comparison
                    '${entity.id != null && entity.id.isNotEmpty ? 'Editando' : 'Adicionando'} configuração da conta',
                    style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(Icons.settings),
                ],
              ),
              content: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StreamBuilder<String>(
                        stream: viewModel.formConfig.taxa,
                        builder: (context, snapshot) {
                          taxaFieldControll.value = taxaFieldControll.value
                              .copyWith(text: snapshot.data);
                          return TextFormField(
                              // onChanged: (value) {
                              //   _txtAmountValue = value;
                              // },
                              controller: taxaFieldControll,
                              decoration: InputDecoration(
                                labelText: 'Taxa',
                                suffixText: ' %',
                                border: const OutlineInputBorder(),
                                errorText: snapshot.error?.toString(),
                              ),
                              onChanged: (value) {
                                viewModel.formConfig.onTaxaChange(value);
                              });
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder<bool>(
                            stream: viewModel.formConfig.porcentagem,
                            builder: (context, snapshot) {
                              return Checkbox(
                                value: snapshot.data ?? entity.porcentagem,
                                onChanged: (value) {
                                  viewModel.formConfig
                                      .onPorcentagemChange(value!);
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 6),
                          const Text('Taxa em porcentagem'),
                        ],
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
                    TextButton.icon(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 20,
                      ),
                      label: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        viewModelList.clearSelectionConfig();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.save_alt_outlined,
                          size: 20,
                        ),
                        label: const Text('Salvar'),
                        onPressed: () => onSubmit(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
