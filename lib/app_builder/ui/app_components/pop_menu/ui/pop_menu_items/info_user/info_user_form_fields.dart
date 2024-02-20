import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class InfoUserFormFields extends BaseForm
    with InfoUserFormFieldsValidation {
  final _ninckNameController = BehaviorSubject<String>();
  Stream<String> get nickname =>
      _ninckNameController.stream.transform(nickNameValidation);
  Function(String) get onNickNameChange => _ninckNameController.sink.add;

  @override
  List<Stream<String>> getStreams() => [nickname];

  @override
  Map<String, String>? getFields() {
    var nickname = _ninckNameController.valueOrNull;

    if (nickname == null) return null;

    return {
      'nickname': nickname,
    };
  }
}

mixin InfoUserFormFieldsValidation {
  final nickNameValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
