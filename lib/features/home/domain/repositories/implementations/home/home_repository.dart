import 'package:app/features/home/home.dart';
import 'package:app/shared/utils/failure.dart';
import 'package:app/shared/utils/typedef.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@Riverpod(keepAlive: true)
IHomeRepository homeRepo(Ref ref) => HomeRepository();

class HomeRepository implements IHomeRepository {
  HomeRepository();

  @override
  FutureEither<HomeResponse> getHome({required String token}) async {
    try {
      final headers = {'Authorization': 'Bearer $token'};
      final responce = await Dio().request<Map<String, dynamic>>(
        'https://s419.previewbay.com/fragrance-b2b-backend/api/v1/home',
        options: Options(headers: headers, method: 'GET'),
      );
      print(responce.data);
      if (responce.statusCode == 200) {
        final spotRateModel = HomeResponse.fromJson(responce.data!);
        return right(spotRateModel);
      } else {
        return left(Failure(responce.statusCode.toString()));
      }
    } on DioException catch (e) {
      print(e.error);
      print(e.stackTrace);
      print(e.message);
      print(e.response);
      return left(Failure("Dio EXCEPTION"));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return left(Failure(e.toString()));
    }
  }
}
