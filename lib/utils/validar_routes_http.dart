import 'package:viggo_core_frontend/route/data/models/route_api_dto.dart';

class ValidarRoutesHttp {
  ValidarRoutesHttp({required this.routes});

  final List<RouteApiDto> routes;

  getRoutesAuthorization(String urlName) {
    List<RouteApiDto> routesAuthorization = [];
    if (routes.isNotEmpty) {
      return routesAuthorization = routes.where((e) => e.url.compareTo(urlName) == 0).toList();
    }
    return routesAuthorization;
  }

  validarAdicao(
    List<RouteApiDto> routesAuthorization,
    String action,
    String urlName, {
    String params = '',
  }) {
    if (routesAuthorization.isNotEmpty) {
      return routesAuthorization.firstWhere((e) => e.url.compareTo(urlName) == 0 && e.method.name.compareTo(action) == 0);
    }
    return null;
  }

  checkDisponibilidade(
    String action,
    String urlName, {
    String params = '',
  }) {
    var returnedRoute = validarAdicao(
      getRoutesAuthorization(urlName),
      action,
      urlName,
      params: params,
    );
    return returnedRoute != null;
  }
}
