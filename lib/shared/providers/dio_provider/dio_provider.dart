import 'dart:developer';

import 'package:app/shared/providers/auth_token_provider/auth_token_provider.dart';
import 'package:app/shared/providers/base_url_provider.dart';
import 'package:app/shared/shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Dio provider that uses the static base URL from the environment.
/// This should only be used for fetching the dynamic base URL.
final staticDioProvider = Provider<Dio>((ref) {
  final env = ref.watch(envProvider);
  final dio = Dio(BaseOptions(baseUrl: env.SERVER_URL));
  dio.interceptors
      .add(PrettyDioLogger(requestHeader: true, responseBody: false));
  return dio;
});

final dioProvider = Provider<Dio>(
  (ref) {
    final env = ref.watch(envProvider);
    final baseUrl = ref.watch(baseUrlProvider);
    final dio = Dio(BaseOptions(baseUrl: baseUrl ?? env.SERVER_URL));

    // Add authentication interceptor
    dio.interceptors
      ..add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final tokens = ref.read(authTokenProvider);
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
          //     final refreshService = ref.read(tokenRefreshServiceProvider);
          //     final refreshed = await refreshService.refreshTokens();

          //     if (refreshed) {
          //       log('Token refreshed successfully, retrying request');

          //       // Retry the original request with the new token
          //       final tokens = ref.read(authTokenProvider);
          //       final options = error.requestOptions;
          //       options.headers['Authorization'] =
          //           'Bearer ${tokens.value!.accessToken}';
          //       try {
          //         // ignore: inference_failure_on_function_invocation
          //         final response = await dio.fetch(options);
          //         handler.resolve(response);
          //         return;
          //       } catch (e) {
          //         log('Request retry failed: $e');
          //       }
          //     } else {
          //       log('Token refresh failed, logging out user');
          //       // Clear tokens on refresh failure
          //       await ref.read(authTokenProvider.notifier).clearTokens();

          //       // You can also redirect to login here if needed
          //       // AppRouter.goNamed(AppRouter.login);
          //     }
          //   }

          //   handler.next(error);
          // },
        ),
      )
      ..add(PrettyDioLogger(requestHeader: true, responseBody: false));

    inspect(dio);

    return dio;
  },
);
