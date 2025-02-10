import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../src/models/subject/subject.dart';
import '../../src/viewmodels/app_setting/app_setting_view_model.dart';
import '../../src/views/home/home_screen.dart';
import '../../src/views/home/suduck_timer_focus_mode_screen.dart';
import '../../src/views/home/widgets/subject/subject_add_screen.dart';
import '../../src/views/home/widgets/subject/subject_update_screen.dart';
import '../../src/views/more/more_screen.dart';
import '../../src/views/more/profile_screen.dart';
import '../../src/views/more/settings_screen/settings_export.dart';
import '../../src/views/more/timer_setting_screen.dart';
import '../../src/views/splash/splash_screen.dart';
import '../../src/views/statistics/views/statistics_screen.dart';
import '../../src/views/tutorial/profile_setting_screen.dart';
import '../../src/views/tutorial/study_setting_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();
bool firstRun = true;

// GoRouter 설정
final goRouterProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = true;
  bool isFirstInstalled = true;

  if (isLoggedIn) {
    isFirstInstalled =
        ref.read(appSettingViewModelProvider.notifier).isFirstInstalled;
  }

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      if (firstRun && state.fullPath == '/splash') {
        firstRun = false;
        return null;
      }

      if (state.fullPath == '/login' && isLoggedIn) {
        return '/';
      }

      if (!isLoggedIn) {
        return '/splash';
      }

      if (!firstRun && state.fullPath == '/splash') {
        return isFirstInstalled ? '/tutorial' : '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const HomeScreen(),
        ),
        routes: [
          GoRoute(
            path: 'focusMode',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const SuduckTimerFocusModeWidget(),
            ),
          ),
          GoRoute(
            path: 'subjectAdd',
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: SubjectAddScreen(
                  subjects: (state.extra as List)[0] as List<Subject>,
                  index: (state.extra as List)[1] as int,
                ),
              );
            },
          ),
          GoRoute(
            path: 'subjectUpdate',
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: SubjectUpdateScreen(
                  subject: (state.extra as List)[0] as Subject,
                  index: (state.extra as List)[1] as int,
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const SplashScreen(),
        ),
      ),
      // GoRoute(
      //   path: '/social',
      //   pageBuilder: (context, state) => buildPageWithDefaultTransition(
      //     context: context,
      //     state: state,
      //     child: const SocialScreen(),
      //   ),
      // ),
      GoRoute(
        path: '/statistics',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const StatisticsScreen(),
        ),
      ),
      GoRoute(
        path: '/more',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const MoreScreen(),
        ),
        routes: [
          GoRoute(
            path: 'profile',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const ProfileScreen(),
            ),
          ),
          GoRoute(
            path: 'timerSetting',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const TimerSettingScreen(),
            ),
          ),
          GoRoute(
            path: 'settings',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const SettingsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'language',
                pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  context: context,
                  state: state,
                  child: const SelectLanguageScreen(),
                ),
              ),
              GoRoute(
                path: 'country',
                pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  context: context,
                  state: state,
                  child: const SelectCountryScreen(),
                ),
              ),
              GoRoute(
                path: 'group',
                pageBuilder: (context, state) => buildPageWithDefaultTransition(
                  context: context,
                  state: state,
                  child: const SelectGroupScreen(),
                ),
              ),
            ],
          )
        ],
      ),
      GoRoute(
        path: '/tutorial',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: const ProfileSettingScreen(),
        ),
        routes: [
          GoRoute(
            path: 'studySetting',
            pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: const StudySettingScreen(),
            ),
          )
        ],
      ),
    ],

    // errorBuilder: (context, state) => PageNotFound(
    //   errMsg: state.error.toString(),
    // ),
  );
});

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
