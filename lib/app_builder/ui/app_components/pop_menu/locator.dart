import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_core_frontend/image/domain/usecases/parse_image_url_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/delete_photo_use_case%20.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/get_user_by_id_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/get_user_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/set_user_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/update_password_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/update_user_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/upload_photo_use_case.dart';

class PopMenuLocator {
  void setup() {
    // ViewModels
    locator.registerFactory(
      () => PopMenuViewModel(
        getUserById: locator.get<GetUserByIdUseCase>(),
        setUser: locator.get<SetUserUseCase>(),
        deletePhotoUserUseCase: locator.get<DeletePhotoUserUseCase>(),
        uploadPhotoUserUseCase: locator.get<UploadPhotoUserUseCase>(),
        parseImage: locator.get<ParseImageUrlUseCase>(),
        updateUserUseCase: locator.get<UpdateUserUseCase>(),
        updatePasswordUserUseCase: locator.get<UpdatePasswordUserUseCase>(),
        getUserFromSettings: locator.get<GetUserUseCase>(),
      ),
    );
  }
}
