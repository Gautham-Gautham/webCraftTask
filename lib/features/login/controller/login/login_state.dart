part of 'login_notifier.dart';

enum LoginStatus {
  initial,
  loading,
  success,
  error,
}

extension LoginStatusExtension on LoginStatus {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function() success,
    required R Function() error,
  }) {
    switch (this) {
      case LoginStatus.initial:
        return initial();
      case LoginStatus.loading:
        return loading();
      case LoginStatus.success:
        return success();
      case LoginStatus.error:
        return error();
    }
  }
}

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState({
    @Default(LoginStatus.initial) LoginStatus status,
    @Default(null) UserAuthData? userAuthData,
  }) = _LoginState;

  factory LoginState.initial() => const LoginState();
}
