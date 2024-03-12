import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/route/ui/edit_routes/edit_routes_form/edit_form_fields.dart';
import 'package:viggo_pay_core_frontend/route/domain/usecases/create_route_use_case.dart';
import 'package:viggo_pay_core_frontend/route/domain/usecases/get_routes_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/route/domain/usecases/update_route_use_case.dart';

class EditRoutesViewModel extends ChangeNotifier {
  bool isLoading = false;

  final GetRoutesByParamsUseCase getRoutes;
  final UpdateRouteUseCase updateRoute;
  final CreateRouteUseCase createRoute;

  final EditRouteFormFields form = EditRouteFormFields();

  final StreamController<String> _streamControllerError =
      StreamController<String>.broadcast();
  Stream<String> get isError => _streamControllerError.stream;

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  EditRoutesViewModel({
    required this.getRoutes,
    required this.updateRoute,
    required this.createRoute,
  });

  void notifyLoading() {
    isLoading = !isLoading;
    // notifyListeners();
  }

  void submit(
    String? id,
    Function showMsg,
    BuildContext context,
  ) async {
    notifyLoading();
    dynamic result;
    var formFields = form.getFields();

    Map<String, dynamic> data = {
      'name': formFields!['name'],
      'url': formFields['url'],
      'method': formFields['method'],
      'bypass': formFields['bypass'].toString().parseBool(),
      'sysadmin': formFields['sysadmin'].toString().parseBool(),
    };
    
    if (id != null) {
      data.addEntries(
        <String, dynamic>{'id': id}.entries,
      );
      result = await updateRoute.invoke(id: id, body: data);
    } else {
      result = await createRoute.invoke(body: data);
    }
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamControllerSuccess.isClosed) {
        _streamControllerSuccess.sink.add(true);
        notifyLoading();
      }
    }
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}

