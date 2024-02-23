import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_config_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_accounts_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/ui/list_domain_form_fields.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';

class ListDomainAccountViewModel extends ChangeNotifier {
  final GetDomainAccountsByParamsUseCase getDomainAccounts;
  final GetDomainAccountConfigByIdUseCase getConfigDomainAccount;
  final UpdateSelectedItemUsecase updateSelected;
  final GetSelectedItemsUseCase getSelectedItems;
  final ClearSelectedItemsUseCase clearSelectedItems;

  final ListDomainFormFields form = ListDomainFormFields();

  List<DomainAccountApiDto> selectedItemsList = [];

  ListDomainAccountViewModel({
    required this.getDomainAccounts,
    required this.getConfigDomainAccount,
    required this.updateSelected,
    required this.clearSelectedItems,
    required this.getSelectedItems,
  });

  final StreamController<List<DomainAccountApiDto>> domainsController =
      StreamController.broadcast();
  Stream<List<DomainAccountApiDto>> get domainAccounts =>
      domainsController.stream;

  final StreamController<DomainAccountConfigApiDto?> configDomainController =
      StreamController.broadcast();
  Stream<DomainAccountConfigApiDto?> get configDomainAccount =>
      configDomainController.stream;

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
      selectedItemsList = _mapSelected(items, getSelectedItems.invoke());
      domainsController.sink.add(selectedItemsList);
    }
  }

  fromJson(Map<String, dynamic> entity) {
    return DomainAccountApiDto.fromJson(entity);
  }

  Future<void> loadData(Map<String, String> filters) async {
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

  Future<void> getConfigInfo(String id) async {
    Map<String, String> filters = {'domain_account_id': id};
    var result = await getConfigDomainAccount.invoke(filters: filters);
    if (result.isRight && result.right.domainAccountTaxas.isNotEmpty) {
      configDomainController.sink.add(result.right.domainAccountTaxas[0]);
    } else if (result.isLeft && !errorController.isClosed) {
      errorController.sink.add(result.left.message);
    }
  }

  getEmptyConfigInfo(String id) {
    var config = {
      'id': '',
      'domain_account_id': id,
      'taxa': 0,
      'porcentagem': false,
    };

    return DomainAccountConfigApiDto.fromJson(config);
  }

  clearSelectionConfig() {
    configDomainController.sink.add(null);
  }

  void checkItem(String id) {
    updateSelected.invoke(id);
    _updateDomainsList(_items);
  }
}
