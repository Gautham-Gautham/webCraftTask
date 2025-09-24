import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/login/login.dart';
import 'package:app/shared/shared.dart';

export 'login_mobile.dart';
export 'login_web.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: ResponsiveWidget(
        smallScreen: LoginScreenMobile(),
        largeScreen: LoginScreenWeb(),
      ),
    );
  }
}
