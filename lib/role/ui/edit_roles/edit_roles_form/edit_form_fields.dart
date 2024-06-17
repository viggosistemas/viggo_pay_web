import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/validator.dart';
import 'package:viggo_core_frontend/role/data/models/role_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts_view_model.dart';

class EditRoleFormFields extends BaseForm {
  final name = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
    ],
  );
  final multiDomain = StringField();

  @override
  List<Field> getFields() => [name];

  @override
  Map<String, String>? getValues() {
    if (!name.isValid) return null;

    return {
      'name': name.value!,
      'multiDomain': multiDomain.value?.parseBool() == true
          ? RoleDataView.MULTI_DOMAIN.name
          : RoleDataView.DOMAIN.name
    };
  }
}
