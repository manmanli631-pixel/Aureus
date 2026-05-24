import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/opportunity_cost_widget.dart';
import '../widgets/dopamine_bridge_widget.dart';
import '../widgets/virtual_cofounder_widget.dart';
import '../widgets/time_audit_card.dart';
import '../widgets/cosmic_balance_widget.dart';
import '../widgets/living_hourglass_widget.dart';
import '../widgets/rpg_stat_dashboard.dart';
import '../providers/focus_provider.dart';

class FocusScreen extends ConsumerWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black, // Force black for Focus Mode as requested
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aureus Focus',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'COMMAND CENTER',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  _buildFocusToggle(ref),
                ],
              ),
              const SizedBox(height: 32),
              const OpportunityCostWidget(),
              const SizedBox(height: 24),
              const Text(
                'VISUAL FLOW',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              const CosmicBalanceWidget(),
              const SizedBox(height: 24),
              const LivingHourglassWidget(),
              const SizedBox(height: 24),
              const RPGStatDashboard(),
              const SizedBox(height: 32),
              const Text(
                'DENSITY-BASED FOCUS (HK)',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              _buildDensityHeatmap(context),
              const SizedBox(height: 32),
              const TimeAuditCard(),
              const SizedBox(height: 24),
              const VirtualCoFounderWidget(),
              const SizedBox(height: 24),
              const DopamineBridgeWidget(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDensityHeatmap(BuildContext context) {
    final spots = [
      {'name': 'Starbucks Central', 'density': 0.8, 'suggestion': 'Busy'},
      {'name': 'Sheung Wan Co-work', 'density': 0.2, 'suggestion': 'Optimal'},
      {'name': 'Pacific Place', 'density': 0.6, 'suggestion': 'Fair'},
      {'name': 'TST Library', 'density': 0.4, 'suggestion': 'Good'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.map_outlined, color: Colors.blueAccent, size: 18),
              const SizedBox(width: 8),
              const Text(
                'LIVE FOCUS MAP',
                style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                'HONG KONG',
                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...spots.map((spot) {
            final density = spot['density'] as double;
            final color = density > 0.7 ? Colors.redAccent : (density > 0.4 ? Colors.orangeAccent : Colors.greenAccent);
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(spot['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(spot['suggestion'] as String, style: TextStyle(color: color.withOpacity(0.7), fontSize: 10)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Stack(
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: density,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(color: color.withOpacity(0.2), blurRadius: 4, spreadRadius: 1),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(density * 100).toInt()}%',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.blueAccent, size: 16),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Try Sheung Wan today. Lower density = 1.5x higher Focus Score.",
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusToggle(WidgetRef ref) {
    final isFocus = ref.watch(focusStateProvider).isFocusMode;
    return GestureDetector(
      onTap: () => ref.read(focusStateProvider.notifier).toggleFocusMode(),
      child: Container(
        width: 100,
        height: 44,
        decoration: BoxDecoration(
          color: isFocus ? const Color(0xFFFFD700) : Colors.white10,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isFocus ? const Color(0xFFFFD700) : Colors.white24,
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: isFocus ? 56 : 4,
              top: 4,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isFocus ? Colors.black : Colors.white30,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFocus ? Icons.bolt : Icons.power_settings_new,
                  color: isFocus ? const Color(0xFFFFD700) : Colors.white,
                  size: 20,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: isFocus ? 0 : 40, right: isFocus ? 40 : 0),
                child: Text(
                  isFocus ? 'ON' : 'OFF',
                  style: TextStyle(
                    color: isFocus ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
