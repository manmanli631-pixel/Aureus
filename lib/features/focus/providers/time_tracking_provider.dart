import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TimeCategory { highValue, waste }

class TimeTrackingHandler extends ChangeNotifier {
  Duration _highValueTime = const Duration(hours: 4, minutes: 30);
  Duration _wasteTime = const Duration(hours: 1, minutes: 15);
  final double _goalPercentage = 0.75; // 75% High Value goal

  Duration get highValueTime => _highValueTime;
  Duration get wasteTime => _wasteTime;
  double get goalPercentage => _goalPercentage;

  double get ratio {
    final totalSeconds = _highValueTime.inSeconds + _wasteTime.inSeconds;
    if (totalSeconds == 0) return 0.0;
    return _highValueTime.inSeconds / totalSeconds;
  }

  void logTime(TimeCategory category, {int minutes = 15}) {
    final duration = Duration(minutes: minutes);
    if (category == TimeCategory.highValue) {
      _highValueTime += duration;
    } else {
      _wasteTime += duration;
    }
    notifyListeners();
    // In production, this would also sync to Supabase
  }

  void reset() {
    _highValueTime = Duration.zero;
    _wasteTime = Duration.zero;
    notifyListeners();
  }
}

final timeTrackingProvider = ChangeNotifierProvider((ref) => TimeTrackingHandler());
