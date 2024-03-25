import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';

/// This is the basic usage of Pinput
/// For more examples check out the demo directory
class PinInputSenha extends StatefulWidget {
  const PinInputSenha({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final MatrizTransferenciaViewModel viewModel;

  @override
  State<PinInputSenha> createState() => _PinInputSenhaState();
}

class _PinInputSenhaState extends State<PinInputSenha> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusedBorderColor = Theme.of(context).colorScheme.primary;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    final borderColor = Theme.of(context).colorScheme.primary;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    /// Optionally you can use form to validate the Pinput
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<String>(
            stream: widget.viewModel.formStepSenha.senha.field,
            builder: (context, snapshot) {
              pinController.value =
                  pinController.value.copyWith(text: snapshot.data);
              return Directionality(
                // Specify direction if desired
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: 6,
                  obscureText: true,
                  controller: pinController,
                  focusNode: focusNode,
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsUserConsentApi,
                  listenForMultipleSmsOnAndroid: true,
                  defaultPinTheme: defaultPinTheme,
                  separatorBuilder: (index) => const SizedBox(width: 8),
                  validator: (value) {
                    return snapshot.error?.toString();
                  },
                  // onClipboardFound: (value) {
                  //   debugPrint('onClipboardFound: $value');
                  //   pinController.setText(value);
                  // },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) {
                    widget.viewModel.formStepSenha.senha.onValueChange(pin);
                  },
                  onChanged: (value) {
                    widget.viewModel.formStepSenha.senha.onValueChange(value);
                  },
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        width: 22,
                        height: 1,
                        color: focusedBorderColor,
                      ),
                    ],
                  ),
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border.all(color: Colors.redAccent),
                  ),
                ),
              );
            }),
        // TextButton(
        //   onPressed: () {
        //     focusNode.unfocus();
        //     formKey.currentState!.validate();
        //   },
        //   child: const Text('Validate'),
        // ),
      ],
    );
  }
}
