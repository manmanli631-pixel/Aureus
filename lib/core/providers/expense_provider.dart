import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';
import 'package:uuid/uuid.dart';

final expenseProvider = StateNotifierProvider<ExpenseNotifier, List<Expense>>((ref) {
  return ExpenseNotifier();
});

class ExpenseNotifier extends StateNotifier<List<Expense>> {
  ExpenseNotifier() : super(dummyExpenses);

  void addExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
    UserFeeling? feeling,
    bool isIncome = false,
  }) {
    final newExpense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      category: category,
      date: DateTime.now(),
      feeling: feeling,
      isIncome: isIncome,
    );
    
    state = [newExpense, ...state];
  }

  void removeExpense(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  String getEmotionalSummary() {
    final last10 = state.take(10).toList();
    
    double stressedTotal = 0;
    int stressedCount = 0;
    double happyTotal = 0;
    int happyCount = 0;

    for (var e in last10) {
      if (e.feeling == UserFeeling.stressed) {
        stressedTotal += e.amount;
        stressedCount++;
      } else if (e.feeling == UserFeeling.happy) {
        happyTotal += e.amount;
        happyCount++;
      }
    }

    final stressedAvg = stressedCount > 0 ? stressedTotal / stressedCount : 0.0;
    final happyAvg = happyCount > 0 ? happyTotal / happyCount : 0.0;

    if (stressedCount == 0 && happyCount == 0) {
      return "No recent 'Stressed' or 'Happy' transactions found.";
    }

    final comparison = stressedAvg > happyAvg 
      ? "You spend \$${(stressedAvg - happyAvg).toStringAsFixed(2)} more on average when Stressed." 
      : "You spend \$${(happyAvg - stressedAvg).toStringAsFixed(2)} more on average when Happy.";

    return "Stressed Avg: \$${stressedAvg.toStringAsFixed(2)} vs Happy Avg: \$${happyAvg.toStringAsFixed(2)}. $comparison";
  }

  Map<String, dynamic> suggestCategoryAndEmotion(String title) {
    final lowercaseTitle = title.toLowerCase();
    
    // Check history for matches
    for (var expense in state) {
      if (expense.title.toLowerCase().contains(lowercaseTitle) || 
          lowercaseTitle.contains(expense.title.toLowerCase())) {
        return {
          'category': expense.category,
          'feeling': expense.feeling,
        };
      }
    }

    // Default suggestions based on keywords
    if (lowercaseTitle.contains('coffee') || lowercaseTitle.contains('starbucks')) {
      return {'category': ExpenseCategory.dining, 'feeling': UserFeeling.happy};
    } else if (lowercaseTitle.contains('uber') || lowercaseTitle.contains('taxi')) {
      return {'category': ExpenseCategory.transport, 'feeling': UserFeeling.stressed};
    } else if (lowercaseTitle.contains('rent')) {
      return {'category': ExpenseCategory.housing, 'feeling': UserFeeling.wise};
    }

    return {
      'category': ExpenseCategory.other,
      'feeling': UserFeeling.happy,
    };
  }
}
