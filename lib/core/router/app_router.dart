import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pitayapro/features/flowering_event/presentation/screens/flowering_detail_screen.dart';

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
import '../../features/inputs/presentation/screens/fertilising_list_screen.dart';
import '../../features/inputs/presentation/screens/add_fertilising_screen.dart';
import '../../features/inputs/presentation/screens/fertilising_detail_screen.dart';
import '../../features/inputs/presentation/screens/edit_fertilising_screen.dart';
import '../../features/soil_tests/presentation/screens/soil_test_list_screen.dart';
import '../../features/soil_tests/presentation/screens/add_soil_test_screen.dart';
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      // Auth
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),

      // Home
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

      // My Farm
      GoRoute(path: '/my-farm', builder: (context, state) => const FarmDashboardScreen()),
      GoRoute(path: '/my-farm/edit', builder: (context, state) => const EditFarmScreen()),
      GoRoute(path: '/my-farm/blocks', builder: (context, state) => const BlocksListScreen()),
      GoRoute(
        path: '/my-farm/map',
        builder: (context, state) {
          final focusBlockId = state.extra as String?;
          return FarmMapScreen(focusBlockId: focusBlockId);
        },
      ),

      // Flowering
      GoRoute(path: '/flowering', builder: (context, state) => const FloweringListScreen()),
      GoRoute(path: '/flowering/add', builder: (context, state) => const AddFloweringScreen()),
      GoRoute(
        path: '/flowering/edit/:id',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return EditFloweringScreen(eventId: eventId);
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
  path: '/inputs/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return FertilisingDetailScreen(recordId: id);
  },
),
GoRoute(
  path: '/inputs/edit/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return EditFertilisingScreen(recordId: id);
  },
),


      // Inputs (Fertilising)
      GoRoute(path: '/inputs', builder: (context, state) => const FertilisingListScreen()),
      GoRoute(path: '/inputs/add', builder: (context, state) => const AddFertilisingScreen()),
      GoRoute(
  path: '/soil-tests',
  builder: (context, state) => const SoilTestListScreen(),
),
GoRoute(
  path: '/soil-tests/add',
  builder: (context, state) => const AddSoilTestScreen(),
),
    ],
  );
});