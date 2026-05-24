import 'package:flutter/material.dart';

enum ExpenseCategory {
  dining,
  electronics,
  income,
  transport,
  groceries,
  housing,
  other
}

extension ExpenseCategoryExt on ExpenseCategory {
  String get nameStr {
    switch (this) {
      case ExpenseCategory.dining: return 'Dining';
      case ExpenseCategory.electronics: return 'Electronics';
      case ExpenseCategory.income: return 'Income';
      case ExpenseCategory.transport: return 'Transport';
      case ExpenseCategory.groceries: return 'Groceries';
      case ExpenseCategory.housing: return 'Housing';
      case ExpenseCategory.other: return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.dining: return Icons.restaurant;
      case ExpenseCategory.electronics: return Icons.shopping_bag;
      case ExpenseCategory.income: return Icons.account_balance_wallet;
      case ExpenseCategory.transport: return Icons.directions_car;
      case ExpenseCategory.groceries: return Icons.shopping_cart;
      case ExpenseCategory.housing: return Icons.home;
      case ExpenseCategory.other: return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.dining: return Colors.orange;
      case ExpenseCategory.electronics: return Colors.blue;
      case ExpenseCategory.income: return Colors.green;
      case ExpenseCategory.transport: return Colors.purple;
      case ExpenseCategory.groceries: return Colors.cyan;
      case ExpenseCategory.housing: return Colors.indigo;
      case ExpenseCategory.other: return Colors.grey;
    }
  }
}

enum UserFeeling {
  happy,
  stressed,
  bored,
  impulsive,
  wise,
  sad
}

extension UserFeelingExt on UserFeeling {
  String get nameStr {
    switch (this) {
      case UserFeeling.happy: return 'Happy';
      case UserFeeling.stressed: return 'Stressed';
      case UserFeeling.bored: return 'Bored';
      case UserFeeling.impulsive: return 'Impulsive';
      case UserFeeling.wise: return 'Wise';
      case UserFeeling.sad: return 'Sad';
    }
  }

  IconData get icon {
    switch (this) {
      case UserFeeling.happy: return Icons.sentiment_very_satisfied;
      case UserFeeling.stressed: return Icons.sentiment_very_dissatisfied;
      case UserFeeling.bored: return Icons.sentiment_neutral;
      case UserFeeling.impulsive: return Icons.bolt;
      case UserFeeling.wise: return Icons.psychology;
      case UserFeeling.sad: return Icons.sentiment_dissatisfied;
    }
  }

  Color get color {
    switch (this) {
      case UserFeeling.happy: return Colors.amber;
      case UserFeeling.stressed: return const Color(0xFFFF453A);
      case UserFeeling.bored: return Colors.blueGrey;
      case UserFeeling.impulsive: return Colors.purpleAccent;
      case UserFeeling.wise: return Colors.teal;
      case UserFeeling.sad: return Colors.blue;
    }
  }
}

class Expense {
  final String id;
  final String title;
  final ExpenseCategory category;
  final double amount;
  final DateTime date;
  final bool isIncome;
  final UserFeeling? feeling;

  Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    this.isIncome = false,
    this.feeling,
  });
}

// Dummy data
final dummyExpenses = [
  Expense(
    id: '1',
    title: 'Starbucks Coffee',
    category: ExpenseCategory.dining,
    amount: 12.50,
    date: DateTime.now(),
  ),
  Expense(
    id: '2',
    title: 'Apple Store',
    category: ExpenseCategory.electronics,
    amount: 129.50,
    date: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Expense(
    id: '3',
    title: 'Salary Deposit',
    category: ExpenseCategory.income,
    amount: 4200.00,
    date: DateTime.now().subtract(const Duration(hours: 4)),
    isIncome: true,
  ),
  Expense(
    id: '4',
    title: 'Uber Trip',
    category: ExpenseCategory.transport,
    amount: 24.20,
    date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
  ),
  Expense(
    id: '5',
    title: 'Whole Foods',
    category: ExpenseCategory.groceries,
    amount: 30.00,
    date: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
  ),
  Expense(
    id: '6',
    title: 'Monthly Rent',
    category: ExpenseCategory.housing,
    amount: 1200.00,
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
];
