import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/funcionario_view_model.dart';
import 'package:viggo_pay_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

// ignore: must_be_immutable
class EditFuncionarioForm extends StatefulWidget {
  EditFuncionarioForm({
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
  late FuncionarioApiDto? entity = null;

  @override
  State<EditFuncionarioForm> createState() => _EditFuncionarioFormState();
}

class _EditFuncionarioFormState extends State<EditFuncionarioForm> {
  bool jaPreencheu = false;

  getInitialValue() {
    if (widget.entity != null) {
      if (widget.entity?.user != null) {
        return widget.entity?.user?.name;
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  initFormValues() {
    if (jaPreencheu == false) {
      jaPreencheu = true;
      if (widget.entity != null) {
        widget.viewModel.formDados
            .onNomeRazaoSocialChange(widget.entity!.parceiro!.nomeRazaoSocial);
      }
      if (widget.entity != null) {
        widget.viewModel.formDados
            .onCpfCnpjChange(widget.entity!.parceiro!.cpfCnpj);
      }
      if (widget.entity != null) {
        widget.viewModel.formDados.onApelidoNomeFantasiaChange(
            widget.entity!.parceiro!.apelidoNomeFantasia ?? '');
      }
      if (widget.entity != null) {
        widget.viewModel.formDados
            .onRgInscEstChange(widget.entity!.parceiro!.rgInscEst ?? '');
      }
      if (widget.entity != null) {
        if (widget.entity?.user != null) {
          widget.viewModel.formDados.onUserIdChange(widget.entity!.userId!);
        }
      }
    }
  }

  @override
  Widget build(context) {
    final nomeRazaoSocialFieldControll = TextEditingController();
    final cpfCnpjFieldControll = TextEditingController();
    final apelidoNomeFantasiaControll = TextEditingController();
    final rgInscEstControll = TextEditingController();
    final userFieldControll = TextEditingController();

    initFormValues();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        StreamBuilder<String>(
          stream: widget.viewModel.formDados.cpfCnpj,
          builder: (context, snapshot) {
            cpfCnpjFieldControll.value =
                cpfCnpjFieldControll.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: cpfCnpjFieldControll,
                decoration: InputDecoration(
                  labelText: 'CPF/CNPJ',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfOuCnpjFormatter(),
                  // MaskTextInputFormatter(mask: "###.###.###-##")
                ],
                onChanged: (value) {
                  widget.viewModel.formDados.onCpfCnpjChange(value);
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: widget.viewModel.formDados.nomeRazaoSocial,
          builder: (context, snapshot) {
            nomeRazaoSocialFieldControll.value = nomeRazaoSocialFieldControll
                .value
                .copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: nomeRazaoSocialFieldControll,
                decoration: InputDecoration(
                  labelText: 'Nome razão social',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  widget.viewModel.formDados.onNomeRazaoSocialChange(value);
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: widget.viewModel.formDados.apelidoNomeFantasia,
          builder: (context, snapshot) {
            apelidoNomeFantasiaControll.value =
                apelidoNomeFantasiaControll.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: apelidoNomeFantasiaControll,
                decoration: InputDecoration(
                  labelText: 'Apelido/Nome fantasia',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  widget.viewModel.formDados.onApelidoNomeFantasiaChange(value);
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: widget.viewModel.formDados.rgInscEst,
          builder: (context, snapshot) {
            rgInscEstControll.value =
                rgInscEstControll.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: rgInscEstControll,
                decoration: InputDecoration(
                  labelText: 'Rg/Insc. Estadual',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  widget.viewModel.formDados.onRgInscEstChange(value);
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<List<UserApiDto>>(
            stream: widget.viewModel.listUsers,
            builder: (context, snapshotList) {
              if (snapshotList.data == null) {
                widget.viewModel.loadUsers({
                  'list_options': ListOptions.ACTIVE_ONLY.name,
                  'order_by': 'name'
                });
              }
              return StreamBuilder<String>(
                  stream: widget.viewModel.formDados.userId,
                  builder: (context, snapshot) {
                    userFieldControll.value =
                        userFieldControll.value.copyWith(text: snapshot.data);
                    return Autocomplete<UserApiDto>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          widget.viewModel.loadUsers({
                            'list_options': ListOptions.ACTIVE_ONLY.name,
                            'order_by': 'name'
                          });
                          return const Iterable<UserApiDto>.empty();
                        } else {
                          widget.viewModel.loadUsers({
                            'list_options': ListOptions.ACTIVE_ONLY.name,
                            'order_by': 'name',
                            'name': '%${textEditingValue.text}%'
                          });
                        }
                        if (snapshotList.data != null) {
                          return snapshotList.data!.where((UserApiDto option) {
                            return option.name
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        } else {
                          return {};
                        }
                      },
                      initialValue: TextEditingValue(text: getInitialValue()),
                      displayStringForOption: (option) => option.name,
                      optionsViewBuilder: (context, onSelected, options) =>
                          Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(4.0)),
                          ),
                          child: SizedBox(
                            height: 52.0 * options.length,
                            width: 680, //define the same width of dialog
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              shrinkWrap: false,
                              itemBuilder: (BuildContext context, int index) {
                                final UserApiDto option =
                                    options.elementAt(index);
                                return InkWell(
                                  onTap: () => onSelected(option),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(option.name),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      fieldViewBuilder: (
                        BuildContext context,
                        TextEditingController controller,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        return TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Usuário',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            border: const OutlineInputBorder(),
                            errorText: snapshot.error?.toString(),
                          ),
                          controller: controller,
                          focusNode: focusNode,
                          onChanged: (value) {
                            widget.viewModel.formDados.onUserIdChange(value);
                          },
                        );
                      },
                      onSelected: (UserApiDto selection) {
                        widget.viewModel.formDados.onUserIdChange(selection.id);
                      },
                    );
                  });
            }),
      ],
    );
  }
}
