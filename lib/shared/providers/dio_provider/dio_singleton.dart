import 'dart:developer';

import 'package:app/shared/providers/auth_token_provider/auth_token_provider.dart';
import 'package:app/shared/shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioSingleton {
  DioSingleton._(ProviderContainer container) {
    _container = container;
    _initializeDio();
  }
  static DioSingleton? _instance;
  late final Dio _dio;
  late final ProviderContainer _container;

  // ignore: prefer_constructors_over_static_methods
  static DioSingleton getInstance(ProviderContainer container) {
    _instance ??= DioSingleton._(container);
    return _instance!;
  }

  void _initializeDio() {
    final env = _container.read(envProvider);
    const timeout = Duration(seconds: 30);
    _dio = Dio(
      BaseOptions(
        baseUrl: env.SERVER_URL,
        sendTimeout: timeout,
        connectTimeout: timeout,
        receiveTimeout: timeout,
      ),
    );

    // Add authentication interceptor
    _dio.interceptors
      ..add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final tokens = _container.read(authTokenProvider);
            // Add access token if available
            if (tokens.value?.accessToken != null) {
              options.headers['Authorization'] =
                  'Bearer ${tokens.value!.accessToken}';
            }

            handler.next(options);
          },
          // onError: (DioException error, handler) async {
          //   // Handle 401 errors by attempting to refresh the token
          //   if (error.response?.statusCode == 401) {
          //     log('Received 401 error, attempting to refresh token');

          //     // Try to refresh the token
          //     final refreshService =
          //         _container.read(tokenRefreshServiceProvider);
          //     final refreshed = await refreshService.refreshTokens();

          //     if (refreshed) {
          //       log('Token refreshed successfully, retrying request');

          //       // Retry the original request with the new token
          //       final tokens = _container.read(authTokenProvider);
          //       final options = error.requestOptions;
          //       options.headers['Authorization'] =
          //           'Bearer ${tokens.value!.accessToken}';
          //       try {
          //         // ignore: inference_failure_on_function_invocation
          //         final response = await _dio.fetch(options);
          //         handler.resolve(response);
          //         return;
          //       } catch (e) {
          //         log('Request retry failed: $e');
          //       }
          //     } else {
          //       log('Token refresh failed, logging out user');
          //       // Clear tokens on refresh failure
          //       await _container.read(authTokenProvider.notifier).clearTokens();

          //       // You can also redirect to login here if needed
          //       // AppRouter.goNamed(AppRouter.login);
          //     }
          //   }

          //   handler.next(error);
          // },
        ),
      )
      ..add(
        PrettyDioLogger(
          requestHeader: true,
          responseBody: false,
          requestBody: true,
        ),
      );
  }

  Dio get dio => _dio;
}

// Provider for the singleton instance
final dioSingletonProvider = Provider<DioSingleton>((ref) {
  return DioSingleton.getInstance(ref.container);
});

// Provider for the Dio instance from the singleton
final dioInstanceProvider = Provider<Dio>((ref) {
  return ref.watch(dioSingletonProvider).dio;
});
