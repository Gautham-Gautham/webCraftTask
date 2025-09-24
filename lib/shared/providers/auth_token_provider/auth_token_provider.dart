import 'dart:convert' as convert;

// import 'package:app/features/auth/auth.dart';
import 'package:app/features/home/home.dart';
import 'package:app/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_token_provider.g.dart';
part 'auth_token_provider.freezed.dart';

/// Model to store authentication tokens
@freezed
sealed class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    String? accessToken,
    String? refreshToken,
    DateTime? accessTokenExpiry,
  }) = _AuthTokens;
  const AuthTokens._();

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);

  bool get hasValidAccessToken {
    if (accessToken == null || accessTokenExpiry == null) return false;
    return accessTokenExpiry!.isAfter(DateTime.now());
  }
}

@Riverpod(keepAlive: true)
class AuthToken extends _$AuthToken {
  static const _tokensKey = 'auth_tokens';
  static const _userAuthDataKey = 'user_auth_data';
  @override
  Future<AuthTokens> build() async {
    return _loadPersistedTokens();
  }

  Future<AuthTokens> _loadPersistedTokens() async {
    try {
      final prefs = await ref.read(sharedPrefsProvider.future);
      final tokensJson = prefs.getString(_tokensKey);
      if (tokensJson != null) {
        final tokensMap = Map<String, dynamic>.from(
          convert.jsonDecode(tokensJson) as Map,
        );
        final tokens = AuthTokens.fromJson(tokensMap);

        return tokens;
      } else {
        return const AuthTokens();
      }
    } catch (e) {
      debugPrint('Error loading persisted tokens: $e');
      return const AuthTokens();
    }
  }

  Future<void> _persistTokens(AuthTokens tokens) async {
    try {
      final prefs = await ref.read(sharedPrefsProvider.future);
      if (tokens.accessToken != null || tokens.refreshToken != null) {
        await prefs.setString(
          _tokensKey,
          convert.jsonEncode(tokens.toJson()),
        );
      } else {
        await prefs.remove(_tokensKey);
      }
    } catch (e) {
      debugPrint('Error persisting tokens: $e');
    }
  }

  Future<void> saveUserAuthData(UserAuthData userAuthData) async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    await prefs.setString(
      _userAuthDataKey,
      convert.jsonEncode(userAuthData.toJson()),
    );
  }

  Future<UserAuthData?> getUserAuthData() async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    final userAuthDataJson = prefs.getString(_userAuthDataKey);
    return userAuthDataJson != null
        ? UserAuthData.fromJson(
            convert.jsonDecode(userAuthDataJson) as Map<String, dynamic>,
          )
        : null;
  }

  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
    required Duration accessTokenLifetime,
  }) async {
    final newTokens = AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpiry: DateTime.now().add(accessTokenLifetime),
    );
    state = AsyncValue.data(newTokens);
    await _persistTokens(newTokens);
  }

  Future<void> updateAccessToken({
    required String accessToken,
    required Duration accessTokenLifetime,
  }) async {
    final newTokens = state.value!.copyWith(
      accessToken: accessToken,
      accessTokenExpiry: DateTime.now().add(accessTokenLifetime),
    );
    state = AsyncValue.data(newTokens);
    await _persistTokens(newTokens);
  }

  Future<void> clearTokens() async {
    state = const AsyncValue.data(AuthTokens());
    await _persistTokens(state.value!);
  }

  Future<void> clearUserAuthData() async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    await prefs.remove(_userAuthDataKey);
  }
}
