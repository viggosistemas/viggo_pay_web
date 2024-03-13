import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_pay_admin/user/ui/edit_users/edit_users_form/edit_form_fields.dart';
import 'package:viggo_pay_core_frontend/application/domain/usecases/get_roles_from_application_by_id_use_case.dart';
import 'package:viggo_pay_core_frontend/base/base_view_model.dart';
import 'package:viggo_pay_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domains_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/grant/data/models/grant_api_dto.dart';
import 'package:viggo_pay_core_frontend/grant/domain/usecases/add_grant_use_case.dart';
import 'package:viggo_pay_core_frontend/grant/domain/usecases/delete_grant_use_case.dart';
import 'package:viggo_pay_core_frontend/grant/domain/usecases/get_grants_from_user_by_id_use_case.dart';
import 'package:viggo_pay_core_frontend/role/data/models/role_api_dto.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/create_user_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/update_user_use_case.dart';
import 'package:viggo_pay_core_frontend/util/constants.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class EditUsersViewModel extends BaseViewModel {
  List<GrantApiDto> grants = [];
  List<RoleApiDto> roles = [];

  final SharedPreferences sharedPrefs;
  final UpdateUserUseCase updateUser;
  final CreateUserUseCase createUser;
  final GetDomainsByParamsUseCase getDomains;
  final GetRolesFromApplicationIdUseCase getRolesApplication;
  final GetGrantsFromUserIdUseCase getGrantsUser;
  final DeleteGrantUseCase deleteGranUser;
  final AddGrantUseCase addGrantUser;

  final EditUsersFormField form = EditUsersFormField();

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  final StreamController<List<DomainApiDto>> _streamControllerDomains =
      StreamController<List<DomainApiDto>>.broadcast();
  Stream<List<DomainApiDto>> get listDomains => _streamControllerDomains.stream;

  final StreamController<List<RoleApiDto>> _streamControllerApplicationRoles =
      StreamController<List<RoleApiDto>>.broadcast();
  Stream<List<RoleApiDto>> get listRolesApplication =>
      _streamControllerApplicationRoles.stream;

  EditUsersViewModel({
    required this.sharedPrefs,
    required this.updateUser,
    required this.createUser,
    required this.getDomains,
    required this.getGrantsUser,
    required this.getRolesApplication,
    required this.addGrantUser,
    required this.deleteGranUser,
  });

  Future<void> loadDomains(Map<String, String> filters) async {
    if (isLoading) return;

    setLoading();
    var listOptions = ListOptions.values
        .where((element) => element.name == filters['list_options'])
        .first;

    var result = await getDomains.invoke(
      filters: filters,
      listOptions: listOptions,
    );
    setLoading();
    if (result.isRight) {
      _streamControllerDomains.sink.add(result.right.domains);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  Future<void> loadRolesApplication() async {
    String? domainJson = sharedPrefs.getString(CoreUserPreferences.DOMAIN);
    DomainApiDto domain = DomainApiDto.fromJson(jsonDecode(domainJson!));

    var result = await getRolesApplication.invoke(id: domain.applicationId);
    if (result.isRight) {
      for (var gr in grants) {
        var index =
            result.right.indexWhere((element) => element.id == gr.roleId);
        if (index >= 0) {
          result.right[index].selected = true;
        }
      }
      roles = result.right;
      _streamControllerApplicationRoles.sink.add(result.right);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  Future<void> loadGrantsUser(String userId) async {
    var result = await getGrantsUser.invoke(
      id: userId,
      include: 'role',
    );
    if (result.isRight) {
      grants = result.right;
      loadRolesApplication();
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  getGrantsRoles(String userId) {
    var rolesToAdd = roles.where((role) => role.selected).toList();
    var rolesToRemove = roles.where((role) => !role.selected).toList();

    var idsRolesToAdd = rolesToAdd.map((role) => role.id).toList();
    var idsRolesToRemove = rolesToRemove.map((role) => role.id).toList();

    var removeRoles = grants.where((grant) {
      return (grant.role?.name.toLowerCase() != 'user' &&
          idsRolesToRemove.contains(grant.roleId));
    }).toList();

    var idsGrantsToRemove = removeRoles.map((e) => e.id).toList();

    var addRoles = idsRolesToAdd
        .map((roleId) => {
              'role_id': roleId,
              'user_id': userId,
            })
        .toList();

    if (addRoles.isNotEmpty) {
      insertRolesToUserGrant(addRoles);
    }
    if (idsGrantsToRemove.isNotEmpty) {
      removeRolesFromUserGrant(idsGrantsToRemove);
    }
  }

  Future<void> insertRolesToUserGrant(List<Map<String, dynamic>> grants) async {
    var count = 0;
    for (var grant in grants) {
      await addGrantUser.invoke(body: grant);
      count++;
    }
    _streamControllerSuccess.sink.add(count == grants.length);
  }

  Future<void> removeRolesFromUserGrant(List<String> grants) async {
    var count = 0;
    for (var id in grants) {
      await deleteGranUser.invoke(id: id);
      count++;
    }
    _streamControllerSuccess.sink.add(count == grants.length);
  }

  void submit(
    String? id,
    Function showMsg,
    BuildContext context,
  ) async {
    if (isLoading) return;

    setLoading();
    var formFields = form.getFields();
    dynamic result;

    Map<String, dynamic> data = id != null && id.isNotEmpty
        ? {
            'id': id,
            'name': formFields!['name'],
            'email': formFields['email'],
            'domain_id': formFields['domain_id'],
          }
        : {
            'name': formFields!['name'],
            'email': formFields['email'],
            'domain_id': formFields['domain_id'],
            'natureza': 'MOBILE'
          };

    if (id != null && id.isNotEmpty) {
      result = await updateUser.invoke(
        id: id,
        body: data,
      );
    } else {
      result = await createUser.invoke(body: data);
    }
    setLoading();
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamControllerSuccess.isClosed) {
        getGrantsRoles(result.value.id);
      }
    }
  }
}
