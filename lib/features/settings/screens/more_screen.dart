import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../focus/providers/focus_provider.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusState = ref.watch(focusStateProvider);
    final focusNotifier = ref.read(focusStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('COMMAND CENTER'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSectionHeader('FINANCIAL TUNING'),
            _buildSettingCard(
              context,
              title: 'My Hourly Value',
              subtitle: 'Current: \$${focusState.hourlyRate.toStringAsFixed(0)}/hr',
              icon: Icons.attach_money,
              child: Slider(
                value: focusState.hourlyRate,
                min: 20,
                max: 1000,
                divisions: 98,
                onChanged: (val) => focusNotifier.setHourlyRate(val),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('PRODUCTIVITY FILTERS'),
            _buildSettingCard(
              context,
              title: 'Anti-Waste Filter',
              subtitle: 'Hide "Waste" logs from main feed',
              icon: Icons.auto_delete_outlined,
              child: Switch(
                value: focusState.antiWasteFilter,
                onChanged: (val) => focusNotifier.setAntiWasteFilter(val),
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingCard(
              context,
              title: 'Focus Sensitivity',
              subtitle: 'Aggressiveness of the Waste Orb',
              icon: Icons.track_changes,
              child: Slider(
                value: focusState.focusSensitivity,
                min: 0,
                max: 1,
                onChanged: (val) => focusNotifier.setFocusSensitivity(val),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('ACCOUNT'),
            ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.white70),
              title: const Text('Profile Settings'),
              trailing: const Icon(Icons.chevron_right, color: Colors.white38),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.notifications_none, color: Colors.white70),
              title: const Text('Notifications'),
              trailing: const Icon(Icons.chevron_right, color: Colors.white38),
              onTap: () {},
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'AUREUS v2.0.0',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.1),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
