import 'dart:math';

class MoonPhaseService {
  /// Calculate moon phase (0.0 to 1.0)
  static double calculateMoonPhase(DateTime date) {
    int year = date.year;
    int month = date.month;
    int day = date.day;

    if (month < 3) {
      year--;
      month += 12;
    }

    int a = (year / 100).floor();
    int b = 2 - a + (a / 4).floor();
    int c = (365.25 * year).floor();
    int d = (30.6001 * (month + 1)).floor();

    double jd = b + c + d - 694039.09 + day;
    
    double cycles = jd / 29.5305882;
    double phase = cycles - cycles.floor();

    return phase;
  }

  /// Get moon phase name
  static String getMoonPhaseName(DateTime date) {
    double phase = calculateMoonPhase(date);
    
    if (phase < 0.03 || phase > 0.97) return 'New Moon';
    if (phase < 0.22) return 'Waxing Crescent';
    if (phase < 0.28) return 'First Quarter';
    if (phase < 0.47) return 'Waxing Gibbous';
    if (phase < 0.53) return 'Full Moon';
    if (phase < 0.72) return 'Waning Gibbous';
    if (phase < 0.78) return 'Last Quarter';
    if (phase < 0.97) return 'Waning Crescent';
    
    return 'New Moon';
  }

  /// Get moon illumination percentage
  static double getMoonIllumination(DateTime date) {
    double phase = calculateMoonPhase(date);
    double illumination = (1 - cos(phase * 2 * pi)) / 2;
    return illumination * 100;
  }

  /// Get moon phase icon based on phase
  static String getMoonPhaseIcon(DateTime date) {
    double phase = calculateMoonPhase(date);
    
    if (phase < 0.03 || phase > 0.97) return '🌑';
    if (phase < 0.22) return '🌒';
    if (phase < 0.28) return '🌓';
    if (phase < 0.47) return '🌔';
    if (phase < 0.53) return '🌕';
    if (phase < 0.72) return '🌖';
    if (phase < 0.78) return '🌗';
    if (phase < 0.97) return '🌘';
    
    return '🌑';
  }
}