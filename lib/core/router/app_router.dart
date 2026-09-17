// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../../features/auth/presentation/providers/auth_provider.dart';
// import '../../features/auth/presentation/screens/login_screen.dart';
// import '../../features/auth/presentation/screens/register_screen.dart';
// import '../../features/home/presentation/screens/home_screen.dart';

// final appRouterProvider = Provider<GoRouter>((ref) {
//   final authState = ref.watch(authStateProvider);

//   return GoRouter(
//     initialLocation: '/login',
//     redirect: (context, state) {
//       final isLoggedIn = authState.value?.session != null;
//       final isLoggingIn = state.matchedLocation == '/login' ||
//           state.matchedLocation == '/register';

//       // If not logged in and trying to access protected page → go to login
//       if (!isLoggedIn && !isLoggingIn) {
//         return '/login';
//       }

//       // If logged in and still on login/register → go to home
//       if (isLoggedIn && isLoggingIn) {
//         return '/home';
//       }

//       return null; // no redirect needed
//     },
//     routes: [
//       GoRoute(
//         path: '/login',
//         builder: (context, state) => const LoginScreen(),
//       ),
//       GoRoute(
//         path: '/register',
//         builder: (context, state) => const RegisterScreen(),
//       ),
//       GoRoute(
//         path: '/home',
//         builder: (context, state) => const HomeScreen(),
//       ),
//     ],
//   );
// });
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/flowering/presentation/screens/flowering_list_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home', // ← Start directly on Home
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/flowering',
        builder: (context, state) => const FloweringListScreen(),
      ),
    ],
  );
});