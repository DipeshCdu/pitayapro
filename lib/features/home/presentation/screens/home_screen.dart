import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(context), // ✅ Pass context here
            const SizedBox(height: 16),
            _buildWeatherCard(),
            const SizedBox(height: 20),
            _buildFloweringOverview(context),
            const SizedBox(height: 16),
            _buildTipCard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ─── APP BAR ───────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryDark,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
        onPressed: () {
          // TODO: Open drawer
        },
      ),
      title: const Text(
        'Pitaya Pro',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
              onPressed: () {
                // TODO: Navigate to notifications
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ── GREETING ──────────────────────────────────────────────
  Widget _buildGreeting(BuildContext context) { // ✅ Added BuildContext parameter
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cardGreen,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: const Icon(Icons.person, color: AppColors.primary, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good morning, Ramesh ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Here's your daily farm overview",
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => context.go('/my-farm'), // ✅ Now context is defined!
          icon: const Icon(Icons.agriculture, size: 18),
          label: const Text('My Farm'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }

  // ─── WEATHER CARD ─────────────────────────────────────────
  Widget _buildWeatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    '28°C',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.wb_sunny, color: Colors.amber, size: 40),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Darwin,',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const Text(
                    'Australia',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      // TODO: Refresh weather
                    },
                    child: const Icon(Icons.refresh, color: Colors.white70, size: 18),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Partly Sunny',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'High 31° • Low 24°',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ─ FLOWERING OVERVIEW ────────────────────────────────────
  Widget _buildFloweringOverview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Flowering Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/flowering'),
              child: const Text(
                'View all',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildPlantRow('Dragon Fruit', 'Block 2 • Row 5', 'Flowering', 60, Icons.local_florist, Colors.pink),
        const SizedBox(height: 10),
        _buildPlantRow('Guava', 'Block 1 • Row 3', 'Budding', 40, Icons.eco, Colors.orange),
        const SizedBox(height: 10),
        _buildPlantRow('Papaya', 'Block 3 • Row 2', 'Harvested', 20, Icons.yard, Colors.green),
      ],
    );
  }

  Widget _buildPlantRow(
      String name, String location, String status, int percent,
      IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                child: LinearProgressIndicator(
                  value: percent / 100,
                  backgroundColor: AppColors.divider,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$percent%',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── TIP OF THE DAY ───────────────────────────────────────
  Widget _buildTipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGreen,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline, color: AppColors.success, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tip of the day',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ensure proper irrigation during flowering for better fruit set.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── BOTTOM NAVIGATION ─────────────────────────────────────
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/my-farm');
              break;
            case 1:
              context.go('/flowering');
              break;
            case 2:
              // TODO: Inputs screen
              break;
            case 3:
              // TODO: Soil Tests screen
              break;
            case 4:
              // TODO: Insights screen
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'My Farm'),
          BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: 'Flowering'),
          BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Inputs'),
          BottomNavigationBarItem(icon: Icon(Icons.biotech), label: 'Soil Tests'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Insights'),
        ],
      ),
    );
  }
}