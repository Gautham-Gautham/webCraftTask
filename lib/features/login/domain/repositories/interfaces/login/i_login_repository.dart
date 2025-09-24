import 'package:app/features/home/domain/models/user_auth_data/user_auth_data_model.dart';
import 'package:app/shared/utils/typedef.dart';

abstract class ILoginRepository {
  FutureEither<UserAuthData> getLogin();
}
