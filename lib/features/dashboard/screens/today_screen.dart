import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/expense.dart';
import '../../../core/providers/expense_provider.dart';
import '../widgets/expense_tile.dart';
import '../widgets/guilt_gauge_widget.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final startOfWeek = today.subtract(Duration(days: now.weekday - 1));

    double calculateTotal(List<Expense> list) {
      return list.fold(0.0, (sum, e) => sum + (e.isIncome ? 0 : e.amount));
    }

    final todayExpenses = expenses.where((e) => 
      e.date.isAfter(today) || e.date.isAtSameMomentAs(today)).toList();
    
    final yesterdayExpenses = expenses.where((e) => 
      e.date.isAfter(yesterday) && e.date.isBefore(today)).toList();

    final thisWeekExpenses = expenses.where((e) => 
      e.date.isAfter(startOfWeek) && e.date.isBefore(yesterday)).toList();

    final otherExpenses = expenses.where((e) => 
      e.date.isBefore(startOfWeek)).toList();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  const GuiltGaugeWidget(),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        if (todayExpenses.isNotEmpty) ...[
                          _buildSectionHeader(context, 'TODAY', calculateTotal(todayExpenses)),
                          ...todayExpenses.map((e) => ExpenseTile(expense: e)),
                          const SizedBox(height: 24),
                        ],
                        
                        if (yesterdayExpenses.isNotEmpty) ...[
                          _buildSectionHeader(context, 'YESTERDAY', calculateTotal(yesterdayExpenses)),
                          ...yesterdayExpenses.map((e) => ExpenseTile(expense: e)),
                          const SizedBox(height: 24),
                        ],

                        if (thisWeekExpenses.isNotEmpty) ...[
                          _buildSectionHeader(context, 'THIS WEEK', calculateTotal(thisWeekExpenses)),
                          ...thisWeekExpenses.map((e) => ExpenseTile(expense: e)),
                          const SizedBox(height: 24),
                        ],
                            
                        if (otherExpenses.isNotEmpty) ...[
                          _buildSectionHeader(context, 'OLDER', calculateTotal(otherExpenses)),
                          ...otherExpenses.map((e) => ExpenseTile(expense: e)),
                        ],
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aureus Hub',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 28,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEEE, MMM d').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: const Icon(Icons.person_outline, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 12,
                  color: Colors.white38,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
          Text(
            'TOTAL: \$${total.toStringAsFixed(2)}',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
