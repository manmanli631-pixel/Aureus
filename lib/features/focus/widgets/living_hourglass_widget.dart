import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/focus_provider.dart';

class LivingHourglassWidget extends ConsumerWidget {
  const LivingHourglassWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusState = ref.watch(focusStateProvider);
    
    // Calculate progress based on durations (cap at 10 hours for full building)
    final productiveProgress = (focusState.focusDuration.inSeconds / (3600 * 10)).clamp(0.0, 1.0);
    final wasteProgress = (focusState.idleDuration.inSeconds / (3600 * 10)).clamp(0.0, 1.0);

    return Container(
      height: 400,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const Text(
            "THE LIVING HOURGLASS",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: HourglassPainter(
                productiveProgress: productiveProgress,
                wasteProgress: wasteProgress,
                isFocusMode: focusState.isFocusMode,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat("PRODUCTIVE", focusState.focusDuration, Colors.amber),
              _buildStat("WASTE", focusState.idleDuration, Colors.purpleAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, Duration duration, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8)),
        Text(
          "${duration.inHours}h ${duration.inMinutes % 60}m",
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}

class HourglassPainter extends CustomPainter {
  final double productiveProgress;
  final double wasteProgress;
  final bool isFocusMode;

  HourglassPainter({
    required this.productiveProgress,
    required this.wasteProgress,
    required this.isFocusMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final centerX = w / 2;
    
    // 1. Draw Glass Outline
    final glassPath = Path()
      ..moveTo(centerX - 60, 0)
      ..lineTo(centerX + 60, 0)
      ..lineTo(centerX + 10, h / 2)
      ..lineTo(centerX + 60, h)
      ..lineTo(centerX - 60, h)
      ..lineTo(centerX - 10, h / 2)
      ..close();

    final glassPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawPath(glassPath, glassPaint);

    // 2. Draw Top Reservoirs (Productive vs Waste)
    final reservoirHeight = (h / 2) - 10;
    
    // Productive Reservoir (Left side of top)
    final prodSandPath = Path()
      ..moveTo(centerX - 55, 5)
      ..lineTo(centerX - 5, 5)
      ..lineTo(centerX - 5, reservoirHeight * (1 - productiveProgress))
      ..lineTo(centerX - 55, reservoirHeight * (1 - productiveProgress))
      ..close();
    
    canvas.drawPath(prodSandPath, Paint()..color = Colors.amber.withOpacity(0.3));

    // Waste Reservoir (Right side of top)
    final wasteSandPath = Path()
      ..moveTo(centerX + 5, 5)
      ..lineTo(centerX + 55, 5)
      ..lineTo(centerX + 55, reservoirHeight * (1 - wasteProgress))
      ..lineTo(centerX + 5, reservoirHeight * (1 - wasteProgress))
      ..close();
    
    canvas.drawPath(wasteSandPath, Paint()..color = Colors.purpleAccent.withOpacity(0.3));

    // 3. Draw Sand Falling Effect
    if (isFocusMode) {
      _drawFallingSand(canvas, centerX - 5, h / 2, Colors.amber);
    } else {
      _drawFallingSand(canvas, centerX + 5, h / 2, Colors.purpleAccent);
    }

    // 4. Draw Building Area (Bottom)
    final buildingBaseY = h - 5;
    final maxBuildingHeight = (h / 2) - 10;
    
    // Draw the "Structure" (Productive)
    _drawBuilding(canvas, centerX, buildingBaseY, maxBuildingHeight * productiveProgress, Colors.amber);
    
    // Draw the "Waste/Corrosion" (Waste)
    _drawWaste(canvas, centerX, buildingBaseY, maxBuildingHeight * wasteProgress, Colors.purpleAccent);
  }

  void _drawFallingSand(Canvas canvas, double x, double y, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = 1.5;
    
    for (int i = 0; i < 5; i++) {
      final offset = math.Random().nextDouble() * 5;
      canvas.drawLine(Offset(x + offset - 2.5, y), Offset(x + offset - 2.5, y + 100), paint);
    }
  }

  void _drawBuilding(Canvas canvas, double centerX, double baseY, double height, Color color) {
    if (height <= 0) return;

    final paint = Paint()..color = color;
    final nBlocks = (height / 10).floor() + 1;
    
    for (int i = 0; i < nBlocks; i++) {
      final blockH = 8.0;
      final blockW = 20.0 - (i * 1.5);
      final rect = Rect.fromCenter(
        center: Offset(centerX, baseY - (i * 10) - 5),
        width: blockW,
        height: blockH,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2)), paint);
      
      // Add windows for more building look
      if (i > 0) {
        final winPaint = Paint()..color = Colors.black26;
        canvas.drawRect(Rect.fromCenter(center: Offset(centerX - 4, baseY - (i * 10) - 5), width: 3, height: 3), winPaint);
        canvas.drawRect(Rect.fromCenter(center: Offset(centerX + 4, baseY - (i * 10) - 5), width: 3, height: 3), winPaint);
      }
    }
  }

  void _drawWaste(Canvas canvas, double centerX, double baseY, double height, Color color) {
    if (height <= 0) return;

    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Sludge at the bottom
    final sludgePath = Path()
      ..moveTo(centerX - 40, baseY)
      ..quadraticBezierTo(centerX, baseY - height * 0.5, centerX + 40, baseY)
      ..close();
    
    canvas.drawPath(sludgePath, paint);
    
    // Corrosion vines on the building
    final vinePaint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    final vinePath = Path()
      ..moveTo(centerX - 10, baseY)
      ..lineTo(centerX - 15, baseY - height)
      ..lineTo(centerX - 5, baseY - height - 10);
    
    canvas.drawPath(vinePath, vinePaint);
  }

  @override
  bool shouldRepaint(covariant HourglassPainter oldDelegate) => true;
}
