class Account {
  final String id;
  final String name;
  final String type;
  final double balance;
  final double monthlyIncome;
  final double monthlyExpense;
  final String icon;

  Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.icon,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'balance': balance,
    'monthlyIncome': monthlyIncome,
    'monthlyExpense': monthlyExpense,
    'icon': icon,
  };

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    balance: (json['balance'] as num).toDouble(),
    monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
    monthlyExpense: (json['monthlyExpense'] as num).toDouble(),
    icon: json['icon'] as String,
  );
}
