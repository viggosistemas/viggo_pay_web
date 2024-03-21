import 'dart:async';

import 'package:viggo_core_frontend/application/data/models/application_api_dto.dart';
import 'package:viggo_core_frontend/application/domain/usecases/get_application_by_id_use_case.dart';
import 'package:viggo_core_frontend/application/domain/usecases/get_applications_by_params_use_case.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/domain/ui/list_domain_form_fields.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/clear_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_selected_items_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/update_selected_item_use_case.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/application/domain/usecases/change_active_application_use_case.dart';

class ListApplicationWebViewModel extends BaseViewModel {
  final GetApplicationByIdUseCase getApplication;
  final GetApplicationsByParamsUseCase getApplications;
  final UpdateSelectedItemUsecase updateSelected;
  final GetSelectedItemsUseCase getSelectedItems;
  final ClearSelectedItemsUseCase clearSelectedItems;
  final ChangeActiveApplicationUseCase changeActive;

  List<ApplicationApiDto> selectedItemsList = [];

  final ListDomainFormFields form = ListDomainFormFields();

  ListApplicationWebViewModel({
    required this.getApplication,
    required this.changeActive,
    required this.getApplications,
    required this.updateSelected,
    required this.clearSelectedItems,
    required this.getSelectedItems,
  });

  final StreamController<List<ApplicationApiDto>> applicationsController =
      StreamController.broadcast();
  Stream<List<ApplicationApiDto>> get applications =>
      applicationsController.stream;

  List<ApplicationApiDto> _items = List.empty(growable: true);

  List<ApplicationApiDto> _mapSelected(
    List<ApplicationApiDto> applications,
    List<String> selected,
  ) =>
      applications..forEach((e) => e.selected = selected.contains(e.id));

  void _updateApplicationsList(List<ApplicationApiDto> items) {
    if (!applicationsController.isClosed) {
      _items = items;
      selectedItemsList = _mapSelected(items, getSelectedItems.invoke());
      applicationsController.sink.add(selectedItemsList);
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

    var result = await getApplications.invoke(
      filters: filters,
      listOptions: listOptions,
    );

    setLoading();
    if (result.isRight) {
      _updateApplicationsList(result.right.applications);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  void checkItem(String id) {
    updateSelected.invoke(id);
    _updateApplicationsList(_items);
  }

  Future<ApplicationApiDto?> catchEntity(String id) async {
    if (isLoading) return null;

    setLoading();
    var result = await getApplication.invoke(id: id);
    setLoading();
    if (result.isRight) {
      return result.right;
    } else if (result.isLeft) {
      postError(result.left.message);
    }
    return null;
  }
}
