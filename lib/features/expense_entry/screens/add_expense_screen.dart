import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/expense.dart';
import '../../../core/ui/widgets/feeling_icon.dart';
import '../../../core/providers/expense_provider.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _merchantController = TextEditingController();
  
  UserFeeling? _selectedFeeling;
  ExpenseCategory _selectedCategory = ExpenseCategory.other;
  int _currentStep = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _amountController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  void _nextStep() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
    setState(() => _currentStep = 1);
  }

  void _previousStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
    setState(() => _currentStep = 0);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _selectedFeeling?.color.withOpacity(0.15) ?? Colors.black;

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgColor, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildFeelingStep(),
                    _buildDetailsStep(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: _previousStep,
            )
          else
            const SizedBox(width: 48),
          const Text(
            'LOG EXPENSE',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFeelingStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "How are you feeling?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Select an emotion to start logging.",
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          const SizedBox(height: 48),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: UserFeeling.values.length,
              itemBuilder: (context, index) {
                final feeling = UserFeeling.values[index];
                return FeelingIcon(
                  feeling: feeling,
                  isSelected: _selectedFeeling == feeling,
                  onTap: () {
                    setState(() => _selectedFeeling = feeling);
                    Future.delayed(const Duration(milliseconds: 300), _nextStep);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    final themeColor = _selectedFeeling?.color ?? Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "Spending while feeling ${_selectedFeeling?.nameStr}...",
            style: TextStyle(color: themeColor.withOpacity(0.7), fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: "0.00",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.1)),
              prefixText: "\$ ",
              prefixStyle: const TextStyle(color: Colors.white54, fontSize: 32),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 40),
          _buildMinimalField(
            controller: _merchantController,
            label: "Where did you spend it?",
            hint: "Merchant name",
          ),
          const SizedBox(height: 32),
          const Text(
            "Category",
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ExpenseCategory.values.map((cat) {
              final isCatSelected = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat.nameStr),
                selected: isCatSelected,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedCategory = cat);
                },
                backgroundColor: Colors.white.withOpacity(0.05),
                selectedColor: themeColor.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: isCatSelected ? themeColor : Colors.white60,
                  fontWeight: isCatSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isCatSelected ? themeColor : Colors.transparent,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 60),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text) ?? 0.0;
                if (amount > 0 && _selectedFeeling != null) {
                  ref.read(expenseProvider.notifier).addExpense(
                    title: _merchantController.text.isNotEmpty 
                        ? _merchantController.text 
                        : "Untitled Expense",
                    amount: amount,
                    category: _selectedCategory,
                    feeling: _selectedFeeling,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text(
                "Save Entry",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 14)),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _selectedFeeling?.color ?? Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
