import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:security_wave/presentation/pages/auth.dart';
import 'package:security_wave/presentation/pages/home.dart';
import 'package:security_wave/presentation/pages/onBoarding.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

Widget myTransition(child, animation) {
  return FadeTransition(
    opacity: CurveTween(curve: Curves.easeIn).animate(animation),
    child: child,
  );
}

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: "/onBoarding",
  routes: <RouteBase>[
    GoRoute(
      path: '/onBoarding',
      name: 'onBoarding',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          name: state.name,
          child: const OnboardingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return myTransition(child, animation);
          },
        );
      },
    ),
    GoRoute(
      path: '/auth_page',
      name: 'auth_page',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          name: state.name,
          child: Authentication_Page(isTablet: false),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return myTransition(child, animation);
          },
        );
      },
    ),
    GoRoute(
      path: '/home_page',
      name: 'home_page',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          name: state.name,
          child: Home_Page(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return myTransition(child, animation);
          },
        );
      },
    ),
  ],
);
