import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_accounts_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/ui/list_domain_form_fields.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';

class ListDomainAccountViewModel extends ChangeNotifier {
  final GetDomainAccountsByParamsUseCase getDomainAccounts;
  final UpdateSelectedItemUsecase updateSelected;
  final GetSelectedItemsUseCase getSelectedItems;

  final ListDomainFormFields form = ListDomainFormFields();

  ListDomainAccountViewModel({
    required this.getDomainAccounts,
    required this.updateSelected,
    required this.getSelectedItems,
  });

  final StreamController<List<DomainAccountApiDto>> domainsController =
      StreamController.broadcast();
  Stream<List<DomainAccountApiDto>> get domainAccounts => domainsController.stream;

  final StreamController<String> errorController = StreamController.broadcast();
  Stream<String> get error => errorController.stream;

  List<DomainAccountApiDto> _items = List.empty(growable: true);

  List<DomainAccountApiDto> _mapSelected(
    List<DomainAccountApiDto> domainAccounts,
    List<String> selected,
  ) =>
      domainAccounts..forEach((e) => e.selected = selected.contains(e.id));

  void _updateDomainsList(List<DomainAccountApiDto> items) {
    if (!domainsController.isClosed) {
      _items = items;
      domainsController.sink
          .add(_mapSelected(items, getSelectedItems.invoke()));
    }
  }

  Future<void> loadData() async {
    Map<String, String> filters = {'order_by': 'client_name'};
    Map<String, String>? formFields = form.getFields();

    if (formFields != null) {
      for (var e in formFields.keys) {
        var value = formFields[e];
        value != null ? filters[e] = value : value;
      }
    }

    var result = await getDomainAccounts.invoke(filters: filters);
    if (result.isRight) {
      _updateDomainsList(result.right.domainAccounts);
    } else if (result.isLeft && !errorController.isClosed) {
      errorController.sink.add(result.left.message);
    }
  }

  void checkItem(String id) {
    updateSelected.invoke(id);
    _updateDomainsList(_items);
  }
}
