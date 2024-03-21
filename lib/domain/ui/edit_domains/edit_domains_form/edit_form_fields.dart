import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class EditDomainFormFields extends BaseForm {
  final name = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );
  final displayName = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );
  final applicationId = StringField(
    isRequired: true,
  );
  final description = StringField(
    validators: [
      Validator().isEmptyValue,
    ],
  );

  @override
  List<Field> getFields() => [
        name,
        displayName,
        description,
        applicationId,
      ];

  @override
  Map<String, String>? getValues() {
    if (!name.isValid || !displayName.isValid || !applicationId.isValid) {
      return null;
    }
    return {
      'name': name.value!,
      'display_name': displayName.value!,
      'description': description.value ?? '',
      'application_id': applicationId.value!,
    };
  }
}
