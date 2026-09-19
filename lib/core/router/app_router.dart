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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pitayapro/features/flowering/presentation/screens/edit_flowering_screen.dart';
import 'package:pitayapro/features/inputs/presentation/screens/add_fertilising_screen.dart';
import 'package:pitayapro/features/inputs/presentation/screens/fertilising_list_screen.dart';
import 'package:pitayapro/features/my_farm/presentation/screens/blocks_list_screen.dart';
import 'package:pitayapro/features/my_farm/presentation/screens/edit_farm_screen.dart';
import 'package:pitayapro/features/my_farm/presentation/screens/farm_map_screen.dart';


import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/flowering/presentation/screens/flowering_list_screen.dart';
import '../../features/my_farm/presentation/screens/farm_dashboard_screen.dart'; // Add this import
import '../../features/flowering_event/presentation/screens/flowering_detail_screen.dart';
import '../../features/flowering/presentation/screens/add_flowering_screen.dart';
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
        GoRoute(
    path: '/my-farm',
    builder: (context, state) => const FarmDashboardScreen(),
  ),
  GoRoute(
  path: '/my-farm/map',
  builder: (context, state) => const FarmMapScreen(),
),
  // GoRoute(
  //   path: '/my-farm/create',
  //   builder: (context, state) => const CreateFarmScreen(),
  // ),
    GoRoute(
    path: '/my-farm/edit',
    builder: (context, state) => const EditFarmScreen(),
  ),
  GoRoute(
    path: '/my-farm/map',
    builder: (context, state) => const FarmMapScreen(),
  ),
  GoRoute(
  path: '/flowering/add',
  builder: (context, state) => const AddFloweringScreen(),
),
GoRoute(
  path: '/flowering/:id',
  builder: (context, state) {
    final eventId = state.pathParameters['id']!;
    return FloweringDetailScreen(eventId: eventId);
  },
),


   GoRoute(
        path: '/flowering/:id',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return FloweringDetailScreen(eventId: eventId);
        },
      ),

      GoRoute(
  path: '/flowering',
  builder: (context, state) => const FloweringListScreen(),
),
GoRoute(
  path: '/flowering/add',
  builder: (context, state) => const AddFloweringScreen(),
),

GoRoute(
  path: '/flowering/edit/:id',
  builder: (context, state) {
    final eventId = state.pathParameters['id']!;
    return EditFloweringScreen(eventId: eventId);
  },
),
      GoRoute(
  path: '/flowering/add',
  builder: (context, state) => const AddFloweringScreen(),
),

GoRoute(
  path: '/my-farm/map',
  builder: (context, state) {
    final focusBlockId = state.extra as String?;
    return FarmMapScreen(focusBlockId: focusBlockId);
  },
),
GoRoute(
  path: '/my-farm/blocks',
  builder: (context, state) => const BlocksListScreen(),
),

GoRoute(
  path: '/inputs',
  builder: (context, state) => const FertilisingListScreen(),
),
GoRoute(
  path: '/inputs/add',
  builder: (context, state) => const AddFertilisingScreen(),
),
    ],
  );
});