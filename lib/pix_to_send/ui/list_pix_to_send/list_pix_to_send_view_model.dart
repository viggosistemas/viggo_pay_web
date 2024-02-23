import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/get_pix_to_send_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/ui/list_domain_form_fields.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';

class ListPixToSendViewModel extends ChangeNotifier {
  final GetPixToSendsByParamsUseCase getPixToSends;
  final UpdateSelectedItemUsecase updateSelected;
  final GetSelectedItemsUseCase getSelectedItems;
  final ClearSelectedItemsUseCase clearSelectedItems;

  final ListDomainFormFields form = ListDomainFormFields();
  List<PixToSendApiDto> selectedItemsList = [];

  ListPixToSendViewModel({
    required this.getPixToSends,
    required this.updateSelected,
    required this.getSelectedItems,
    required this.clearSelectedItems,
  });

  final StreamController<List<PixToSendApiDto>> pixController =
      StreamController.broadcast();
  Stream<List<PixToSendApiDto>> get pixToSends => pixController.stream;

  final StreamController<String> errorController = StreamController.broadcast();
  Stream<String> get error => errorController.stream;

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

  fromJson(Map<String, dynamic> entity) {
    return PixToSendApiDto.fromJson(entity);
  }

  Future<void> loadData(Map<String, String> filters) async {
    Map<String, String>? formFields = form.getFields();

    if (formFields != null) {
      for (var e in formFields.keys) {
        var value = formFields[e];
        value != null ? filters[e] = value : value;
      }
    }

    var result = await getPixToSends.invoke(filters: filters);
    if (result.isRight) {
      _updatePixList(result.right.pixToSends);
    } else if (result.isLeft && !errorController.isClosed) {
      errorController.sink.add(result.left.message);
    }
  }

  void checkItem(String id) {
    updateSelected.invoke(id);
    _updatePixList(_items);
  }
}
