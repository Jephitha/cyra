abstract final class CycleConstants {
  static const double minCycleLength = 21;
  static const double maxCycleLength = 45;
  static const int averageCycleLength = 28;
  static const int typicalPeriodLength = 5;
  static const double normalLutealPhaseMin = 10;
  static const double normalLutealPhaseMax = 16;
  static const int fertileWindowOpenDay = 8;
  static const int fertileWindowCloseDay = 19;
  static const double bbtOvulationRiseThreshold = 0.2;
  static const int maxTrackedCyclesForPrediction = 12;
  static const int minCyclesForPrediction = 3;

  static const Map<int, String> flowLabels = {
    1: 'Light',
    2: 'Medium',
    3: 'Heavy',
    4: 'Very Heavy',
    5: 'Spotting',
  };

  static const List<String> mucusTypes = ['Dry', 'Sticky', 'Creamy', 'Egg White', 'Watery'];

  static const List<String> cyclePhases = ['Menstrual', 'Follicular', 'Ovulatory', 'Luteal'];

  static const Map<String, int> phaseDays = {
    'Menstrual': 5,
    'Follicular': 9,
    'Ovulatory': 4,
    'Luteal': 14,
  };

  static const Map<int, String> painLevels = {
    0: 'None',
    1: 'Mild',
    2: 'Moderate',
    3: 'Moderate-Severe',
    4: 'Severe',
    5: 'Debilitating',
  };
}
