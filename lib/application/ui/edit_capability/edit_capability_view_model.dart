import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/capability/data/models/capability_api_dto.dart';
import 'package:viggo_core_frontend/capability/domain/usecases/add_capability_use_case.dart';
import 'package:viggo_core_frontend/capability/domain/usecases/get_capabilities_by_params_use_case.dart';
import 'package:viggo_core_frontend/capability/domain/usecases/remove_capability_use_case.dart';
import 'package:viggo_core_frontend/domain/ui/list_domain_form_fields.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_core_frontend/route/domain/usecases/get_routes_by_params_use_case.dart';
import 'package:viggo_core_frontend/util/list_options.dart';

class EditCapabilityViewModel extends BaseViewModel {
  final GetCapabilitiesByParamsUseCase getCapabilities;
  final AddCapabilityUseCase addCapabilities;
  final RemoveCapabilityUseCase removeCapabilities;
  final UpdateSelectedItemUsecase updateSelected;
  final GetSelectedItemsUseCase getSelectedItems;
  final ClearSelectedItemsUseCase clearSelectedItems;
  final GetRoutesByParamsUseCase getRoutes;

  List<CapabilityApiDto> selectedItemsList = [];

  final ListDomainFormFields form = ListDomainFormFields();
  List<CapabilityApiDto> _items = List.empty(growable: true);

  final StreamController<List<CapabilityApiDto>> capabilitiesController =
      StreamController.broadcast();
  Stream<List<CapabilityApiDto>> get capabilities =>
      capabilitiesController.stream;

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  final StreamController<List<RouteApiDto>> routesController =
      StreamController.broadcast();
  Stream<List<RouteApiDto>> get routesSistema => routesController.stream;

  EditCapabilityViewModel({
    required this.getCapabilities,
    required this.addCapabilities,
    required this.removeCapabilities,
    required this.updateSelected,
    required this.clearSelectedItems,
    required this.getSelectedItems,
    required this.getRoutes,
  });

  List<CapabilityApiDto> _mapSelected(
    List<CapabilityApiDto> capabilities,
    List<String> selected,
  ) =>
      capabilities..forEach((e) => e.selected = selected.contains(e.id));

  void _updateCapabilitiesList(List<CapabilityApiDto> items) {
    if (!capabilitiesController.isClosed) {
      _items = items;
      selectedItemsList = _mapSelected(items, getSelectedItems.invoke());
      capabilitiesController.sink.add(selectedItemsList);
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

    var listOptions = ListOptions.values
        .where((element) => element.name == filters['list_options'])
        .first;

    var result = await getCapabilities.invoke(
        filters: filters, listOptions: listOptions, include: 'route');

    setLoading();
    if (result.isRight) {
      _updateCapabilitiesList(result.right.capabilities);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  void checkItem(String id) {
    updateSelected.invoke(id);
    _updateCapabilitiesList(_items);
  }

  Future<void> listRoutes() async {
    if (isLoading) return;

    setLoading();

    var result = await getRoutes.invoke(
      filters: {},
      listOptions: ListOptions.ACTIVE_ONLY,
    );

    setLoading();
    if (result.isRight) {
      routesController.sink.add(result.right.routes);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  void onAddCapabilities(
    Function showMsg,
    BuildContext context,
    List<RouteApiDto> selecionadas,
    String applicationId,
  ) async {
    if (isLoading) return;
    setLoading();

    dynamic result;

    for (var rota in selecionadas) {
      result = await addCapabilities.invoke(
        body: {
          'route_id': rota.id,
          'application_id': applicationId,
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

  void onRemoveCapabilitites(
    Function showMsg,
    BuildContext context,
    List<CapabilityApiDto> selecionadas,
  ) async {
    if (isLoading) return;
    setLoading();

    dynamic result;

    for (var capability in selecionadas) {
      result = await removeCapabilities.invoke(
        id: capability.id,
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
