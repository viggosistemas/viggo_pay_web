import 'dart:async';

import 'package:viggo_pay_admin/route/domain/usecases/change_active_route_use_case.dart';
import 'package:viggo_pay_core_frontend/base/base_view_model.dart';
import 'package:viggo_pay_core_frontend/domain/ui/list_domain_form_fields.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_pay_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_pay_core_frontend/route/domain/usecases/get_route_by_id_use_case.dart';
import 'package:viggo_pay_core_frontend/route/domain/usecases/get_routes_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/util/list_options.dart';

class ListRouteWebViewModel extends BaseViewModel {
  final GetRouteByIdUseCase getRoute;
  final GetRoutesByParamsUseCase getRoutes;
  final UpdateSelectedItemUsecase updateSelected;
  final GetSelectedItemsUseCase getSelectedItems;
  final ClearSelectedItemsUseCase clearSelectedItems;
  final ChangeActiveRouteUseCase changeActive;

  final ListDomainFormFields form = ListDomainFormFields();

  List<RouteApiDto> selectedItemsList = [];

  ListRouteWebViewModel({
    required this.getRoute,
    required this.changeActive,
    required this.getRoutes,
    required this.updateSelected,
    required this.clearSelectedItems,
    required this.getSelectedItems,
  });

  final StreamController<List<RouteApiDto>> routesController =
      StreamController.broadcast();
  Stream<List<RouteApiDto>> get routes => routesController.stream;

  List<RouteApiDto> _items = List.empty(growable: true);

  List<RouteApiDto> _mapSelected(
    List<RouteApiDto> routes,
    List<String> selected,
  ) =>
      routes..forEach((e) => e.selected = selected.contains(e.id));

  void _updateRoutesList(List<RouteApiDto> items) {
    if (!routesController.isClosed) {
      _items = items;
      selectedItemsList = _mapSelected(items, getSelectedItems.invoke());
      routesController.sink.add(selectedItemsList);
    }
  }

  Future<void> loadData(Map<String, String> filters) async {
    if (isLoading) return;
    setLoading();

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

    var result = await getRoutes.invoke(
      filters: filters,
      listOptions: listOptions,
    );
    setLoading();
    if (result.isRight) {
      _updateRoutesList(result.right.routes);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  void checkItem(String id) {
    updateSelected.invoke(id);
    _updateRoutesList(_items);
  }

  Future<RouteApiDto?> catchEntity(String id) async {
    if (isLoading) return null;
    setLoading();
    var result = await getRoute.invoke(id: id);
    setLoading();
    if (result.isRight) {
      return result.right;
    } else if (result.isLeft) {
      postError(result.left.message);
    }
    return null;
  }
}
