import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final SharedPreferences sharedPrefs;
  final GetCapabilitiesByParamsUseCase getCapabilities;
  final AddCapabilityUseCase addCapabilities;
  final RemoveCapabilityUseCase removeCapabilities;
  final UpdateSelectedItemUsecase updateSelected;
  final GetSelectedItemsUseCase getSelectedItems;
  final ClearSelectedItemsUseCase clearSelectedItems;
  final GetRoutesByParamsUseCase getRoutes;

  List<CapabilityApiDto> selectedItemsList = [];
  List<RouteApiDto> selectedRoutesList = [];

  final ListDomainFormFields form = ListDomainFormFields();
  List<CapabilityApiDto> _items = List.empty(growable: true);

  List<RouteApiDto> mockSelectedList = List.empty(growable: true);

  final StreamController<List<CapabilityApiDto>> capabilitiesController = StreamController.broadcast();
  Stream<List<CapabilityApiDto>> get capabilities => capabilitiesController.stream;

  final StreamController<List<RouteApiDto>> routesSelectedController = StreamController.broadcast();
  Stream<List<RouteApiDto>> get routesSelected => routesSelectedController.stream;

  final StreamController<bool> _streamControllerSuccess = StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  final StreamController<List<RouteApiDto>> routesController = StreamController.broadcast();
  Stream<List<RouteApiDto>> get routesSistema => routesController.stream;

  final BehaviorSubject<List<RouteApiDto>> capabilitiesSelectedController = BehaviorSubject<List<RouteApiDto>>();
  Stream<List<RouteApiDto>> get capabilitiesSelected => capabilitiesSelectedController.stream;
  Stream<bool> get capabilitiesSelectedValid => capabilitiesSelectedController.stream.transform(validar());

  EditCapabilityViewModel({
    required this.sharedPrefs,
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

    var listOptions = ListOptions.values.where((element) => element.name == filters['list_options']).first;

    var result = await getCapabilities.invoke(filters: filters, listOptions: listOptions, include: 'route');

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
      mockSelectedList = result.right.routes;
      clearRouteSelected();
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

  //Adicona ou remove da lista de politicas disponiveis como selecionadas
  addOrRemove(dynamic value) {
    value = RouteApiDto.fromJson(value);
    var list = capabilitiesSelectedController.valueOrNull ?? [];
    if (list.isNotEmpty) {
      var index = list.indexWhere((element) => element.id == value.id);
      if (index == -1) {
        list.add(value);
      } else {
        list.removeWhere((element) => element.id == list[index].id);
      }
    } else {
      list.add(value);
    }
    capabilitiesSelectedController.sink.add(list);
  }

  void clearRouteSelected() {
    mockSelectedList = mockSelectedList.map((e) {
      e.selected = false;
      return e;
    }).toList();
    sharedPrefs.setStringList('ROUTES_SELECTED', List.empty(growable: true));
  }

  void checkRouteSelected(String id) {
    updateSelectedRoute(id);
    _updateRouteList(mockSelectedList);
  }

  List<RouteApiDto> _mapSelectedRoutes(
    List<RouteApiDto> routes,
    List<String> selected,
  ) =>
      routes..forEach((e) => e.selected = selected.contains(e.id));

  void _updateRouteList(List<RouteApiDto> routes) {
    if (!routesSelectedController.isClosed) {
      mockSelectedList = routes;
      selectedRoutesList = _mapSelectedRoutes(routes, getSelectedRoutes());
      routesSelectedController.sink.add(selectedRoutesList);
    }
  }

  List<String> getSelectedRoutes() {
    List<String>? selected = sharedPrefs.getStringList('ROUTES_SELECTED');
    return selected ?? List.empty();
  }

  void updateSelectedRoute(String item) {
    List<String>? selected = sharedPrefs.getStringList('ROUTES_SELECTED') ?? List.empty(growable: true);
    if (selected.contains(item)) {
      selected.remove(item);
    } else {
      selected.add(item);
    }
    sharedPrefs.setStringList('ROUTES_SELECTED', selected);

    // if (!_selectedItemsStreamController.isClosed) {
    //   _selectedItemsStreamController.sink.add(selected);
    // }
  }

  StreamTransformer<List<RouteApiDto>, bool> validar() {
    return StreamTransformer<List<RouteApiDto>, bool>.fromHandlers(
      handleData: (value, sink) {
        sink.add(value.isNotEmpty);
      },
    );
  }
}
