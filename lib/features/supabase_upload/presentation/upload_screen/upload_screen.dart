import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/supabase_upload/supabase_upload.dart';
import 'package:app/shared/shared.dart';

export 'upload_screen_mobile.dart';
export 'upload_screen_web.dart';

class UploadScreenScreen extends ConsumerWidget {
  const UploadScreenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: ResponsiveWidget(
        smallScreen: UploadScreenScreenMobile(),
        largeScreen: UploadScreenScreenWeb(),
      ),
    );
  }
}
