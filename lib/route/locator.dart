import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/route/domain/usecases/change_active_route_use_case.dart';
import 'package:viggo_pay_admin/route/ui/edit_routes/edit_routes_view_model.dart';
import 'package:viggo_pay_admin/route/ui/list_routes/list_route_web_view_model.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_pay_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_pay_core_frontend/route/domain/route_repository.dart';
import 'package:viggo_pay_core_frontend/route/domain/usecases/create_route_use_case.dart';
import 'package:viggo_pay_core_frontend/route/domain/usecases/get_route_by_id_use_case.dart';
import 'package:viggo_pay_core_frontend/route/domain/usecases/get_routes_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/route/domain/usecases/update_route_use_case.dart';

class RouteLocator {
  void setup() {
    //usecases
    locator.registerFactory(
      () => ChangeActiveRouteUseCase(
        repository: locator.get<RouteRepository>(),
      ),
    );

    // ViewModels
    locator.registerFactory(
      () => EditRoutesViewModel(
        getRoutes: locator.get<GetRoutesByParamsUseCase>(),
        createRoute: locator.get<CreateRouteUseCase>(),
        updateRoute: locator.get<UpdateRouteUseCase>(),
      ),
    );

    locator.registerFactory(
      () => ListRouteWebViewModel(
        getRoute: locator.get<GetRouteByIdUseCase>(),
        changeActive: locator.get<ChangeActiveRouteUseCase>(),
        getRoutes: locator.get<GetRoutesByParamsUseCase>(),
        updateSelected: locator.get<UpdateSelectedItemUsecase>(),
        clearSelectedItems: locator.get<ClearSelectedItemsUseCase>(),
        getSelectedItems: locator.get<GetSelectedItemsUseCase>(),
      ),
    );
  }
}
