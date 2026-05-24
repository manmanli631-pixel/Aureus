import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/focus_provider.dart';

class RPGStatDashboard extends ConsumerWidget {
  const RPGStatDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusState = ref.watch(focusStateProvider);
    
    // Mock mapping for demonstration
    // In a real app, these would come from categorized time logs
    final double atk = (focusState.focusDuration.inMinutes / 60.0).clamp(0, 10);
    final double intelligence = (atk * 0.7).clamp(0, 10);
    final double def = 5.0; // Maintenance
    final double spi = 4.0; // Fun
    final double tox = (focusState.idleDuration.inMinutes / 30.0).clamp(0, 10);

    final showGlitch = tox > 5.0;

    return Stack(
      children: [
        Container(
          height: 350,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0D),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withOpacity(0.05),
                blurRadius: 20,
                spreadRadius: 1,
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "SYSTEM STATS // BETA",
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  if (showGlitch)
                    const Text(
                      "CRITICAL TOXICITY",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RadarChart(
                  RadarChartData(
                    dataSets: [
                      RadarDataSet(
                        fillColor: Colors.cyan.withOpacity(0.2),
                        borderColor: Colors.cyanAccent,
                        entryRadius: 3,
                        dataEntries: [
                          RadarEntry(value: atk),
                          RadarEntry(value: intelligence),
                          RadarEntry(value: def),
                          RadarEntry(value: spi),
                          RadarEntry(value: tox),
                        ],
                      ),
                    ],
                    radarBackgroundColor: Colors.transparent,
                    borderData: FlBorderData(show: false),
                    radarBorderData: const BorderSide(color: Colors.white10, width: 1),
                    gridBorderData: const BorderSide(color: Colors.white10, width: 1),
                    tickBorderData: const BorderSide(color: Colors.transparent),
                    ticksTextStyle: const TextStyle(color: Colors.transparent),
                    getTitle: (index, angle) {
                      switch (index) {
                        case 0: return const RadarChartTitle(text: 'ATK');
                        case 1: return const RadarChartTitle(text: 'INT');
                        case 2: return const RadarChartTitle(text: 'DEF');
                        case 3: return const RadarChartTitle(text: 'SPI');
                        case 4: return const RadarChartTitle(text: 'TOX');
                        default: return const RadarChartTitle(text: '');
                      }
                    },
                    titleTextStyle: const TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildStatBar("TOTAL POTENTIAL", atk + intelligence + def + spi - tox),
            ],
          ),
        ),
        if (showGlitch)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: GlitchPainter(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatBar(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8)),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: (value / 40).clamp(0, 1),
            backgroundColor: Colors.white10,
            color: Colors.cyanAccent,
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}

class GlitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final random = math.Random();
    
    // Draw random glitch rectangles
    for (int i = 0; i < 5; i++) {
      if (random.nextDouble() > 0.7) {
        final rect = Rect.fromLTWH(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
          random.nextDouble() * 100,
          2,
        );
        canvas.drawRect(rect, paint..color = Colors.redAccent.withOpacity(0.3));
        
        final rect2 = Rect.fromLTWH(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
          random.nextDouble() * 50,
          1,
        );
        canvas.drawRect(rect2, paint..color = Colors.cyanAccent.withOpacity(0.2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
