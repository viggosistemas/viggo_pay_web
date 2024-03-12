import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';
import 'package:viggo_pay_core_frontend/role/data/models/role_api_dto.dart';

class EditRoleFormFields extends BaseForm with EditRolesFormFieldsValidation {
  final _nameController = BehaviorSubject<String>();
  Stream<String> get name => _nameController.stream.transform(nameValidation);
  Function(String) get onNameChange => _nameController.sink.add;

  final _multiDomainController = BehaviorSubject<bool?>();
  Stream<bool?> get multiDomain => _multiDomainController.stream;
  Function(bool?) get onMultiDomainChange => _multiDomainController.sink.add;

  @override
  List<Stream<String>> getStreams() => [name];

  @override
  Map<String, String>? getFields() {
    var name = _nameController.valueOrNull;
    var multiDomain = _multiDomainController.valueOrNull;

    if (name == null) {
      return null;
    }
    return {
      'name': name,
      'multiDomain': multiDomain == true
          ? RoleDataView.MULTI_DOMAIN.name
          : RoleDataView.DOMAIN.name
    };
  }
}

mixin EditRolesFormFieldsValidation {
  final nameValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [
        Validator().isRequired,
        Validator().isEmptyValue,
      ];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
