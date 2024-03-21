import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/capability/data/models/capability_api_dto.dart';
import 'package:viggo_core_frontend/capability/domain/usecases/get_capabilities_by_params_use_case.dart';
import 'package:viggo_core_frontend/domain/ui/list_domain_form_fields.dart';
import 'package:viggo_core_frontend/policies/data/models/policy_api_dto.dart';
import 'package:viggo_core_frontend/policies/domain/usecases/add_policy_use_case.dart';
import 'package:viggo_core_frontend/policies/domain/usecases/remove_policy_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_core_frontend/role/data/models/role_api_dto.dart';
import 'package:viggo_core_frontend/role/domain/usecases/get_roles_by_params_use_case.dart';
import 'package:viggo_core_frontend/util/list_options.dart';

class EditPolicyViewModel extends BaseViewModel {
  final GetCapabilitiesByParamsUseCase getCapabilities;
  final AddPolicyUseCase addPolicies;
  final RemovePolicyUseCase removePolicies;
  final UpdateSelectedItemUsecase updateSelected;
  final GetSelectedItemsUseCase getSelectedItems;
  final ClearSelectedItemsUseCase clearSelectedItems;
  final GetRolesByParamsUseCase getRoles;

  List<PolicyApiDto> selectedItemsList = [];
  List<CapabilityApiDto> avaliableCapabilities = [];

  final ListDomainFormFields form = ListDomainFormFields();
  List<PolicyApiDto> _items = List.empty(growable: true);

  final StreamController<List<PolicyApiDto>> policiesController =
      StreamController.broadcast();
  Stream<List<PolicyApiDto>> get policies => policiesController.stream;

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  final StreamController<List<RoleApiDto>> rolesController =
      StreamController.broadcast();
  Stream<List<RoleApiDto>> get papeisSistema => rolesController.stream;

  EditPolicyViewModel({
    required this.getRoles,
    required this.addPolicies,
    required this.removePolicies,
    required this.getCapabilities,
    required this.updateSelected,
    required this.getSelectedItems,
    required this.clearSelectedItems,
  });

  List<PolicyApiDto> _mapSelected(
    List<PolicyApiDto> policies,
    List<String> selected,
  ) =>
      policies..forEach((e) => e.selected = selected.contains(e.id));

  void _updatePoliciesList(List<PolicyApiDto> items) {
    if (!policiesController.isClosed) {
      _items = items;
      selectedItemsList = _mapSelected(items, getSelectedItems.invoke());
      policiesController.sink.add(selectedItemsList);
    }
  }

  Future<void> loadData(
    Map<String, String> filters,
    RoleApiDto? role,
  ) async {
    if (isLoading) return;
    if (role == null) {
      _updatePoliciesList([]);
    } else {
      role.policies = [];
      setLoading();
      Map<String, String>? formFields = form.getValues();

      if (formFields != null) {
        for (var e in formFields.keys) {
          var value = formFields[e];
          value != null ? filters[e] = value : value;
        }
      }

      var listOptions = ListOptions.values
          .where((element) => element.name == filters['list_options'])
          .first;

      var result = await getCapabilities.invoke(
        filters: filters,
        listOptions: listOptions,
        include: 'policies,route',
      );

      setLoading();
      if (result.isRight) {
        List<CapabilityApiDto> allCapabilitites = [];
        for (var capability in result.right.capabilities) {
          allCapabilitites.add(capability);
          if (capability.policies.isNotEmpty) {
            for (var policy in capability.policies) {
              if (policy.roleId == role.id) {
                policy.capability = capability;
                role.policies!.add(policy);
              }
            }
          }
        }
        var idsRoutesSelecteds = role.policies!.map((p) => p.capability!.routeId).toList();
        for(var capability in allCapabilitites){
          var index = idsRoutesSelecteds.indexOf(capability.route!.id);
          if(!(index >= 0)){
            avaliableCapabilities.add(capability);
          }
        }
        _updatePoliciesList(role.policies!);
      } else if (result.isLeft) {
        postError(result.left.message);
      }
    }
  }

  void checkItem(String id) {
    updateSelected.invoke(id);
    _updatePoliciesList(_items);
  }

  Future<void> listRoles() async {
    if (isLoading) return;

    setLoading();

    var result = await getRoles.invoke(
      filters: {},
      listOptions: ListOptions.ACTIVE_ONLY,
    );

    setLoading();
    if (result.isRight) {
      rolesController.sink.add(result.right.roles);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  void onAddPolicies(
    Function showMsg,
    BuildContext context,
    List<CapabilityApiDto> selecionadas,
    String roleId,
  ) async {
    if (isLoading) return;
    setLoading();

    dynamic result;

    for (var capability in selecionadas) {
      result = await addPolicies.invoke(
        body: {
          'capability_id': capability.id,
          'role_id': roleId,
        },
      );
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

  void onRemovePolicies(
    Function showMsg,
    BuildContext context,
    List<PolicyApiDto> selecionadas,
  ) async {
    if (isLoading) return;
    setLoading();

    dynamic result;

    for (var policy in selecionadas) {
      result = await removePolicies.invoke(
        id: policy.id,
      );
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
