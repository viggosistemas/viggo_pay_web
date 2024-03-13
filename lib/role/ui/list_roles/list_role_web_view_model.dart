import 'dart:async';

import 'package:viggo_pay_admin/role/domain/usecases/change_active_role_use_case.dart';
import 'package:viggo_pay_core_frontend/base/base_view_model.dart';
import 'package:viggo_pay_core_frontend/domain/ui/list_domain_form_fields.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_pay_core_frontend/role/data/models/role_api_dto.dart';
import 'package:viggo_pay_core_frontend/role/domain/usecases/get_role_by_id_use_case.dart';
import 'package:viggo_pay_core_frontend/role/domain/usecases/get_roles_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class ListRoleWebViewModel extends BaseViewModel {
  final GetRoleByIdUseCase getRole;
  final GetRolesByParamsUseCase getRoles;
  final UpdateSelectedItemUsecase updateSelected;
  final GetSelectedItemsUseCase getSelectedItems;
  final ClearSelectedItemsUseCase clearSelectedItems;
  final ChangeActiveRoleUseCase changeActive;

  final ListDomainFormFields form = ListDomainFormFields();

  List<RoleApiDto> selectedItemsList = [];

  ListRoleWebViewModel({
    required this.getRole,
    required this.changeActive,
    required this.getRoles,
    required this.updateSelected,
    required this.clearSelectedItems,
    required this.getSelectedItems,
  });

  final StreamController<List<RoleApiDto>> rolesController =
      StreamController.broadcast();
  Stream<List<RoleApiDto>> get roles => rolesController.stream;

  List<RoleApiDto> _items = List.empty(growable: true);

  List<RoleApiDto> _mapSelected(
    List<RoleApiDto> roles,
    List<String> selected,
  ) =>
      roles..forEach((e) => e.selected = selected.contains(e.id));

  void _updateRolesList(List<RoleApiDto> items) {
    if (!rolesController.isClosed) {
      _items = items;
      selectedItemsList = _mapSelected(items, getSelectedItems.invoke());
      rolesController.sink.add(selectedItemsList);
    }
  }

  Future<void> loadData(Map<String, String> filters) async {
    if (isLoading) return;

    setLoading();
    Map<String, String>? formFields = form.getFields();

    if (formFields != null) {
      for (var e in formFields.keys) {
        var value = formFields[e];
        value != null ? filters[e] = value : value;
      }
    }

    var listOptions = ListOptions.values
        .where((element) => element.name == filters['list_options'])
        .first;

    var result = await getRoles.invoke(
      filters: filters,
      listOptions: listOptions,
    );

    setLoading();
    if (result.isRight) {
      _updateRolesList(result.right.roles);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  void checkItem(String id) {
    updateSelected.invoke(id);
    _updateRolesList(_items);
  }

  Future<RoleApiDto?> catchEntity(String id) async {
    if (isLoading) return null;

    setLoading();
    var result = await getRole.invoke(id: id);
    setLoading();
    if (result.isRight) {
      return result.right;
    } else if (result.isLeft) {
      postError(result.left.message);
    }
    return null;
  }
}
