import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_core_frontend/domain/ui/list_domain_form_fields.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_core_frontend/util/constants.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/change_active_pix_to_send_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/get_pix_to_send_by_id_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/get_pix_to_send_by_params_use_case.dart';

class ListPixToSendViewModel extends BaseViewModel {
  final SharedPreferences sharedPrefs;

  final GetPixToSendByIdUseCase getPixToSend;
  final GetPixToSendsByParamsUseCase getPixToSends;
  final UpdateSelectedItemUsecase updateSelected;
  final ChangeActivePixToSendUseCase changeActive;
  final GetSelectedItemsUseCase getSelectedItems;
  final ClearSelectedItemsUseCase clearSelectedItems;

  final ListDomainFormFields form = ListDomainFormFields();
  List<PixToSendApiDto> selectedItemsList = [];

  ListPixToSendViewModel({
    required this.sharedPrefs,
    required this.getPixToSend,
    required this.changeActive,
    required this.getPixToSends,
    required this.updateSelected,
    required this.getSelectedItems,
    required this.clearSelectedItems,
  });

  final StreamController<List<PixToSendApiDto>> pixController =
      StreamController.broadcast();
  Stream<List<PixToSendApiDto>> get pixToSends => pixController.stream;

  List<PixToSendApiDto> _items = List.empty(growable: true);

  List<PixToSendApiDto> _mapSelected(
    List<PixToSendApiDto> pixToSends,
    List<String> selected,
  ) =>
      pixToSends..forEach((e) => e.selected = selected.contains(e.id));

  void _updatePixList(List<PixToSendApiDto> items) {
    if (!pixController.isClosed) {
      _items = items;
      selectedItemsList = _mapSelected(items, getSelectedItems.invoke());
      pixController.sink.add(selectedItemsList);
    }
  }

  Future<void> loadData(Map<String, String> filters) async {
    if (isLoading) return;
    setLoading();
    Map<String, String>? formFields = form.getValues();

    if (formFields != null) {
      for (var e in formFields.keys) {
        var value = formFields[e];
        value != null ? filters[e] = value : value;
      }
    }

    String? domainJson = sharedPrefs.getString(CoreUserPreferences.DOMAIN);
    DomainApiDto domain = DomainApiDto.fromJson(jsonDecode(domainJson!));

    filters.addEntries(
      <String, String>{'domain_account_id': domain.id}.entries,
    );

    var result = await getPixToSends.invoke(filters: filters);

    setLoading();
    if (result.isRight) {
      _updatePixList(result.right.pixToSends);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  void checkItem(String id) {
    updateSelected.invoke(id);
    _updatePixList(_items);
  }

  Future<PixToSendApiDto?> catchEntity(String id) async {
    if (isLoading) return null;
    setLoading();
    var result = await getPixToSend.invoke(id: id);

    setLoading();
    if (result.isRight) {
      return result.right;
    } else if (result.isLeft) {
      postError(result.left.message);
    }
    return null;
  }
}
