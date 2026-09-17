import 'package:flutter/material.dart';
import 'package:pitayapro/services/moon_phase_service.dart';
import 'dart:math';
import '../../../../core/theme/app_colors.dart';

class MoonPhaseWidget extends StatelessWidget {
  final DateTime date;
  final bool showDetails;
  final double size;

  const MoonPhaseWidget({
    super.key,
    required this.date,
    this.showDetails = true,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final phase = MoonPhaseService.calculateMoonPhase(date);
    final phaseName = MoonPhaseService.getMoonPhaseName(date);
    final illumination = MoonPhaseService.getMoonIllumination(date);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          // Moon Visual
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: MoonPhasePainter(phase: phase),
            ),
          ),
          if (showDetails) ...[
            const SizedBox(height: 8),
            Text(
              phaseName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${illumination.toStringAsFixed(0)}% illuminated',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ✅ CORRECT: Extends CustomPainter
class MoonPhasePainter extends CustomPainter {
  final double phase;

  MoonPhasePainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw shadow/glow
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.grey.shade200
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Calculate illumination
    double illumination = (1 - cos(phase * 2 * pi)) / 2;
    
    // Draw moon base (dark side)
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = Colors.grey.shade800,
    );

    // Draw illuminated portion
    if (illumination > 0.02) {
      if (phase < 0.5) {
        // Waxing (right side illuminated)
        _drawWaxingMoon(canvas, center, radius, illumination);
      } else {
        // Waning (left side illuminated)
        _drawWaningMoon(canvas, center, radius, illumination);
      }
    }

    // Draw craters (simple circles for texture)
    _drawCraters(canvas, center, radius);
  }

  void _drawWaxingMoon(Canvas canvas, Offset center, double radius, double illumination) {
    Paint lightPaint = Paint()..color = Colors.amber.shade100;
    
    if (illumination < 0.5) {
      // Crescent
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        pi * illumination * 2,
        true,
        lightPaint,
      );
    } else {
      // Gibbous to Full
      canvas.drawCircle(center, radius, lightPaint);
      
      // Draw shadow on left side
      double shadowWidth = radius * (1 - illumination) * 2;
      canvas.drawRect(
        Rect.fromLTWH(
          center.dx - radius,
          center.dy - radius,
          shadowWidth,
          radius * 2,
        ),
        Paint()..color = Colors.grey.shade800,
      );
    }
  }

  void _drawWaningMoon(Canvas canvas, Offset center, double radius, double illumination) {
    Paint lightPaint = Paint()..color = Colors.amber.shade100;
    
    if (illumination > 0.5) {
      // Gibbous
      canvas.drawCircle(center, radius, lightPaint);
      
      // Draw shadow on right side
      double shadowWidth = radius * illumination * 2;
      canvas.drawRect(
        Rect.fromLTWH(
          center.dx,
          center.dy - radius,
          shadowWidth,
          radius * 2,
        ),
        Paint()..color = Colors.grey.shade800,
      );
    } else {
      // Crescent
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        pi / 2,
        pi * (1 - illumination) * 2,
        true,
        lightPaint,
      );
    }
  }

  void _drawCraters(Canvas canvas, Offset center, double radius) {
    final craterPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Add a few simple craters
    canvas.drawCircle(Offset(center.dx - radius * 0.3, center.dy - radius * 0.2), radius * 0.15, craterPaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.2, center.dy + radius * 0.3), radius * 0.1, craterPaint);
    canvas.drawCircle(Offset(center.dx - radius * 0.1, center.dy + radius * 0.4), radius * 0.08, craterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}