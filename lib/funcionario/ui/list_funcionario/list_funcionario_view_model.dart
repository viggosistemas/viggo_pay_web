import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/domain/usecases/change_active_funcionario_use_case.dart';
import 'package:viggo_pay_admin/funcionario/domain/usecases/get_funcionario_by_id_use_case.dart';
import 'package:viggo_pay_admin/funcionario/domain/usecases/get_funcionario_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_core_frontend/domain/ui/list_domain_form_fields.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_pay_core_frontend/util/constants.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class ListFuncionarioViewModel extends ChangeNotifier {
  final SharedPreferences sharedPrefs;

  final GetFuncionarioByIdUseCase getFuncionario;
  final GetFuncionarioByParamsUseCase getFuncionarios;
  final UpdateSelectedItemUsecase updateSelected;
  final ChangeActiveFuncionarioUseCase changeActive;
  final GetSelectedItemsUseCase getSelectedItems;
  final ClearSelectedItemsUseCase clearSelectedItems;

  final ListDomainFormFields form = ListDomainFormFields();
  List<FuncionarioApiDto> selectedItemsList = [];

  ListFuncionarioViewModel({
    required this.sharedPrefs,
    required this.getFuncionario,
    required this.changeActive,
    required this.getFuncionarios,
    required this.updateSelected,
    required this.getSelectedItems,
    required this.clearSelectedItems,
  });

  final StreamController<List<FuncionarioApiDto>> funcionarioController =
      StreamController.broadcast();
  Stream<List<FuncionarioApiDto>> get funcionarios =>
      funcionarioController.stream;

  final StreamController<String> errorController = StreamController.broadcast();
  Stream<String> get error => errorController.stream;

  List<FuncionarioApiDto> _items = List.empty(growable: true);

  List<FuncionarioApiDto> _mapSelected(
    List<FuncionarioApiDto> funcionarios,
    List<String> selected,
  ) =>
      funcionarios..forEach((e) => e.selected = selected.contains(e.id));

  void _updateFuncionarioList(List<FuncionarioApiDto> items) {
    if (!funcionarioController.isClosed) {
      _items = items;
      selectedItemsList = _mapSelected(items, getSelectedItems.invoke());
      funcionarioController.sink.add(selectedItemsList);
    }
  }

  Future<void> loadData(Map<String, String> filters) async {
    String? domainJson = sharedPrefs.getString(CoreUserPreferences.DOMAIN);
    DomainApiDto domain = DomainApiDto.fromJson(jsonDecode(domainJson!));
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

    filters.addEntries(
      <String, String>{'domain_id': domain.id}.entries,
    );

    var result = await getFuncionarios.invoke(
        filters: filters,
        listOptions: listOptions,
        include: 'parceiro,user');
    if (result.isRight) {
      _updateFuncionarioList(result.right.funcionarios);
    } else if (result.isLeft && !errorController.isClosed) {
      errorController.sink.add(result.left.message);
    }
  }

  void checkItem(String id) {
    updateSelected.invoke(id);
    _updateFuncionarioList(_items);
  }

  Future<FuncionarioApiDto?> catchEntity(String id) async {
    var result = await getFuncionario.invoke(
      id: id,
      include: 'parceiro.enderecos.municipio,parceiro.contatos,user',
    );

    if (result.isRight) {
      return result.right;
    } else if (result.isLeft && !errorController.isClosed) {
      errorController.sink.add(result.left.message);
    }
    return null;
  }
}
