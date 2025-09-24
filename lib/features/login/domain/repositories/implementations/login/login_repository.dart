import 'package:app/features/home/domain/home_domain.dart';
import 'package:app/shared/utils/alert.dart';
import 'package:app/shared/utils/failure.dart';
import 'package:app/shared/utils/typedef.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/features/login/login.dart';

part 'login_repository.g.dart';

@Riverpod(keepAlive: true)
ILoginRepository loginRepo(Ref ref) => LoginRepository();

class LoginRepository implements ILoginRepository {
  LoginRepository();

  @override
  FutureEither<UserAuthData> getLogin() async {
    try {
      final responce = await Dio().request<Map<String, dynamic>>(
        'https://s419.previewbay.com/fragrance-b2b-backend/api/v1/anonymous-login?device_token=test_token&device_type=1',
        options: Options(method: 'POST'),
      );
      if (responce.statusCode == 200) {
        final spotRateModel = UserAuthData.fromJson(responce.data!);
        return right(spotRateModel);
      } else {
        return left(Failure(responce.statusCode.toString()));
      }
    } on DioException catch (e) {
      return left(Failure('Dio EXCEPTION ${e.error}'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
