class Budget {
  final String id;
  final String userId;
  final String category;
  final String icon;
  final double limit;
  final double spent;
  final DateTime createdAt;
  final DateTime updatedAt;

  Budget({
    required this.id,
    required this.userId,
    required this.category,
    required this.icon,
    required this.limit,
    required this.spent,
    required this.createdAt,
    required this.updatedAt,
  });

  double get remaining => limit - spent;
  double get percentage => (spent / limit * 100).clamp(0, 100);
  bool get isOverBudget => spent > limit;

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'category': category,
    'icon': icon,
    'limit': limit,
    'spent': spent,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
    id: json['id'] as String,
    userId: json['userId'] as String,
    category: json['category'] as String,
    icon: json['icon'] as String,
    limit: (json['limit'] as num).toDouble(),
    spent: (json['spent'] as num).toDouble(),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Budget copyWith({
    String? id,
    String? userId,
    String? category,
    String? icon,
    double? limit,
    double? spent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Budget(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    category: category ?? this.category,
    icon: icon ?? this.icon,
    limit: limit ?? this.limit,
    spent: spent ?? this.spent,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
