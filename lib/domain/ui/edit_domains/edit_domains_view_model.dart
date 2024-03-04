import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/domain/ui/edit_domains/edit_domains_form/edit_form_fields.dart';
import 'package:viggo_pay_admin/domain/ui/edit_domains/edit_domains_form/register_form_fields.dart';
import 'package:viggo_pay_core_frontend/application/data/models/application_api_dto.dart';
import 'package:viggo_pay_core_frontend/application/domain/usecases/get_applications_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domains_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/register_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/update_domain_use_case.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class EditDomainsViewModel extends ChangeNotifier {
  bool isLoading = false;
  late DomainApiDto matriz;

  final GetDomainsByParamsUseCase getDomains;
  final UpdateDomainUseCase updateDomain;
  final RegisterUseCase registerDomain;
  final GetApplicationsByParamsUseCase getApplications;

  final EditDomainFormFields form = EditDomainFormFields();
  final RegisterFormFields formRegister = RegisterFormFields();

  final StreamController<String> _streamControllerError =
      StreamController<String>.broadcast();
  Stream<String> get isError => _streamControllerError.stream;

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  final StreamController<List<ApplicationApiDto>>
      _streamControllerApplications =
      StreamController<List<ApplicationApiDto>>.broadcast();
  Stream<List<ApplicationApiDto>> get listApplications =>
      _streamControllerApplications.stream;

  EditDomainsViewModel({
    required this.getDomains,
    required this.updateDomain,
    required this.registerDomain,
    required this.getApplications,
  }){
    getMatriz().then(
      (value) {
        matriz = value!;
      }
    );
  }

  void notifyLoading() {
    isLoading = !isLoading;
    // notifyListeners();
  }

  Future<void> loadApplications(Map<String, String> filters) async {
    // Map<String, String>? formFields = form.getFields();

    // if (formFields != null) {
    //   for (var e in formFields.keys) {
    //     var value = formFields[e];
    //     value != null ? filters[e] = value : value;
    //   }
    // }

    var listOptions = ListOptions.values
        .where((element) => element.name == filters['list_options'])
        .first;

    var result = await getApplications.invoke(
      filters: filters,
      listOptions: listOptions,
    );
    if (result.isRight) {
      _streamControllerApplications.sink.add(result.right.applications);
    } else if (result.isLeft && !_streamControllerError.isClosed) {
      _streamControllerError.sink.add(result.left.message);
    }
  }

  Future<DomainApiDto?> getMatriz() async {
    var result = await getDomains.invoke(
      filters: {
        'tag': '%MATRIZ%',
        'page': '0',
        'page_size': '1',
        'require_pagination': 'true'
      },
      listOptions: ListOptions.ACTIVE_ONLY,
      include: 'application',
    );
    if (result.isRight) {
      return result.right.domains[0];
    }
    return null;
  }

  void submit(
    String? id,
    Function showMsg,
    BuildContext context,
  ) async {
    notifyLoading();
    dynamic result;
    var formFields = form.getFields();
    var formRegisterFields = formRegister.getFields();

    Map<String, dynamic> data = {
      'id': id,
      'name': formFields!['name'],
      'display_name': formFields['display_name'],
      'description': formFields['description'],
      'application_id': formFields['application_id'],
    };

    Map<String, String> dataRegister = {
      'domain_name': formRegisterFields!['name'].toString(),
      'domain_display_name': formRegisterFields['display_name'].toString(),
      'email': formRegisterFields['email'].toString(),
      'password': formRegisterFields['password'].toString(),
      'parent_id': matriz.id,
    };
    
    if (id != null) {
      result = await updateDomain.invoke(id: id, body: data);
    } else {
      result = await registerDomain.invoke(dataRegister);
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
