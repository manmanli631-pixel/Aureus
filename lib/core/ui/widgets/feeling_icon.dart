import 'package:flutter/material.dart';
import '../../../core/models/expense.dart';

class FeelingIcon extends StatelessWidget {
  final UserFeeling feeling;
  final bool isSelected;
  final VoidCallback onTap;

  const FeelingIcon({
    super.key,
    required this.feeling,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? feeling.color : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? feeling.color : Colors.white10,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: feeling.color.withOpacity(0.3), blurRadius: 15, spreadRadius: 1)]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              feeling.icon,
              size: 48,
              color: isSelected ? Colors.white : feeling.color,
            ),
            const SizedBox(height: 12),
            Text(
              feeling.nameStr,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
