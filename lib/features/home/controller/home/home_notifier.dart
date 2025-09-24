import 'package:app/features/home/domain/models/home_response/home_response_model.dart';
import 'package:app/features/home/domain/repositories/implementations/home/home_repository.dart';
import 'package:app/features/home/domain/repositories/interfaces/home/i_home_repository.dart';
import 'package:app/shared/shared.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hancod_theme/hancod_theme.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_notifier.freezed.dart';
part 'home_notifier.g.dart';
part 'home_state.dart';

@Riverpod(keepAlive: false)
class HomeNotifier extends _$HomeNotifier {
  late final IHomeRepository _homeRepository;
  @override
  HomeState build(String token) {
    state = HomeState.initial();
    _homeRepository = ref.read(homeRepoProvider);
    homeData(token);
    return state;
  }

  Future<void> homeData(String token) async {
    state = state.copyWith(status: HomeStatus.loading);
    HomeResponse? homeResponse;
    final res = await _homeRepository.getHome(token: token);
    res.fold(
      (l) {
        Alert.showSnackBar('Error', type: SnackBarType.error);
        state = state.copyWith(error: l.message, status: HomeStatus.error);
      },
      (r) {
        homeResponse = r;
        print(r.toJson());
        state = state.copyWith(
          status: HomeStatus.success,
          homeResponse: homeResponse,
        );
      },
    );
  }
}
