import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:viggo_core_frontend/application/data/models/application_api_dto.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/domain/ui/edit_domains/edit_domains_view_model.dart';

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

  final nameFieldControll = TextEditingController();
  final displayNameFieldControll = TextEditingController();
  final descriptionFieldControll = TextEditingController();
  final applicationFieldControll = TextEditingController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(context) {
    var passwordVisible = false;

    if (widget.entity != null) {
      widget.viewModel.form.name.onValueChange(widget.entity!.name);
    }

    if (widget.entity != null) {
      widget.viewModel.form.displayName
          .onValueChange(widget.entity!.displayName);
    }

    if (widget.entity != null) {
      widget.viewModel.form.description
          .onValueChange(widget.entity!.description ?? '');
    }

    if (widget.entity != null) {
      if (widget.entity?.application != null) {
        widget.viewModel.form.applicationId
            .onValueChange(widget.entity!.applicationId);
      }
    }

    Widget contentForm() {
      if (widget.entity == null) {
        return Column(
          children: [
            StreamBuilder<String>(
                stream: widget.viewModel.formRegister.name.field,
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
                        widget.viewModel.formRegister.name.onValueChange(value);
                      });
                }),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<String>(
                stream: widget.viewModel.formRegister.displayName.field,
                builder: (context, snapshot) {
                  displayNameFieldControll.value = displayNameFieldControll
                      .value
                      .copyWith(text: snapshot.data);
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
                        widget.viewModel.formRegister.displayName
                            .onValueChange(value);
                      });
                }),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<String>(
                stream: widget.viewModel.formRegister.email.field,
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
                      widget.viewModel.formRegister.email.onValueChange(value);
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
            const SizedBox(height: 10),
            StreamBuilder<String>(
                stream: widget.viewModel.formRegister.password.field,
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
                      widget.viewModel.formRegister.password
                          .onValueChange(value);
                    },
                    obscureText: !passwordVisible,
                    autocorrect: false,
                    enableSuggestions: false,
                  );
                }),
          ],
        );
      } else {
        return Column(
          children: [
            StreamBuilder<String>(
                stream: widget.viewModel.form.name.field,
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
                        widget.viewModel.form.name.onValueChange(value);
                      });
                }),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<String>(
                stream: widget.viewModel.form.displayName.field,
                builder: (context, snapshot) {
                  displayNameFieldControll.value = displayNameFieldControll
                      .value
                      .copyWith(text: snapshot.data);
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
                        widget.viewModel.form.displayName.onValueChange(value);
                      });
                }),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<String>(
              stream: widget.viewModel.form.applicationId.field,
              builder: (context, snapshot) {
                applicationFieldControll.value = applicationFieldControll.value
                    .copyWith(text: snapshot.data);
                return Autocomplete<ApplicationApiDto>(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text == '') {
                      var options = await widget.viewModel.loadApplications({
                        'list_options': ListOptions.ACTIVE_ONLY.name,
                        'order_by': 'name'
                      });
                      return options!.where((element) => true);
                    } else {
                      var options = await widget.viewModel.loadApplications({
                        'list_options': ListOptions.ACTIVE_ONLY.name,
                        'order_by': 'name',
                        'name': '%${textEditingValue.text}%'
                      });
                      return options!.where((element) => true);
                    }
                  },
                  initialValue: TextEditingValue(text: getInitialValue()),
                  displayStringForOption: (option) => option.name,
                  optionsViewBuilder: (context, onSelected, options) => Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(4.0)),
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
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        border: const OutlineInputBorder(),
                        errorText: snapshot.error?.toString(),
                        suffix:
                            snapshot.data != null && snapshot.data!.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      widget.viewModel.form.applicationId
                                          .onValueChange('');
                                      controller.setText('');
                                    },
                                    icon: const Icon(
                                      Icons.cancel_outlined,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                  )
                                : const Text(''),
                      ),
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: (value) {
                        widget.viewModel.form.applicationId
                            .onValueChange(value);
                      },
                    );
                  },
                  onSelected: (ApplicationApiDto selection) {
                    widget.viewModel.form.applicationId
                        .onValueChange(selection.id);
                  },
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<String>(
                stream: widget.viewModel.form.description.field,
                builder: (context, snapshot) {
                  descriptionFieldControll.value = descriptionFieldControll
                      .value
                      .copyWith(text: snapshot.data);
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
                        widget.viewModel.form.description.onValueChange(value);
                      });
                }),
          ],
        );
      }
    }

    return Column(
      children: [contentForm()],
    );
  }
}
