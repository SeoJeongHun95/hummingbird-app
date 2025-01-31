import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/router/router.dart';
import 'core/utils/show_snack_bar.dart';
import 'src/app_initialize.dart';
import 'src/viewmodels/app_setting/app_setting_view_model.dart';

void main() async {
  final List<String> supportedLanguages = ['ko', 'en', 'ja', 'zh', 'vi', 'th'];
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await EasyLocalization.ensureInitialized();
  await appInitialize();

  runApp(
    EasyLocalization(
      supportedLocales: supportedLanguages.map((lang) => Locale(lang)).toList(),
      path: 'lib/core/translations',
      fallbackLocale: const Locale('ko'),
      startLocale: supportedLanguages
              .contains(PlatformDispatcher.instance.locale.languageCode)
          ? Locale(PlatformDispatcher.instance.locale.languageCode)
          : const Locale('ko'),
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final appSetting = ref.watch(appSettingViewModelProvider);
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp.router(
        routerConfig: goRouter,
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'HummingBird',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: TextTheme(
              bodyMedium:
                  TextStyle(fontSize: (12 + appSetting.fontSize.toDouble()))),
          splashFactory: NoSplash.splashFactory,
          useMaterial3: true,
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
