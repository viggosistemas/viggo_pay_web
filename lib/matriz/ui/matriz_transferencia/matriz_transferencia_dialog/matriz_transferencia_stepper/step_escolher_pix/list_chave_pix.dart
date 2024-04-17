import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/edit_pix_to_send/edit_pix_to_sends.dart';

class StepEscolherPix extends StatefulWidget {
  const StepEscolherPix({
    super.key,
    required this.changePage,
    required this.currentPage,
    required this.pixToSendList,
  });

  final Function(int index) changePage;
  final int currentPage;
  final List<PixToSendApiDto> pixToSendList;

  @override
  State<StepEscolherPix> createState() => _StepEscolherPixState();
}

class _StepEscolherPixState extends State<StepEscolherPix> {
  final viewModel = locator.get<MatrizTransferenciaViewModel>();

  getColorSelect(String? pixSelect, PixToSendApiDto pixIndex) {
    if (pixSelect != null) {
      var pix = PixToSendApiDto.fromJson(jsonDecode(pixSelect));
      return pix.id == pixIndex.id ? Colors.green : Colors.transparent;
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dialogs = EditPixToSends(context: context);
    final contatoTransferenciaControll = TextEditingController();
    final valorTransferido = viewModel.formStepValor.getValues()!['valor'].toString();

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quem irá receber a transferência no valor de R\$ $valorTransferido?',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Encontre na listagem abaixo qual contato irá receber o valor ou crie um novo contato PIX.',
              style: Theme.of(context).textTheme.titleSmall!,
            ),
          ],
        ),
        StreamBuilder<String>(
            stream: viewModel.formStepSelectPix.contato.field,
            builder: (context, contatoData) {
              contatoTransferenciaControll.value = contatoTransferenciaControll.value.copyWith(text: contatoData.data);
              return ListTile(
                title: TextFormField(
                  controller: contatoTransferenciaControll,
                  decoration: InputDecoration(
                    labelText: 'Nome, CPF/CNPJ ou Chave PIX',
                    border: const OutlineInputBorder(),
                    errorText: contatoData.error?.toString(),
                  ),
                  onChanged: (value) {
                    viewModel.formStepSelectPix.contato.onValueChange(value);
                  },
                ),
                trailing: OnHoverButton(
                  child: IconButton(
                    onPressed: () async {
                      var result = await dialogs.addDialog(contatoTransferenciaControll.text);
                      contatoTransferenciaControll.clear();
                      if (result != null) {
                        setState(() {
                          widget.pixToSendList.add(result);
                          viewModel.formStepSelectPix.pixSelect.onValueChange(jsonEncode(result));
                        });
                      }
                    },
                    tooltip: 'Adicionar nova chave Pix',
                    icon: Icon(
                      Icons.add_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              );
            }),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          width: double.infinity,
          height: 200,
          child: ListView.builder(
            itemCount: widget.pixToSendList.length,
            itemBuilder: (ctx, index) => StreamBuilder<String>(
                stream: viewModel.formStepSelectPix.pixSelect.field,
                builder: (context, pixSelectData) {
                  return ListTile(
                    horizontalTitleGap: 20,
                    hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        widget.pixToSendList[index].holderName.substring(0, 2).toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(right: 16),
                    title: Text(
                      widget.pixToSendList[index].holderName,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          widget.pixToSendList[index].alias,
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
                          '${widget.pixToSendList[index].pspName} - ' +
                              'Ag: ${widget.pixToSendList[index].destinationBranch} - ' +
                              'Conta: ${widget.pixToSendList[index].destinationAccount}',
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (pixSelectData.data != null) {
                        var pix = PixToSendApiDto.fromJson(jsonDecode(pixSelectData.data!));
                        if (widget.pixToSendList[index].id == pix.id) {
                          viewModel.formStepSelectPix.pixSelect.onValueChange('');
                        } else {
                          viewModel.formStepSelectPix.pixSelect.onValueChange(jsonEncode(widget.pixToSendList[index]));
                        }
                      } else {
                        viewModel.formStepSelectPix.pixSelect.onValueChange(jsonEncode(widget.pixToSendList[index]));
                      }
                    },
                    trailing: Icon(
                      Icons.check_circle_outline,
                      color: getColorSelect(
                        pixSelectData.data,
                        widget.pixToSendList[index],
                      ),
                    ),
                  );
                }),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OnHoverButton(
              child: ElevatedButton.icon(
                onPressed: () => widget.changePage(widget.currentPage - 1),
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
            StreamBuilder<bool>(
                stream: viewModel.formStepSelectPix.isValid,
                builder: (context, validForm) {
                  return OnHoverButton(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        onPressed: () => validForm.data != null && validForm.data == true ? widget.changePage(widget.currentPage + 1) : {},
                        icon: const Icon(
                          Icons.arrow_back_outlined,
                          size: 18,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: validForm.data != null && validForm.data == true ? Theme.of(context).colorScheme.primary : Colors.grey),
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
