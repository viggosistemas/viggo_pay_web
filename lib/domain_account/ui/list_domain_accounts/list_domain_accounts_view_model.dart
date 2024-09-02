import 'dart:async';

import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_core_frontend/domain/ui/list_domain_form_fields.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/change_active_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_config_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_accounts_by_params_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/resetar_tentativas_matera_use_case.dart';

class ListDomainAccountViewModel extends BaseViewModel {
  final GetDomainAccountByIdUseCase getDomainAccount;
  final GetDomainAccountsByParamsUseCase getDomainAccounts;
  final GetDomainAccountConfigByIdUseCase getConfigDomainAccount;
  final UpdateSelectedItemUsecase updateSelected;
  final GetSelectedItemsUseCase getSelectedItems;
  final ClearSelectedItemsUseCase clearSelectedItems;
  final ChangeActiveDomainAccountUseCase changeActive;
  final ResetarTentativasMateraUseCase resetarTentativas;
  final GetDomainFromSettingsUseCase getDomainFromSettingsUseCase;

  final ListDomainFormFields form = ListDomainFormFields();

  List<DomainAccountApiDto> selectedItemsList = [];

  ListDomainAccountViewModel({
    required this.getDomainAccount,
    required this.changeActive,
    required this.getDomainAccounts,
    required this.getConfigDomainAccount,
    required this.updateSelected,
    required this.clearSelectedItems,
    required this.getSelectedItems,
    required this.resetarTentativas,
    required this.getDomainFromSettingsUseCase,
  });

  final StreamController<List<DomainAccountApiDto>> domainsController = StreamController.broadcast();
  Stream<List<DomainAccountApiDto>> get domainAccounts => domainsController.stream;

  final StreamController<DomainAccountConfigApiDto?> configDomainController = StreamController.broadcast();
  Stream<DomainAccountConfigApiDto?> get configDomainAccount => configDomainController.stream;

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
    if (isLoading) return;

    setLoading();
    Map<String, String>? formFields = form.getValues();

    if (formFields != null) {
      for (var e in formFields.keys) {
        var value = formFields[e];
        value != null ? filters[e] = value : value;
      }
    }
    filters['domain.parent_id'] = DomainApiDto.fromJson(getDomainFromSettingsUseCase.invoke()!.toJson()).id;

    var result = await getDomainAccounts.invoke(filters: filters);
    setLoading();
    if (result.isRight) {
      _updateDomainsList(result.right.domainAccounts);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  Future<DomainAccountConfigApiDto?> getConfigInfo(String id) async {
    if (isLoading) return null;

    setLoading();
    Map<String, String> filters = {'domain_account_id': id};
    var result = await getConfigDomainAccount.invoke(filters: filters);

    setLoading();
    if (result.isRight && result.right.domainAccountTaxas.isNotEmpty) {
      configDomainController.sink.add(result.right.domainAccountTaxas[0]);
      return result.right.domainAccountTaxas[0];
    } else if (result.isLeft) {
      postError(result.left.message);
      return null;
    }
    return null;
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

  Future<DomainAccountApiDto?> catchEntity(String id) async {
    if (isLoading) return null;

    setLoading();
    var result = await getDomainAccount.invoke(id: id);

    setLoading();
    if (result.isRight) {
      return result.right;
    } else if (result.isLeft) {
      postError(result.left.message);
    }
    return null;
  }

  Future<bool?> resetarTentativasMatera(String id) async {
    if (isLoading) return null;

    setLoading();
    var result = await resetarTentativas.invoke(id: id, body: {});

    setLoading();
    if (result.isRight) {
      return true;
    } else if (result.isLeft) {
      postError(result.left.message);
    }
    return false;
  }
}
