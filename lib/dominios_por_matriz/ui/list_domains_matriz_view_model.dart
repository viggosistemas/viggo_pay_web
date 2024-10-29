import 'dart:async';

import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/get_domains_by_params_use_case.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/dominios_por_matriz/ui/list_domains_matriz_form_fields.dart';

class ListDomainsMatrizViewModel extends BaseViewModel {
  final GetDomainsByParamsUseCase getDomains;

  final ListDomainsMatrizFormField form = ListDomainsMatrizFormField();

  ListDomainsMatrizViewModel({
    required this.getDomains,
  });

  Future loadDomains(Map<String, String> filters) async {
    if (isLoading) return;

    setLoading();
    var listOptions = ListOptions.values
        .where((element) => element.name == filters['list_options'])
        .first;

    var result = await getDomains.invoke(
      filters: filters,
      listOptions: listOptions,
    );
    setLoading();
    if (result.isRight) {
      return result.right.domains;
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }
}
