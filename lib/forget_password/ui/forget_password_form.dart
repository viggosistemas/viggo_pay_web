import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/components/dialogs.dart';
import 'package:viggo_pay_admin/forget_password/ui/fields_form/fields_form.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class ForgetPassForm extends StatefulWidget {
  final Function onSucess;
  const ForgetPassForm({
    super.key,
    required this.onSucess,
  });

  @override
  State<ForgetPassForm> createState() => _ForgetPassFormState();
}

class _ForgetPassFormState extends State<ForgetPassForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final viewModel = Provider.of<ForgetPasswordViewModel>(context);
    final dialogs = Dialogs(context: context);

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

    viewModel.isSuccess.listen((value) {
      dialogs
          .showSimpleDialog(
              'Email de recuperação de senha encaminhado!\n\nPor-favor, cheque seu SPAM ou CAIXA DE ENTRADA\n e finalize o processo de recuperação da senha!')
          .then((value) => widget.onSucess());
    });

    return StreamBuilder<bool>(
      stream: viewModel.isSuccess,
      builder: (context, snapshot) {
        return Column(
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: deviceSize.width * 0.2,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FieldsForm(
                        viewModel: viewModel,
                      ),
                      if (viewModel.isLoading)
                        const CircularProgressIndicator()
                      else
                        StreamBuilder<bool>(
                          stream: viewModel.form.isValid,
                          builder: (context, snapshot) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => {
                                  if (snapshot.data == true)
                                    viewModel.onSubmit(
                                      showInfoMessage,
                                      context,
                                    )
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(double.maxFinite, 40),
                                  alignment: Alignment.center,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 8,
                                  ),
                                  backgroundColor: snapshot.data == true
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                                  enabledMouseCursor: snapshot.data == true
                                      ? SystemMouseCursors.click
                                      : SystemMouseCursors.basic,
                                ),
                                label: const Text(
                                  'Recuperar senha',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          onPressed: () => widget.onSucess(),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(double.maxFinite, 40),
                            alignment: Alignment.center,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 8,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          label: const Text(
                            'Voltar pro login',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
