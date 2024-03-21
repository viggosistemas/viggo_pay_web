import 'package:viggo_core_frontend/form/base_form.dart';
import 'package:viggo_core_frontend/form/cpf_cnpj_validator.dart';
import 'package:viggo_core_frontend/form/field/field.dart';
import 'package:viggo_core_frontend/form/field/stringfield.dart';
import 'package:viggo_core_frontend/form/field_length_validator.dart';
import 'package:viggo_core_frontend/form/validator.dart';

class EditFuncionarioFormFields extends BaseForm {
  final cpfCnpj = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      CPFCNPJValidator().validateCPFOuCNPJ,
      FieldLengthValidator().maiorQ14,
    ],
  );
  final nomeRazaoSocial = StringField(
    isRequired: true,
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ60,
      FieldLengthValidator().menorQ1,
    ],
  );
  final rgInscEst = StringField(
    validators: [
      FieldLengthValidator().maiorQ20,
    ],
  );
  final apelidoNomeFantasia = StringField(
    validators: [
      Validator().isEmptyValue,
      FieldLengthValidator().maiorQ60,
    ],
  );
  final userId = StringField(
    validators: [
      Validator().isEmptyValue,
    ],
  );

  @override
  List<Field> getFields() => [
        cpfCnpj,
        nomeRazaoSocial,
        rgInscEst,
        apelidoNomeFantasia,
      ];

  @override
  Map<String, String>? getValues() {
    if (!cpfCnpj.isValid || !nomeRazaoSocial.isValid) return null;

    return {
      'cpf_cnpj': cpfCnpj.value!,
      'nome_razao_social': nomeRazaoSocial.value!,
      'rg_insc_est': rgInscEst.value ?? '',
      'apelido_nome_fantasia': apelidoNomeFantasia.value ?? '',
      'user_id': userId.value ?? '',
    };
  }
}