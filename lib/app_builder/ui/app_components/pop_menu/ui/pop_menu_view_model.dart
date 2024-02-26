import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_items/alterar_senha/alterar_senha_form_fields.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_items/info_user/info_user_form_fields.dart';
import 'package:viggo_pay_core_frontend/image/domain/usecases/parse_image_url_use_case.dart';
import 'package:viggo_pay_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/get_user_by_id_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/get_user_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/remove_photo_user_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/set_user_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/update_password_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/update_user_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/upload_photo_user_use_case.dart';

class PopMenuViewModel extends ChangeNotifier {
  final UpdateUserUseCase updateUserUseCase;
  final UpdatePasswordUserUseCase updatePasswordUserUseCase;
  final GetUserUseCase getUserFromSettings;
  final SetUserUseCase setUser;
  final GetUserByIdUseCase getUserById;
  final ParseImageUrlUseCase parseImage;
  final UploadPhotoUserUseCase uploadPhotoUserUseCase;
  final RemovePhotoUserUseCase deletePhotoUserUseCase;

  final InfoUserFormFields form = InfoUserFormFields();
  final AlterarSenhaFormFields formSenha = AlterarSenhaFormFields();

  bool isLoading = false;

  final StreamController<bool> _streamController =
      StreamController<bool>.broadcast();

  final StreamController<String> _streamControllerError =
      StreamController<String>.broadcast();

  Stream<bool> get isSuccess => _streamController.stream;
  Stream<String> get isError => _streamControllerError.stream;

  PopMenuViewModel({
    required this.parseImage,
    required this.updateUserUseCase,
    required this.uploadPhotoUserUseCase,
    required this.deletePhotoUserUseCase,
    required this.updatePasswordUserUseCase,
    required this.getUserFromSettings,
    required this.setUser,
    required this.getUserById,
  });

  void notifyLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<void> funGetUserById(String userId) async {
    var result = await getUserById.invoke(id: userId);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
      }
    } else {
      setUser.invoke(result.right);
    }
  }

  UserApiDto? get user {
    var userDto = getUserFromSettings.invoke();
    if (userDto == null) {
      return null;
    } else {
      return userDto;
    }
  }

  void onSubmit(
    Function showMsg,
    BuildContext context,
  ) async {
    notifyLoading();

    Map<String, dynamic> params = {
      'id': user!.id,
      'nickname': '',
    };
    var formFields = form.getFields();
    params['nickname'] = formFields?['nickname'] ?? '';

    var result = await updateUserUseCase.invoke(id: user!.id, body: params);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamController.isClosed) {
        _streamController.sink.add(true);
        await funGetUserById(user!.id);
        notifyLoading();
      }
    }
  }

  void onSubmitSenha(
    Function showMsg,
    BuildContext context,
  ) async {
    notifyLoading();

    Map<String, dynamic> params = {
      'old_password': '',
      'password': '',
    };
    var formFields = formSenha.getFields();
    params['old_password'] = formFields?['senhaAntiga'] ?? '';
    params['password'] = formFields?['novaSenha'] ?? '';

    var result =
        await updatePasswordUserUseCase.invoke(id: user!.id, body: params);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamController.isClosed) {
        _streamController.sink.add(true);
        notifyLoading();
      }
    }
  }

  void uploadPhoto(
    PlatformFile file,
    Function showMsg,
    BuildContext context,
  ) async {
    notifyLoading();

    var result = await uploadPhotoUserUseCase.invoke(id: user!.id, file: file);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamController.isClosed) {
        _streamController.sink.add(true);
        notifyLoading();
      }
    }
  }
}
