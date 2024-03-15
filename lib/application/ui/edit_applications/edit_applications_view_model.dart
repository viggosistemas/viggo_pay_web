import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/application/ui/edit_applications/edit_applications_form/edit_form_fields.dart';
import 'package:viggo_pay_core_frontend/application/domain/usecases/create_application_use_case.dart';
import 'package:viggo_pay_core_frontend/application/domain/usecases/get_applications_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/application/domain/usecases/update_application_use_case.dart';
import 'package:viggo_pay_core_frontend/base/base_view_model.dart';

class EditApplicationsViewModel extends BaseViewModel {
  final GetApplicationsByParamsUseCase getApplications;
  final UpdateApplicationUseCase updateApplication;
  final CreateApplicationUseCase createApplication;

  final EditApplicationFormFields form = EditApplicationFormFields();

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  EditApplicationsViewModel({
    required this.getApplications,
    required this.updateApplication,
    required this.createApplication,
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
      'description': formFields['description'],
    };
    
    if (id != null) {
      data.addEntries(
        <String, dynamic>{'id': id}.entries,
      );
      result = await updateApplication.invoke(id: id, body: data);
    } else {
      result = await createApplication.invoke(body: data);
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
