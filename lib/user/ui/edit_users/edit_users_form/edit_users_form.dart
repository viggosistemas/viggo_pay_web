import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/user/ui/edit_users/edit_users_view_model.dart';
import 'package:viggo_pay_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_core_frontend/role/data/models/role_api_dto.dart';
import 'package:viggo_pay_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

// ignore: must_be_immutable
class EditUsersForm extends StatefulWidget {
  EditUsersForm({
    super.key,
    required this.viewModel,
    entity,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
  }

  final EditUsersViewModel viewModel;
  // ignore: avoid_init_to_null
  late UserApiDto? entity = null;

  @override
  State<EditUsersForm> createState() => _EditUsersFormState();
}

class _EditUsersFormState extends State<EditUsersForm> {
  getInitialValue() {
    if (widget.entity != null) {
      if (widget.entity?.domain != null) {
        return widget.entity?.domain?.name;
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  @override
  Widget build(context) {
    final nameFieldControll = TextEditingController();
    final emailFieldControll = TextEditingController();
    final domainFieldControll = TextEditingController();

    if (widget.entity != null) {
      widget.viewModel.form.onNameChange(widget.entity!.name);
    } else {
      widget.viewModel.form.onNameChange('');
    }
    if (widget.entity != null) {
      widget.viewModel.form.onEmailChange(widget.entity!.email);
    } else {
      widget.viewModel.form.onEmailChange('');
    }

    if (widget.entity != null) {
      if (widget.entity?.domain != null) {
        widget.viewModel.form.onDomainIdChange(widget.entity!.domainId);
      }
    } else {
      widget.viewModel.form.onDomainIdChange('');
    }

    contentRolesSelect() {
      if (widget.entity != null) {
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
                    widget.viewModel.loadGrantsUser(widget.entity!.id);
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
                                  Checkbox(
                                    value: role.selected,
                                    onChanged: (value) {
                                      setState(() {
                                        role.selected = value!;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    role.name,
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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

    return Column(
      children: [
        StreamBuilder<String>(
            stream: widget.viewModel.form.name,
            builder: (context, snapshot) {
              nameFieldControll.value =
                  nameFieldControll.value.copyWith(text: snapshot.data);
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
                    widget.viewModel.form.onNameChange(value);
                  });
            }),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
            stream: widget.viewModel.form.email,
            builder: (context, snapshot) {
              emailFieldControll.value =
                  emailFieldControll.value.copyWith(text: snapshot.data);
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
                    widget.viewModel.form.onEmailChange(value);
                  });
            }),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<List<DomainApiDto>>(
            stream: widget.viewModel.listDomains,
            builder: (context, snapshotList) {
              if (snapshotList.data == null) {
                widget.viewModel.loadDomains({
                  'list_options': ListOptions.ACTIVE_ONLY.name,
                  'order_by': 'name'
                });
              }
              return StreamBuilder<String>(
                  stream: widget.viewModel.form.domainId,
                  builder: (context, snapshot) {
                    domainFieldControll.value =
                        domainFieldControll.value.copyWith(text: snapshot.data);
                    return Autocomplete<DomainApiDto>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          widget.viewModel.loadDomains({
                            'list_options': ListOptions.ACTIVE_ONLY.name,
                            'order_by': 'name'
                          });
                          return const Iterable<DomainApiDto>.empty();
                        } else {
                          widget.viewModel.loadDomains({
                            'list_options': ListOptions.ACTIVE_ONLY.name,
                            'order_by': 'name',
                            'name': '%${textEditingValue.text}%'
                          });
                        }
                        if (snapshotList.data != null) {
                          return snapshotList.data!
                              .where((DomainApiDto option) {
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
                            width: 500, //define the same width of dialog
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              shrinkWrap: false,
                              itemBuilder: (BuildContext context, int index) {
                                final DomainApiDto option =
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
                            labelText: 'Domínio',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            border: const OutlineInputBorder(),
                            errorText: snapshot.error?.toString(),
                          ),
                          controller: controller,
                          focusNode: focusNode,
                          onChanged: (value) {
                            widget.viewModel.form.onDomainIdChange(value);
                          },
                        );
                      },
                      onSelected: (DomainApiDto selection) {
                        widget.viewModel.form.onDomainIdChange(selection.id);
                      },
                    );
                  });
            }),
        contentRolesSelect()
      ],
    );
  }
}
