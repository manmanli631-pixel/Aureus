import 'package:flutter/material.dart';

class AppColors {
  // Aureus 2.0 Palette
  static const Color primary = Color(0xFFFFD700); // Aureus Gold
  static const Color background = Color(0xFF0D0D0D); // Deep Charcoal/Black
  static const Color surface = Color(0xFF1A1A1A); // Softened Black for cards
  static const Color waste = Color(0xFFFF4B4B); // Muted Red
  static const Color focus = Color(0xFFBB86FC); // Soft Purple
  
  static const Color primaryText = Colors.white;
  static const Color secondaryText = Colors.white70;
  static const Color divider = Color(0xFF2C2C2E);
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFFCC00);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
}

class AppRadius {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
}
