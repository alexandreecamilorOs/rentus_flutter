import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/components/global_animated_shell.dart';

void main() {
  runApp(const ProviderScope(child: RentusApp()));
}

class RentusApp extends ConsumerWidget {
  const RentusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MaterialApp.router(
          title: 'Rentus',
          theme: AppTheme.lightTheme,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            if (child == null) return const SizedBox.shrink();
            return GlobalAnimatedShell(child: child);
          },
        );
      },
    );
  }
}
