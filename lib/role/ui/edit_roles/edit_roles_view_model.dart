import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/role/ui/edit_roles/edit_roles_form/edit_form_fields.dart';
import 'package:viggo_pay_core_frontend/role/domain/usecases/create_role_use_case.dart';
import 'package:viggo_pay_core_frontend/role/domain/usecases/get_roles_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/role/domain/usecases/update_role_use_case.dart';

class EditRolesViewModel extends ChangeNotifier {
  bool isLoading = false;

  final GetRolesByParamsUseCase getRoles;
  final UpdateRoleUseCase updateRole;
  final CreateRoleUseCase createRole;

  final EditRoleFormFields form = EditRoleFormFields();

  final StreamController<String> _streamControllerError =
      StreamController<String>.broadcast();
  Stream<String> get isError => _streamControllerError.stream;

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  EditRolesViewModel({
    required this.getRoles,
    required this.updateRole,
    required this.createRole,
  });

  void notifyLoading() {
    isLoading = !isLoading;
    // notifyListeners();
  }

  void submit(
    String? id,
    Function showMsg,
    BuildContext context,
  ) async {
    notifyLoading();
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
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamControllerSuccess.isClosed) {
        _streamControllerSuccess.sink.add(true);
        notifyLoading();
      }
    }
  }
}
