import '../../../core/models/task.dart';

class FocusService {
  Future<List<UserTask>> getActiveTasks() async {
    // Return mock data directly as requested
    return [
      UserTask(
        id: '1',
        title: 'Scanning 100 Pokémon cards',
        description: 'Inventory management for TCG project',
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 10)),
        isActive: true,
        progress: 0.24,
      ),
    ];
  }

  Future<void> updateTaskProgress(String taskId, double progress) async {
    // Mock update
    print('Mock update task $taskId to $progress');
  }

  Future<void> completeMicroQuest(String taskId) async {
    // Mock complete
    print('Mock complete quest $taskId');
  }
}
