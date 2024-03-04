import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_core_frontend/form/base_form.dart';

class ListUsersFormField extends BaseForm {
  final _nameController = BehaviorSubject<String>();
  Stream<String> get name => _nameController.stream;
  Function(String) get onNameChange => _nameController.sink.add;

  @override
  Map<String, String>? getFields() {
    var name = _nameController.valueOrNull;

    if (name == null) return null;

    return {
      'name': '%$name%',
    };
  }

  @override
  List<Stream<String>> getStreams() => [name];
}
