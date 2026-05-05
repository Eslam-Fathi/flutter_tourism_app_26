import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated Aurora background with gently oscillating glow clouds.
class AuroraBackground extends StatefulWidget {
  final Widget child;
  final bool enableAnimation;

  const AuroraBackground({
    super.key,
    required this.child,
    this.enableAnimation = true,
  });

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Aurora gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  Color(0xFF87CEEB),
                  AppColors.background,
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),

        // Top-right glow cloud (oscillates)
        if (widget.enableAnimation)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return Positioned(
                top: -120 + (_animation.value * 40),
                right: -80 + (_animation.value * 30),
                child: const _GlowCloud(
                  color: Colors.white,
                  size: 550,
                  opacity: 0.12,
                ),
              );
            },
          )
        else
          const Positioned(
            top: -120,
            right: -80,
            child: _GlowCloud(color: Colors.white, size: 550, opacity: 0.12),
          ),

        // Bottom-left glow cloud (oscillates opposite phase)
        if (widget.enableAnimation)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              final phase = 1.0 - _animation.value;
              return Positioned(
                bottom: -120 + (phase * 40),
                left: -120 + (phase * 30),
                child: const _GlowCloud(
                  color: AppColors.secondary,
                  size: 700,
                  opacity: 0.10,
                ),
              );
            },
          )
        else
          const Positioned(
            bottom: -120,
            left: -120,
            child: _GlowCloud(
              color: AppColors.secondary,
              size: 700,
              opacity: 0.10,
            ),
          ),

        // Centre subtle accent glow
        Positioned(
          top: 200,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Content
        widget.child,
      ],
    );
  }
}

class _GlowCloud extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _GlowCloud({
    required this.color,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(opacity),
            color.withOpacity(opacity * 0.5),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

// Keep compatibility alias
class AuroraGlowCloud extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const AuroraGlowCloud({
    super.key,
    required this.color,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return _GlowCloud(color: color, size: size, opacity: opacity);
  }
}
