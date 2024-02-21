// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/sync/domain/usecases/get_app_state_use_case.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

class LazyLoadingViewModel extends ChangeNotifier {
  final GetAppStateUseCase getAppState;

  Stream<bool> get isLogged => getAppState.invoke().transform(
        StreamTransformer<String, bool>.fromHandlers(
          handleData: (value, sink) {
            sink.add(value == AppStateConst.LOGGED);
          },
        ),
      );

  LazyLoadingViewModel({
    required this.getAppState,
  });
}
