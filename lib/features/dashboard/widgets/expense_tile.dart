import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;

  const ExpenseTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final amountColor = expense.isIncome
        ? const Color(0xFF32D74B)
        : const Color(0xFFFF453A);
    final amountPrefix = expense.isIncome ? '+' : '-';

    return Dismissible(
      key: Key(expense.id),
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        color: Colors.amber.withOpacity(0.2),
        child: const Icon(Icons.push_pin, color: Colors.amber),
      ),
      secondaryBackground: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        color: Colors.purple.withOpacity(0.2),
        child: const Icon(Icons.edit, color: Colors.purpleAccent),
      ),
      onDismissed: (direction) {
        // Implement Pin or Edit logic
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: expense.category.color.withOpacity(0.1),
                child: Icon(
                  expense.category.icon,
                  color: expense.category.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${expense.category.nameStr} • ${DateFormat('hh:mm a').format(expense.date)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$amountPrefix\$${expense.amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: amountColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (expense.feeling != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Icon(
                        expense.feeling!.icon,
                        size: 14,
                        color: expense.feeling!.color.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
