import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viggo_pay_admin/components/chips_input.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/funcionario_view_model.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_api_dto.dart';

// ignore: must_be_immutable
class EditContatoForm extends StatefulWidget {
  EditContatoForm({
    super.key,
    required this.viewModel,
    entity,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
  }

  final EditFuncionarioViewModel viewModel;
  // ignore: avoid_init_to_null
  late List<ParceiroContato>? entity = null;

  @override
  State<EditContatoForm> createState() => _EditContatoFormState();
}

class _EditContatoFormState extends State<EditContatoForm> {
  List<Map<String, dynamic>> contatos = [];
  List<ParceiroContato> contatosSave = [];

  submitContato(List<Map<String, dynamic>> tags) {
    setState(() {
      contatos.add({
        'contato': widget.viewModel.formContato.getValues()!['contato'],
        'tag': tags.map((e) => e['label']).toString(),
        'subtitle': tags
      });
      contatosSave.add(ParceiroContato.fromJson({
        'contato': widget.viewModel.formContato.getValues()!['contato'],
        'tag': tags
            .map((e) => e['label'])
            .toString()
            .replaceAll('(', '')
            .replaceAll(')', ''),
      }));
      widget.viewModel.formContato.contatos
          .onValueChange(jsonEncode(contatosSave));
      widget.viewModel.formContato.contato.onValueChange('');
    });
  }

  @override
  void initState() {
    if (widget.entity != null) {
      contatosSave = widget.entity!;
      for (var contato in widget.entity!) {
        contatos.add({
          'contato': contato.contato,
          'tag': contato.tag,
          'subtitle': contato.tag.split(',').map(
                (tag) => {
                  'label': tag,
                  'icon': Icons.contact_page_outlined,
                },
              ),
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(context) {
    final contatoController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: StreamBuilder<String>(
              stream: widget.viewModel.formContato.contato.field,
              builder: (context, snapshot) {
                contatoController.value =
                    contatoController.value.copyWith(text: snapshot.data);
                return TextFormField(
                    // onChanged: (value) {
                    //   _txtAmountValue = value;
                    // },
                    controller: contatoController,
                    decoration: InputDecoration(
                      labelText: 'Contato',
                      border: const OutlineInputBorder(),
                      errorText: snapshot.error?.toString(),
                    ),
                    onChanged: (value) {
                      widget.viewModel.formContato.contato.onValueChange(value);
                    });
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          EditableChipField(onSubmitTags: submitContato),
          if (contatos.isNotEmpty)
            SizedBox(
              height: 150,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: contatos.length,
                shrinkWrap: false,
                itemBuilder: (BuildContext context, int index) {
                  final option = contatos.elementAt(index);
                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                child: Icon(Icons.contact_page_outlined),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    option['contato'],
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      ...option['subtitle']
                                          .map(
                                            (e) => Chip(
                                              label: Text(e['label']),
                                              avatar: Icon(e['icon']),
                                            ),
                                          )
                                          .toList(),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          OnHoverButton(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  contatos.remove(option);
                                  contatosSave.removeWhere(
                                    (element) =>
                                        element.contato == option['contato'],
                                  );
                                  widget.viewModel.formContato.contatos
                                      .onValueChange(jsonEncode(contatosSave));
                                });
                              },
                              tooltip: 'Remover',
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
