import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viggo_pay_admin/login/ui/login_view_model.dart';
import 'package:viggo_pay_core_frontend/domain/data/models/domain_api_dto.dart';

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
                stream: widget.viewModel.form.domain,
                builder: (context, snapshot) {
                  _domainController.value =
                      _domainController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Domínio *',
                      border: const OutlineInputBorder(),
                      errorText: snapshot.error?.toString(),
                    ),
                    controller: _domainController,
                    onChanged: (value) {
                      widget.viewModel.form.onDomainChange(value);
                    },
                    // onFieldSubmitted: (value) {
                    //   if (_validateForm()) {
                    //     viewModel.onSearch(
                    //       _domainController.text,
                    //       _userController.text,
                    //       _passwordController.text,
                    //       showInfoMessage,
                    //       context,
                    //     );
                    //   }
                    // },
                  );
                },
              ),
            ],
          );
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

    return Column(
      children: [
        domainContent,
        const SizedBox(height: 10),
        StreamBuilder<String>(
            stream: widget.viewModel.form.username,
            builder: (context, snapshot) {
              _userController.value =
                  _userController.value.copyWith(text: snapshot.data ?? '');
              return TextFormField(
                decoration: InputDecoration(
                  labelText: 'Usuário ou Email *',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                controller: _userController,
                onChanged: (value) {
                  widget.viewModel.form.onEmailChange(value);
                },
                // onFieldSubmitted: (value) {
                //   if (_validateForm()) {
                //     viewModel.onSearch(
                //         _domainController.text,
                //         _userController.text,
                //         _passwordController.text,
                //         showInfoMessage,
                //         context);
                //   }
                // },
              );
            }),
        const SizedBox(height: 10),
        StreamBuilder<String>(
            stream: widget.viewModel.form.password,
            builder: (context, snapshot) {
              _passwordController.value =
                  _passwordController.value.copyWith(text: snapshot.data);
              return TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha *',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
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
                  widget.viewModel.form.onPasswordChange(value);
                },
                // onFieldSubmitted: (value) {
                //   if (_validateForm()) {
                //     viewModel.onSearch(
                //         _domainController.text,
                //         _userController.text,
                //         _passwordController.text,
                //         showInfoMessage,
                //         context);
                //   }
                // },
                obscureText: !_passwordVisible,
                autocorrect: false,
                enableSuggestions: false,
              );
            }),
        const SizedBox(height: 20),
      ],
    );
  }
}
