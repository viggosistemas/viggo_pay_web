import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

class HeaderSearchFormFields extends BaseForm
    with HeaderSearchFormFieldsValidation {
  final _searchFieldController = BehaviorSubject<String>();
  Stream<String> get searchField =>
      _searchFieldController.stream.transform(searchValidation);
  Function(String) get onSearchChange => _searchFieldController.sink.add;

  @override
  List<Stream<String>> getStreams() => [searchField];

  @override
  Map<String, String>? getFields() {
    var searchField = _searchFieldController.valueOrNull;

    if (searchField == null) return null;

    return {
      'searchField': searchField,
    };
  }
}

mixin HeaderSearchFormFieldsValidation {
  final searchValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      List<Function(String)> validators = [];
      Validator().validateField(validators, value, sink.add, sink.addError);
    },
  );
}
