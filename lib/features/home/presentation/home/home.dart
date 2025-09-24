import 'package:app/features/home/home.dart';
import 'package:app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'home_mobile.dart';
export 'home_web.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.token});
  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ResponsiveWidget(
        smallScreen: HomeScreenMobile(token: token),
        largeScreen: const HomeScreenWeb(),
      ),
    );
  }
}
