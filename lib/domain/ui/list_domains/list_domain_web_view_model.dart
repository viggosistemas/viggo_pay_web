import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/domain/domain/usecases/change_active_domain_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domain_by_id_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domains_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/ui/list_domain_form_fields.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class ListDomainWebViewModel extends ChangeNotifier {
  final GetDomainByIdUseCase getDomain;
  final GetDomainsByParamsUseCase getDomains;
  final UpdateSelectedItemUsecase updateSelected;
  final GetSelectedItemsUseCase getSelectedItems;
  final ClearSelectedItemsUseCase clearSelectedItems;
  final ChangeActiveDomainUseCase changeActive;
  bool isLoading = false;

  final ListDomainFormFields form = ListDomainFormFields();

  List<DomainApiDto> selectedItemsList = [];

  ListDomainWebViewModel({
    required this.getDomain,
    required this.changeActive,
    required this.getDomains,
    required this.updateSelected,
    required this.clearSelectedItems,
    required this.getSelectedItems,
  });

  final StreamController<List<DomainApiDto>> domainsController =
      StreamController.broadcast();
  Stream<List<DomainApiDto>> get domains => domainsController.stream;

  final StreamController<String> errorController = StreamController.broadcast();
  Stream<String> get error => errorController.stream;

  List<DomainApiDto> _items = List.empty(growable: true);

  List<DomainApiDto> _mapSelected(
    List<DomainApiDto> domains,
    List<String> selected,
  ) =>
      domains..forEach((e) => e.selected = selected.contains(e.id));

  void _updateDomainsList(List<DomainApiDto> items) {
    if (!domainsController.isClosed) {
      _items = items;
      selectedItemsList = _mapSelected(items, getSelectedItems.invoke());
      domainsController.sink.add(selectedItemsList);
    }
  }

  Future<void> loadData(Map<String, String> filters) async {
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

    var result = await getDomains.invoke(
      filters: filters,
      listOptions: listOptions,
      include: 'application',
    );
    if (result.isRight) {
      _updateDomainsList(result.right.domains);
    } else if (result.isLeft && !errorController.isClosed) {
      errorController.sink.add(result.left.message);
    }
  }

  void checkItem(String id) {
    updateSelected.invoke(id);
    _updateDomainsList(_items);
  }

  Future<DomainApiDto?> catchEntity(String id) async{
    var result = await getDomain.invoke(id: id, include: 'application');

    if (result.isRight) {
      return result.right;
    } else if (result.isLeft && !errorController.isClosed) {
      errorController.sink.add(result.left.message);
    }
    return null;
  }
}
