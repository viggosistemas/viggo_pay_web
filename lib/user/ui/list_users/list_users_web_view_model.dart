import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_user_by_id_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_users_by_params_use_case.dart';
import 'package:viggo_core_frontend/util/constants.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/user/domain/usecases/change_active_user_use_case.dart';
import 'package:viggo_pay_admin/user/ui/list_users/list_users_form_field.dart';

class ListUserWebViewModel extends BaseViewModel {
  final SharedPreferences sharedPrefs;

  final GetUserByIdUseCase getUser;
  final GetUsersByParamsUseCase getUsers;
  final UpdateSelectedItemUsecase updateSelected;
  final GetSelectedItemsUseCase getSelectedItems;
  final ClearSelectedItemsUseCase clearSelectedItems;
  final ChangeActiveUserUseCase changeActive;

  final ListUsersFormField form = ListUsersFormField();

  List<UserApiDto> selectedItemsList = [];

  ListUserWebViewModel({
    required this.sharedPrefs,
    required this.getUser,
    required this.changeActive,
    required this.getUsers,
    required this.updateSelected,
    required this.clearSelectedItems,
    required this.getSelectedItems,
  });

  final StreamController<List<UserApiDto>> usersController =
      StreamController.broadcast();
  Stream<List<UserApiDto>> get users => usersController.stream;

  List<UserApiDto> _items = List.empty(growable: true);

  List<UserApiDto> _mapSelected(
    List<UserApiDto> users,
    List<String> selected,
  ) =>
      users..forEach((e) => e.selected = selected.contains(e.id));

  void _updateUsersList(List<UserApiDto> items) {
    if (!usersController.isClosed) {
      _items = items;
      selectedItemsList = _mapSelected(items, getSelectedItems.invoke());
      usersController.sink.add(selectedItemsList);
    }
  }

  fromJson(Map<String, dynamic> entity) {
    return UserApiDto.fromJson(entity);
  }

  Future<void> loadData(Map<String, String> filters) async {
    if (isLoading) return;

    setLoading();

    // Map<String, String>? formFields = form.getValues();

    // if (formFields != null) {
    //   for (var e in formFields.keys) {
    //     var value = formFields[e];
    //     value != null ? filters[e] = value : value;
    //   }
    // }
    String? domainJson = sharedPrefs.getString(CoreUserPreferences.DOMAIN);
    DomainApiDto domain = DomainApiDto.fromJson(jsonDecode(domainJson!));

    var listOptions = ListOptions.values
        .where((element) => element.name == filters['list_options'])
        .first;
    var keyDomain = filters.containsKey('domain_id');

    if (!keyDomain) {
      filters.addEntries(
        <String, String>{'domain_id': domain.id}.entries,
      );
    }

    var result = await getUsers.invoke(
        filters: filters, listOptions: listOptions, include: 'domain');
    setLoading();

    if (result.isRight) {
      _updateUsersList(result.right.users);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  void checkItem(String id) {
    updateSelected.invoke(id);
    _updateUsersList(_items);
  }

  Future<UserApiDto?> catchEntity(String id) async {
    if (isLoading) return null;

    setLoading();

    var result = await getUser.invoke(id: id, include: 'domain');

    setLoading();
    if (result.isRight) {
      return result.right;
    } else if (result.isLeft) {
      postError(result.left.message);
    }
    return null;
  }
}
