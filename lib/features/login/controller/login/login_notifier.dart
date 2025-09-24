import 'package:app/features/home/domain/home_domain.dart';
import 'package:app/features/login/domain/repositories/implementations/login/login_repository.dart';
import 'package:app/features/login/domain/repositories/interfaces/login/i_login_repository.dart';
import 'package:app/shared/utils/alert.dart';
import 'package:app/shared/utils/router.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hancod_theme/alert.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_notifier.freezed.dart';
part 'login_notifier.g.dart';
part 'login_state.dart';

@Riverpod(keepAlive: false)
class LoginNotifier extends _$LoginNotifier {
  late final ILoginRepository _loginRepository;
  @override
  LoginState build() {
    _loginRepository = ref.read(loginRepoProvider);
    return LoginState.initial();
  }

  Future<void> getLogin() async {
    state = state.copyWith(status: LoginStatus.loading);
    UserAuthData? userAuthData;
    final res = await _loginRepository.getLogin();
    res.fold(
      (l) {
        state = state.copyWith(status: LoginStatus.error);
      },
      (r) {
        userAuthData = r;
        state = state.copyWith(
          status: LoginStatus.success,
          userAuthData: userAuthData,
        );
        Alert.showSnackBar('Login Success', type: SnackBarType.success);
        AppRouter.pushNamed(
          AppRouter.home,
          pathParameters: {'token': r.data.accessToken},
        );
      },
    );
  }
}
