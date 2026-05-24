import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/time_tracking_provider.dart';

class TimeAuditCard extends ConsumerWidget {
  const TimeAuditCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handler = ref.watch(timeTrackingProvider);
    final ratio = handler.ratio;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Time Audit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Goal: ${(handler.goalPercentage * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSegmentedProgressBar(context, ratio),
            const SizedBox(height: 16),
            _buildTimeStats(context, handler),
            const SizedBox(height: 20),
            const Divider(color: Colors.white10),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLogButton(
                  context,
                  ref,
                  icon: Icons.trending_up,
                  label: '15m Value',
                  color: Colors.greenAccent,
                  category: TimeCategory.highValue,
                ),
                _buildLogButton(
                  context,
                  ref,
                  icon: Icons.trending_down,
                  label: '15m Waste',
                  color: Colors.redAccent,
                  category: TimeCategory.waste,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedProgressBar(BuildContext context, double ratio) {
    return Container(
      height: 12,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Row(
          children: [
            Expanded(
              flex: (ratio * 100).toInt(),
              child: Container(color: Colors.greenAccent),
            ),
            Expanded(
              flex: ((1 - ratio) * 100).toInt(),
              child: Container(color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeStats(BuildContext context, TimeTrackingHandler handler) {
    String format(Duration d) => '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('HIGH VALUE', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
            Text(format(handler.highValueTime), style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('WASTE', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
            Text(format(handler.wasteTime), style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildLogButton(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String label,
    required Color color,
    required TimeCategory category,
  }) {
    return InkWell(
      onTap: () => ref.read(timeTrackingProvider).logTime(category),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
