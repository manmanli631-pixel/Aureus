import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/dashboard/screens/today_screen.dart';
import '../../features/balance/screens/balance_screen.dart';
import '../../features/budget/screens/wishlist_screen.dart';
import '../../features/reports/screens/reports_screen.dart';
import '../../features/settings/screens/more_screen.dart';
import '../../features/focus/screens/focus_screen.dart';
import '../ui/main_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/today',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/today',
            builder: (context, state) => const TodayScreen(),
          ),
          GoRoute(
            path: '/focus',
            builder: (context, state) => const FocusScreen(),
          ),
          GoRoute(
            path: '/focus-mode',
            redirect: (context, state) => '/focus',
          ),
          GoRoute(
            path: '/balance',
            builder: (context, state) => const BalanceScreen(),
          ),
          GoRoute(
            path: '/budget',
            builder: (context, state) => const WishlistScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/more',
            builder: (context, state) => const MoreScreen(),
          ),
        ],
      ),
    ],
  );
});
