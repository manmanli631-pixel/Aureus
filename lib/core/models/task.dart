class UserTask {
  final String id;
  final String title;
  final String description;
  final DateTime lastUpdated;
  final bool isActive;
  final double progress; // 0.0 to 1.0

  UserTask({
    required this.id,
    required this.title,
    required this.description,
    required this.lastUpdated,
    this.isActive = false,
    this.progress = 0.0,
  });

  UserTask copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? lastUpdated,
    bool? isActive,
    double? progress,
  }) {
    return UserTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isActive: isActive ?? this.isActive,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'last_updated': lastUpdated.toIso8601String(),
      'is_active': isActive,
      'progress': progress,
    };
  }

  factory UserTask.fromJson(Map<String, dynamic> json) {
    return UserTask(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      lastUpdated: DateTime.parse(json['last_updated']),
      isActive: json['is_active'] ?? false,
      progress: (json['progress'] ?? 0.0).toDouble(),
    );
  }
}
