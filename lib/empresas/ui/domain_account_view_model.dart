import 'package:flutter/material.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/search_domain_by_name_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/set_domain_use_case.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class DomainAccountViewModel extends ChangeNotifier {
  final SearchDomainByNameUseCase searchDomainByName;
  final SetDomainUseCase setDomain;
  bool isLoading = false;

  DomainAccountViewModel({
    required this.searchDomainByName,
    required this.setDomain,
  });

  void _notifyLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  String? _handleException(NetworkException exception) {
    String? error;
    if (exception.runtimeType == NotFound) {
      error = 'Domínio não encontrado';
    } else {
      error = exception.message;
    }

    return error;
  }

  void onSearch(String searchTerm, Function onError, Function onSucess) async {
    _notifyLoading();

    var result = await searchDomainByName.invoke(name: searchTerm);
    if (result.isRight) {
      setDomain.invoke(result.right);
      _notifyLoading();
      onSucess();
    } else {
      var error = _handleException(result.left);
      _notifyLoading();
      onError(error);
    }
  }
}
