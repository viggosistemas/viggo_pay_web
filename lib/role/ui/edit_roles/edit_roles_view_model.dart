import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/role/ui/edit_roles/edit_roles_form/edit_form_fields.dart';
import 'package:viggo_pay_core_frontend/base/base_view_model.dart';
import 'package:viggo_pay_core_frontend/role/domain/usecases/create_role_use_case.dart';
import 'package:viggo_pay_core_frontend/role/domain/usecases/get_roles_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/role/domain/usecases/update_role_use_case.dart';

class EditRolesViewModel extends BaseViewModel {
  final GetRolesByParamsUseCase getRoles;
  final UpdateRoleUseCase updateRole;
  final CreateRoleUseCase createRole;

  final EditRoleFormFields form = EditRoleFormFields();

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  EditRolesViewModel({
    required this.getRoles,
    required this.updateRole,
    required this.createRole,
  });

  void submit(
    String? id,
    Function showMsg,
    BuildContext context,
  ) async {
    if(isLoading) return;
    setLoading();

    dynamic result;
    var formFields = form.getFields();

    Map<String, dynamic> data = {
      'name': formFields!['name'],
      'data_view': formFields['multiDomain'],
    };
    
    if (id != null) {
      data.addEntries(
        <String, dynamic>{'id': id}.entries,
      );
      result = await updateRole.invoke(id: id, body: data);
    } else {
      result = await createRole.invoke(data);
    }
    setLoading();
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamControllerSuccess.isClosed) {
        _streamControllerSuccess.sink.add(true);
      }
    }
  }
}
