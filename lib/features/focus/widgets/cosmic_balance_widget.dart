import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../providers/focus_provider.dart';

class CosmicBalanceWidget extends ConsumerStatefulWidget {
  const CosmicBalanceWidget({super.key});

  @override
  ConsumerState<CosmicBalanceWidget> createState() => _CosmicBalanceWidgetState();
}

class _CosmicBalanceWidgetState extends ConsumerState<CosmicBalanceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _morphAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _morphAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusState = ref.watch(focusStateProvider);
    final isProductive = focusState.isFocusMode;

    if (isProductive) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    final themeColor = isProductive ? Colors.amber : Colors.purpleAccent;

    return GestureDetector(
      onLongPress: () {
        ref.read(focusStateProvider.notifier).toggleFocusMode();
        HapticFeedback.heavyImpact();
      },
      onTap: () {
        _showTooltip(context, focusState);
      },
      child: TweenAnimationBuilder<Color?>(
        duration: const Duration(milliseconds: 1000),
        tween: ColorTween(begin: Colors.purpleAccent, end: themeColor),
        builder: (context, color, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Breathing Aura
              AnimatedBuilder(
                animation: _controller, // Use existing controller for breathing
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(double.infinity, 300),
                    painter: AuraPainter(
                      color: color ?? Colors.amber,
                      breathProgress: math.sin(DateTime.now().millisecondsSinceEpoch / 500).abs(),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _morphAnimation,
                builder: (context, child) {
                  return Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Color.lerp(
                            const Color(0xFF0A0A0A),
                            (color ?? Colors.white).withOpacity(0.3),
                            _morphAnimation.value,
                          )!,
                          Colors.transparent,
                        ],
                        radius: 1.5,
                      ),
                    ),
                    child: CustomPaint(
                      painter: CosmicPainter(
                        progress: _morphAnimation.value,
                        time: DateTime.now().millisecondsSinceEpoch / 1000.0,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTooltip(BuildContext context, FocusState state) {
    final duration = state.isFocusMode ? state.focusDuration : state.idleDuration;
    final label = state.isFocusMode ? "Productive Flow" : "Idle Time";
    final color = state.isFocusMode ? Colors.amber : Colors.purpleAccent;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(state.isFocusMode ? Icons.wb_sunny : Icons.wb_twilight, color: color),
            const SizedBox(width: 12),
            Text("$label: ${duration.inHours}h ${duration.inMinutes % 60}m"),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class CosmicPainter extends CustomPainter {
  final double progress;
  final double time;

  CosmicPainter({required this.progress, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.25;

    if (progress > 0.01) {
      _drawSun(canvas, center, baseRadius * (0.8 + 0.4 * progress));
    }
    
    if (progress < 0.99) {
      _drawBlackHole(canvas, center, baseRadius * (1.2 - 0.4 * progress));
    }
  }

  void _drawSun(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          Colors.amber.shade400,
          Colors.orange.shade700,
          Colors.orange.shade900.withOpacity(0.0),
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.5))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20 * progress);

    // Dynamic sun aura
    for (int i = 0; i < 3; i++) {
      final pulse = math.sin(time * 2 + i) * 10;
      final auraRadius = (radius + pulse) * progress;
      if (auraRadius > 0) {
        canvas.drawCircle(center, auraRadius, paint);
      }
    }

    // Core
    final corePaint = Paint()
      ..color = Colors.white.withOpacity(progress)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, radius * 0.6 * progress, corePaint);
  }

  void _drawBlackHole(Canvas canvas, Offset center, double radius) {
    final opacity = 1.0 - progress;
    
    // Accretion Disk (Outer glow)
    final diskPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.purple.shade900.withOpacity(0.0),
          Colors.deepPurple.shade600.withOpacity(0.6 * opacity),
          Colors.purple.shade900.withOpacity(0.0),
        ],
        transform: GradientRotation(time),
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.5))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 30 * opacity);

    canvas.drawCircle(center, radius * 1.3, diskPaint);

    // Event Horizon
    final eventHorizonPaint = Paint()
      ..color = Colors.black.withOpacity(opacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5 * opacity);
    
    canvas.drawCircle(center, radius * 0.8, eventHorizonPaint);

    // The Void
    final voidPaint = Paint()
      ..color = Colors.black.withOpacity(opacity)
      ..blendMode = BlendMode.srcOver;
    
    canvas.drawCircle(center, radius * 0.7, voidPaint);

    // Absorption particles (lines moving inwards)
    final particlePaint = Paint()
      ..color = Colors.white.withOpacity(0.3 * opacity)
      ..strokeWidth = 1.0;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180 + time;
      final startRadius = radius * 1.8;
      final endRadius = radius * 0.9;
      final move = (time * 100 % 100) / 100.0;
      
      final currentRadius = startRadius - (startRadius - endRadius) * move;
      final p1 = Offset(
        center.dx + math.cos(angle) * currentRadius,
        center.dy + math.sin(angle) * currentRadius,
      );
      final p2 = Offset(
        center.dx + math.cos(angle) * (currentRadius - 20),
        center.dy + math.sin(angle) * (currentRadius - 20),
      );
      canvas.drawLine(p1, p2, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CosmicPainter oldDelegate) => true;
}

class AuraPainter extends CustomPainter {
  final Color color;
  final double breathProgress;

  AuraPainter({required this.color, required this.breathProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.25;
    
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(0.4),
          color.withOpacity(0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: baseRadius * 2))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20 + 10 * breathProgress);

    final auraRadius = baseRadius * (1.2 + 0.3 * breathProgress);
    if (auraRadius > 0) {
      canvas.drawCircle(center, auraRadius, auraPaint);
    }
  }

  @override
  bool shouldRepaint(covariant AuraPainter oldDelegate) => 
    oldDelegate.color != color || oldDelegate.breathProgress != breathProgress;
}
