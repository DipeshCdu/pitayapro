import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/my_farm/presentation/screens/farm_dashboard_screen.dart';
import '../../features/my_farm/presentation/screens/farm_map_screen.dart';
import '../../features/my_farm/presentation/screens/blocks_list_screen.dart';
import '../../features/my_farm/presentation/screens/edit_farm_screen.dart';
import '../../features/flowering/presentation/screens/flowering_list_screen.dart';
import '../../features/flowering/presentation/screens/add_flowering_screen.dart';
import '../../features/flowering/presentation/screens/edit_flowering_screen.dart';
import '../../features/flowering_event/presentation/screens/flowering_detail_screen.dart';
import '../../features/inputs/presentation/screens/fertilising_list_screen.dart';
import '../../features/inputs/presentation/screens/add_fertilising_screen.dart';
import '../../features/inputs/presentation/screens/fertilising_detail_screen.dart';
import '../../features/inputs/presentation/screens/edit_fertilising_screen.dart';
import '../../features/soil_tests/presentation/screens/soil_test_list_screen.dart';
import '../../features/soil_tests/presentation/screens/add_soil_test_screen.dart';
import '../../features/soil_tests/presentation/screens/soil_test_detail_screen.dart';
import '../../features/insights/presentation/screens/insights_screen.dart';
import '../../features/pruning/presentation/screens/pruning_list_screen.dart';
import '../../features/pruning/presentation/screens/add_pruning_screen.dart';
import '../../features/pruning/presentation/screens/pruning_detail_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      // 👇 UPDATED LOGIC: Use isAuthenticated boolean instead of AuthStatus enum
      final isAuthenticated = auth.isAuthenticated;
      final loc = state.matchedLocation;
      final isAuthRoute = loc == '/login' || loc == '/register';

      // If not authenticated and trying to go to a protected route, send to login
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // If authenticated and trying to go to login/register, send to home
      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),

      GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),

      GoRoute(path: '/my-farm', builder: (c, s) => const FarmDashboardScreen()),
      GoRoute(path: '/my-farm/edit', builder: (c, s) => const EditFarmScreen()),
      GoRoute(
        path: '/my-farm/blocks',
        builder: (c, s) => const BlocksListScreen(),
      ),
      GoRoute(
        path: '/my-farm/map',
        builder: (c, s) {
          final focusBlockId = s.extra as String?;
          return FarmMapScreen(focusBlockId: focusBlockId);
        },
      ),

      GoRoute(
        path: '/flowering',
        builder: (c, s) => const FloweringListScreen(),
      ),
      GoRoute(
        path: '/flowering/add',
        builder: (c, s) => const AddFloweringScreen(),
      ),
      GoRoute(
        path: '/flowering/edit/:id',
        builder: (c, s) =>
            EditFloweringScreen(eventId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/flowering/:id',
        builder: (c, s) =>
            FloweringDetailScreen(eventId: s.pathParameters['id']!),
      ),

      GoRoute(
        path: '/inputs',
        builder: (c, s) => const FertilisingListScreen(),
      ),
      GoRoute(
        path: '/inputs/add',
        builder: (c, s) => const AddFertilisingScreen(),
      ),
      GoRoute(
        path: '/inputs/edit/:id',
        builder: (c, s) =>
            EditFertilisingScreen(recordId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/inputs/:id',
        builder: (c, s) =>
            FertilisingDetailScreen(recordId: s.pathParameters['id']!),
      ),

      GoRoute(
        path: '/soil-tests',
        builder: (c, s) => const SoilTestListScreen(),
      ),
      GoRoute(
        path: '/soil-tests/add',
        builder: (c, s) => const AddSoilTestScreen(),
      ),
      GoRoute(
        path: '/soil-tests/:id',
        builder: (c, s) =>
            SoilTestDetailScreen(recordId: s.pathParameters['id']!),
      ),

      GoRoute(path: '/insights', builder: (c, s) => const InsightsScreen()),

      GoRoute(path: '/pruning', builder: (c, s) => const PruningListScreen()),
      GoRoute(
        path: '/pruning/add',
        builder: (c, s) => const AddPruningScreen(),
      ),
      GoRoute(
        path: '/pruning/:id',
        builder: (c, s) =>
            PruningDetailScreen(recordId: s.pathParameters['id']!),
      ),
    ],
  );
});