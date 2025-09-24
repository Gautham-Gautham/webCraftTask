import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_auth_data_model.freezed.dart';
part 'user_auth_data_model.g.dart';

@freezed
abstract class UserAuthData with _$UserAuthData {
  const factory UserAuthData({
    @JsonKey(name: 'error_code') required int errorCode,
    required String message,
    required UserData data,
  }) = _UserAuthData;

  factory UserAuthData.fromJson(Map<String, dynamic> json) =>
      _$UserAuthDataFromJson(json);
}

@freezed
abstract class UserData with _$UserData {
  const factory UserData({
    @JsonKey(name: 'access_token') required String accessToken,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
