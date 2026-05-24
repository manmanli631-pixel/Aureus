import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/focus_service.dart';
import '../../../core/models/task.dart';

final focusServiceProvider = Provider((ref) => FocusService());

final focusStateProvider = StateNotifierProvider<FocusNotifier, FocusState>((ref) {
  final service = ref.watch(focusServiceProvider);
  return FocusNotifier(service);
});

class FocusState {
  final bool isFocusMode;
  final UserTask? activeTask;
  final double hourlyRate;
  final Duration focusDuration;
  final Duration idleDuration;
  final double potentialEquity;
  final double opportunityLoss;
  final bool antiWasteFilter;
  final double focusSensitivity;

  FocusState({
    this.isFocusMode = false,
    this.activeTask,
    this.hourlyRate = 150.0,
    this.focusDuration = Duration.zero,
    this.idleDuration = Duration.zero,
    this.potentialEquity = 0.0,
    this.opportunityLoss = 0.0,
    this.antiWasteFilter = false,
    this.focusSensitivity = 0.5,
  });

  FocusState copyWith({
    bool? isFocusMode,
    UserTask? activeTask,
    double? hourlyRate,
    Duration? focusDuration,
    Duration? idleDuration,
    double? potentialEquity,
    double? opportunityLoss,
    bool? antiWasteFilter,
    double? focusSensitivity,
  }) {
    return FocusState(
      isFocusMode: isFocusMode ?? this.isFocusMode,
      activeTask: activeTask ?? this.activeTask,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      focusDuration: focusDuration ?? this.focusDuration,
      idleDuration: idleDuration ?? this.idleDuration,
      potentialEquity: potentialEquity ?? this.potentialEquity,
      opportunityLoss: opportunityLoss ?? this.opportunityLoss,
      antiWasteFilter: antiWasteFilter ?? this.antiWasteFilter,
      focusSensitivity: focusSensitivity ?? this.focusSensitivity,
    );
  }
}

class FocusNotifier extends StateNotifier<FocusState> {
  final FocusService _service;
  Timer? _timer;

  FocusNotifier(this._service) : super(FocusState()) {
    _loadInitialData();
    _startTimer();
  }

  Future<void> _loadInitialData() async {
    final tasks = await _service.getActiveTasks();
    if (tasks.isNotEmpty) {
      state = state.copyWith(activeTask: tasks.first);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isFocusMode) {
        final newDuration = state.focusDuration + const Duration(seconds: 1);
        final equity = (newDuration.inSeconds / 3600) * state.hourlyRate;
        state = state.copyWith(
          focusDuration: newDuration,
          potentialEquity: equity,
        );
      } else {
        final newIdle = state.idleDuration + const Duration(seconds: 1);
        final loss = (newIdle.inSeconds / 3600) * state.hourlyRate;
        state = state.copyWith(
          idleDuration: newIdle,
          opportunityLoss: loss,
        );
      }
    });
  }

  void toggleFocusMode() {
    state = state.copyWith(isFocusMode: !state.isFocusMode);
  }

  void setHourlyRate(double rate) {
    state = state.copyWith(hourlyRate: rate);
  }

  void setAntiWasteFilter(bool value) {
    state = state.copyWith(antiWasteFilter: value);
  }

  void setFocusSensitivity(double value) {
    state = state.copyWith(focusSensitivity: value);
  }

  Future<void> completeTask() async {
    if (state.activeTask != null) {
      await _service.completeMicroQuest(state.activeTask!.id);
      state = state.copyWith(activeTask: null, isFocusMode: false);
      // Refresh task list or load next
      _loadInitialData();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
