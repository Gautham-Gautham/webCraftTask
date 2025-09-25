part of 'home_notifier.dart';

enum HomeStatus {
  initial,
  loading,
  success,
  error,
}

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    @Default(null) HomeResponse? homeResponse,
    @Default('') String searchQuery,
    @Default(null) HomeResponse? originalHomeResponse,
    String? error,
  }) = _HomeState;

  factory HomeState.initial() => const HomeState();
}
