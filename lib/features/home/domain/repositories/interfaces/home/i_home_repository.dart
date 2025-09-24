import 'package:app/features/home/domain/models/home_response/home_response_model.dart';
import 'package:app/shared/utils/typedef.dart';

abstract class IHomeRepository {
  FutureEither<HomeResponse> getHome({required String token});
}
