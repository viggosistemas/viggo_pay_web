import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_admin/login/ui/login_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

// ignore: must_be_immutable
class FieldsForm extends StatefulWidget {
  FieldsForm({
    super.key,
    required this.viewModel,
    required this.showImage,
  });

  final LoginViewModel viewModel;
  Widget? Function(
    String? logoId,
    String? domainName,
    LoginViewModel viewModel,
  ) showImage;

  @override
  State<FieldsForm> createState() => _FieldsFormState();
}

class _FieldsFormState extends State<FieldsForm> {
  final _domainController = TextEditingController();

  final _userController = TextEditingController();

  final _passwordController = TextEditingController();

  var _passwordVisible = false;

  @override
  Widget build(context) {
    var domainContent = StreamBuilder<DomainApiDto?>(
      stream: widget.viewModel.domainDto,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          widget.viewModel.getDomain();
          return StreamBuilder<bool>(
              stream: widget.viewModel.form.isValid,
              builder: (context, formValidData) {
                return Column(
                  children: [
                    Text(
                      'Bem-Vindo',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StreamBuilder<String>(
                      stream: widget.viewModel.form.domain.field,
                      builder: (context, fieldDomainData) {
                        _domainController.value = _domainController.value.copyWith(text: fieldDomainData.data);
                        return TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Domínio *',
                            border: const OutlineInputBorder(),
                            errorText: fieldDomainData.error?.toString(),
                          ),
                          controller: _domainController,
                          onChanged: (value) {
                            widget.viewModel.form.domain.onValueChange(value);
                          },
                          onFieldSubmitted: (value) {
                            if (formValidData.data == true) {
                              widget.viewModel.onSubmit(
                                showInfoMessage,
                                context,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                );
              });
        } else {
          return Column(
            children: [
              SizedBox(
                width: 100,
                child: widget.showImage(
                  snapshot.data?.logoId,
                  snapshot.data?.displayName,
                  widget.viewModel,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Bem-Vindo',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }
      },
    );

    return StreamBuilder<bool>(
        stream: widget.viewModel.form.isValid,
        builder: (context, formValidData) {
          return Column(
            children: [
              domainContent,
              const SizedBox(height: 10),
              StreamBuilder<String>(
                  stream: widget.viewModel.form.username.field,
                  builder: (context, fieldUserValid) {
                    _userController.value = _userController.value.copyWith(text: fieldUserValid.data ?? '');
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Usuário ou Email *',
                        border: const OutlineInputBorder(),
                        errorText: fieldUserValid.error?.toString(),
                      ),
                      controller: _userController,
                      onChanged: (value) {
                        widget.viewModel.form.username.onValueChange(value);
                      },
                      onFieldSubmitted: (value) {
                        if (formValidData.data == true) {
                          widget.viewModel.onSubmit(
                            showInfoMessage,
                            context,
                          );
                        }
                      },
                    );
                  }),
              const SizedBox(height: 10),
              StreamBuilder<String>(
                  stream: widget.viewModel.form.password.field,
                  builder: (context, fieldPassValid) {
                    _passwordController.value = _passwordController.value.copyWith(text: fieldPassValid.data);
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha *',
                        border: const OutlineInputBorder(),
                        errorText: fieldPassValid.error?.toString(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      controller: _passwordController,
                      onChanged: (value) {
                        widget.viewModel.form.password.onValueChange(value);
                      },
                      onFieldSubmitted: (value) {
                        if (formValidData.data == true) {
                          widget.viewModel.onSubmit(
                            showInfoMessage,
                            context,
                          );
                        }
                      },
                      obscureText: !_passwordVisible,
                      autocorrect: false,
                      enableSuggestions: false,
                    );
                  }),
              const SizedBox(height: 20),
            ],
          );
        });
  }
}
