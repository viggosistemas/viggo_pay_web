// ignore_for_file: avoid_init_to_null

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_core_frontend/role/data/models/role_api_dto.dart';
import 'package:viggo_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_core_frontend/util/constants.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/user/ui/edit_users/edit_users_view_model.dart';

// ignore: must_be_immutable
class EditUsersForm extends StatefulWidget {
  EditUsersForm({
    super.key,
    required this.viewModel,
    required this.onSubmit,
    entity,
    domain,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
    if (domain != null) {
      this.domain = domain;
    }
  }

  final EditUsersViewModel viewModel;
  final Function() onSubmit;
  late UserApiDto? entity = null;
  late DomainApiDto? domain = null;

  @override
  State<EditUsersForm> createState() => _EditUsersFormState();
}

class _EditUsersFormState extends State<EditUsersForm> {
  final nameFieldControll = TextEditingController();
  final emailFieldControll = TextEditingController();
  final domainFieldControll = TextEditingController();
// DomainApiDto mockLastOption = DomainApiDto.fromJson({
  //   "name": "",
  //   "display_name": "t",
  //   "application_id": "",
  //   "id": "last",
  //   "active": true,
  // });
  @override
  Widget build(context) {
    if (widget.entity != null) {
      widget.viewModel.form.name.onValueChange(widget.entity!.name);
    } else {
      widget.viewModel.form.name.onValueChange(nameFieldControll.value.text.isNotEmpty ? nameFieldControll.value.text : '');
    }
    if (widget.entity != null) {
      widget.viewModel.form.email.onValueChange(widget.entity!.email);
    } else {
      widget.viewModel.form.email.onValueChange(emailFieldControll.value.text.isNotEmpty ? emailFieldControll.value.text : '');
    }

    if (widget.entity != null) {
      if (widget.entity?.domain != null) {
        widget.viewModel.form.domainId.onValueChange(widget.entity!.domainId);
      }
    } else {
      widget.viewModel.form.domainId.onValueChange(domainFieldControll.value.text.isNotEmpty ? domainFieldControll.value.text : '');
    }

    isDefaultDomain() {
      var domain = widget.viewModel.sharedPrefs.getString(CoreUserPreferences.DOMAIN);
      if (domain != null) return jsonDecode(domain)['name'] == 'default';
      return false;
    }

    isNotUserLogged() {
      var userJson = widget.viewModel.sharedPrefs.getString(CoreUserPreferences.USER);
      if (userJson != null && widget.entity != null) {
        UserApiDto user = UserApiDto.fromJson(jsonDecode(userJson));
        return user.id != widget.entity!.id;
      }
      return true;
    }

    contentRolesSelect() {
      if ((widget.entity != null || isDefaultDomain()) && isNotUserLogged()) {
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Divider(
              height: 10,
              thickness: 0,
              indent: 0,
              endIndent: 0,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              'Papéis de usuário',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<List<RoleApiDto>>(
                stream: widget.viewModel.listRolesApplication,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    if (widget.entity != null) {
                      widget.viewModel.loadGrantsUser(widget.entity!.id, widget.domain);
                    } else {
                      widget.viewModel.grants = [];
                      widget.viewModel.loadRolesApplication(widget.domain);
                    }
                    return CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    );
                  } else {
                    return SizedBox(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...snapshot.data!.map(
                              (role) => Row(
                                children: [
                                  OnHoverButton(
                                    child: Checkbox(
                                      value: role.selected,
                                      onChanged: (value) {
                                        setState(() {
                                          role.selected = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    role.name,
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    }

    contentDomainField() {
      return StreamBuilder<String>(
        stream: widget.viewModel.form.domainId.field,
        builder: (context, snapshot) {
          domainFieldControll.value = domainFieldControll.value.copyWith(text: snapshot.data);
          return Autocomplete<DomainApiDto>(
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if (textEditingValue.text == '') {
                var options = await widget.viewModel.loadDomains({'list_options': ListOptions.ACTIVE_ONLY.name, 'order_by': 'name'});
                return options!.where((element) => true);
              } else {
                var options = await widget.viewModel
                    .loadDomains({'list_options': ListOptions.ACTIVE_ONLY.name, 'order_by': 'name', 'name': '%${textEditingValue.text}%'});
                return options!.where((element) => true);
              }
            },
            initialValue: TextEditingValue(text: widget.entity?.domain?.name ?? ''),
            displayStringForOption: (option) => option.name,
            optionsViewBuilder: (context, onSelected, options) => Align(
              alignment: Alignment.topLeft,
              child: Material(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
                ),
                child: SizedBox(
                  height: 52.0 * options.length,
                  width: 500, //define the same width of dialog
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    shrinkWrap: false,
                    itemBuilder: (BuildContext context, int index) {
                      final DomainApiDto option = options.elementAt(index);
                      return option.id == 'last'
                          ? OnHoverButton(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      size: 18,
                                    ),
                                    label: const Text('Adicionar agora')),
                              ),
                            )
                          : Container(
                              color: Colors.white,
                              child: InkWell(
                                highlightColor: Colors.white,
                                splashColor: Colors.white,
                                hoverColor: Colors.grey.withOpacity(0.8),
                                focusColor: Colors.white,
                                overlayColor: WidgetStatePropertyAll(Colors.grey.withOpacity(0.8)),
                                onTap: () => onSelected(option),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(option.name),
                                ),
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
                  labelText: 'Domínio',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                  suffix: snapshot.data != null && snapshot.data!.isNotEmpty
                      ? OnHoverButton(
                          child: IconButton(
                            onPressed: () {
                              widget.viewModel.form.domainId.onValueChange('');
                              controller.setText('');
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              size: 18,
                              color: Colors.red,
                            ),
                          ),
                        )
                      : const Text(''),
                ),
                controller: controller,
                focusNode: focusNode,
                onChanged: (value) {
                  widget.viewModel.form.domainId.onValueChange(value);
                },
              );
            },
            onSelected: (DomainApiDto selection) {
              widget.viewModel.form.domainId.onValueChange(selection.id);
            },
          );
        },
      );
    }

    return Column(
      children: [
        StreamBuilder<String>(
            stream: widget.viewModel.form.name.field,
            builder: (context, snapshot) {
              nameFieldControll.value = nameFieldControll.value.copyWith(text: snapshot.data);
              return TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  controller: nameFieldControll,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: const OutlineInputBorder(),
                    errorText: snapshot.error?.toString(),
                  ),
                  onChanged: (value) {
                    widget.viewModel.form.name.onValueChange(value);
                  });
            }),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
            stream: widget.viewModel.form.email.field,
            builder: (context, snapshot) {
              emailFieldControll.value = emailFieldControll.value.copyWith(text: snapshot.data);
              return TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  controller: emailFieldControll,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: const OutlineInputBorder(),
                    errorText: snapshot.error?.toString(),
                  ),
                  onChanged: (value) {
                    widget.viewModel.form.email.onValueChange(value);
                  });
            }),
        const SizedBox(
          height: 10,
        ),
        if (isDefaultDomain() && isNotUserLogged()) contentDomainField(),
        contentRolesSelect(),
        StreamBuilder<List<RoleApiDto>>(
            stream: widget.viewModel.listRolesApplication,
            builder: (ctx, rolesSnapshot) {
              return Row(
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ),
                  StreamBuilder<bool>(
                      stream: widget.viewModel.form.isValid,
                      builder: (context, validSnapshot) {
                        return OnHoverButton(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextButton.icon(
                              icon: const Icon(
                                Icons.save_alt_outlined,
                                size: 20,
                              ),
                              label: Text(validSnapshot.data != null && validSnapshot.data == false
                                  ? 'Cadastro inválido'
                                  : rolesSnapshot.data != null && !rolesSnapshot.data!.where((e) => e.selected).toList().isNotEmpty
                                      ? 'Selecione um papel'
                                      : 'Salvar'),
                              onPressed: () {
                                var isValidForm = validSnapshot.data != null && validSnapshot.data == true;
                                var isRoleSelected = rolesSnapshot.data != null && rolesSnapshot.data!.where((e) => e.selected).toList().isNotEmpty;
                                if (isValidForm && isRoleSelected) {
                                  widget.onSubmit();
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: validSnapshot.data != null &&
                                        validSnapshot.data == true &&
                                        rolesSnapshot.data != null &&
                                        rolesSnapshot.data!.where((e) => e.selected).toList().isNotEmpty
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              );
            }),
      ],
    );
  }
}
