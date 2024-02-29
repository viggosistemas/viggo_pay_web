import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/domain/ui/edit_domains/edit_domains_view_model.dart';
import 'package:viggo_pay_core_frontend/application/data/models/application_api_dto.dart';
import 'package:viggo_pay_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

// ignore: must_be_immutable
class EditDomainsForm extends StatefulWidget {
  EditDomainsForm({
    super.key,
    required this.viewModel,
    entity,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
  }

  final EditDomainsViewModel viewModel;
  // ignore: avoid_init_to_null
  late DomainApiDto? entity = null;

  @override
  State<EditDomainsForm> createState() => _EditDomainsFormState();
}

class _EditDomainsFormState extends State<EditDomainsForm> {
  getInitialValue() {
    if (widget.entity != null) {
      if (widget.entity?.application != null) {
        return widget.entity?.application?.name;
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
    final displayNameFieldControll = TextEditingController();
    final descriptionFieldControll = TextEditingController();
    final applicationFieldControll = TextEditingController();

    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    var passwordVisible = false;

    if (widget.entity != null) {
      widget.viewModel.form.onNameChange(widget.entity!.name);
    }
    if (widget.entity != null) {
      widget.viewModel.form.onDisplayNameChange(widget.entity!.displayName);
    }
    if (widget.entity != null) {
      widget.viewModel.form
          .onDescriptionChange(widget.entity!.description ?? '');
    }
    if (widget.entity != null) {
      if (widget.entity?.application != null) {
        widget.viewModel.form
            .onApplicationIdChange(widget.entity!.applicationId);
      }
    }

    Widget contentRegisterOrUpdate() {
      if (widget.entity == null) {
        return Column(
          children: [
            StreamBuilder<String>(
                stream: widget.viewModel.form.email,
                builder: (context, snapshot) {
                  emailController.value =
                      emailController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email *',
                      border: const OutlineInputBorder(),
                      errorText: snapshot.error?.toString(),
                    ),
                    controller: emailController,
                    onChanged: (value) {
                      widget.viewModel.form.onEmailChange(value);
                    },
                    // onFieldSubmitted: (value) {
                    //   if (_validateForm()) {
                    //     viewModel.onSearch(
                    //         _domainController.text,
                    //         emailController.text,
                    //         passwordController.text,
                    //         showInfoMessage,
                    //         context);
                    //   }
                    // },
                  );
                }),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<String>(
                stream: widget.viewModel.form.password,
                builder: (context, snapshot) {
                  passwordController.value =
                      passwordController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Senha *',
                      border: const OutlineInputBorder(),
                      errorText: snapshot.error?.toString(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                    controller: passwordController,
                    onChanged: (value) {
                      widget.viewModel.form.onPasswordChange(value);
                    },
                    // onFieldSubmitted: (value) {
                    //   if (_validateForm()) {
                    //     viewModel.onSearch(
                    //         _domainController.text,
                    //         _userController.text,
                    //         passwordController.text,
                    //         showInfoMessage,
                    //         context);
                    //   }
                    // },
                    obscureText: !passwordVisible,
                    autocorrect: false,
                    enableSuggestions: false,
                  );
                }),
          ],
        );
      } else {
        return StreamBuilder<String>(
            stream: widget.viewModel.form.description,
            builder: (context, snapshot) {
              descriptionFieldControll.value =
                  descriptionFieldControll.value.copyWith(text: snapshot.data);
              return TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  maxLines: 8,
                  controller: descriptionFieldControll,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    border: const OutlineInputBorder(),
                    errorText: snapshot.error?.toString(),
                  ),
                  onChanged: (value) {
                    widget.viewModel.form.onDescriptionChange(value);
                  });
            });
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
            stream: widget.viewModel.form.displayName,
            builder: (context, snapshot) {
              displayNameFieldControll.value =
                  displayNameFieldControll.value.copyWith(text: snapshot.data);
              return TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  controller: displayNameFieldControll,
                  decoration: InputDecoration(
                    labelText: 'Nome formal',
                    border: const OutlineInputBorder(),
                    errorText: snapshot.error?.toString(),
                  ),
                  onChanged: (value) {
                    widget.viewModel.form.onDisplayNameChange(value);
                  });
            }),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<List<ApplicationApiDto>>(
            stream: widget.viewModel.listApplications,
            builder: (context, snapshotList) {
              if (snapshotList.data == null) {
                widget.viewModel.loadApplications({
                  'list_options': ListOptions.ACTIVE_ONLY.name,
                  'order_by': 'name'
                });
              }
              return StreamBuilder<String>(
                  stream: widget.viewModel.form.applicationId,
                  builder: (context, snapshot) {
                    applicationFieldControll.value = applicationFieldControll
                        .value
                        .copyWith(text: snapshot.data);
                    return Autocomplete<ApplicationApiDto>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          widget.viewModel.loadApplications({
                            'list_options': ListOptions.ACTIVE_ONLY.name,
                            'order_by': 'name'
                          });
                          return const Iterable<ApplicationApiDto>.empty();
                        } else {
                          widget.viewModel.loadApplications({
                            'list_options': ListOptions.ACTIVE_ONLY.name,
                            'order_by': 'name',
                            'name': '%${textEditingValue.text}%'
                          });
                        }
                        if (snapshotList.data != null) {
                          return snapshotList.data!
                              .where((ApplicationApiDto option) {
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
                                final ApplicationApiDto option =
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
                            labelText: 'Aplicação',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            border: const OutlineInputBorder(),
                            errorText: snapshot.error?.toString(),
                          ),
                          controller: controller,
                          focusNode: focusNode,
                          onChanged: (value) {
                            widget.viewModel.form.onApplicationIdChange(value);
                          },
                        );
                      },
                      onSelected: (ApplicationApiDto selection) {
                        widget.viewModel.form
                            .onApplicationIdChange(selection.id);
                      },
                    );
                  });
            }),
        const SizedBox(
          height: 10,
        ),
        contentRegisterOrUpdate()
      ],
    );
  }
}
