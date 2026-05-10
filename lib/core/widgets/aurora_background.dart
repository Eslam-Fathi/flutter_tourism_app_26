import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// An animated full-screen background widget that renders the app's signature
/// "Aurora" visual — a soft gradient sky with gently oscillating glow clouds.
///
/// ## Visual Design
/// The aurora effect consists of three layers stacked in a [Stack]:
/// 1. **Base gradient** — a top-to-bottom linear sweep from [AppColors.primary]
///    (indigo) through sky blue to [AppColors.background] (pale azure).
/// 2. **Top-right glow cloud** — a large white radial gradient disc that drifts
///    in and out of the corner, simulating a gentle nebula or moon glow.
/// 3. **Bottom-left glow cloud** — a cornflower-blue disc that moves in the
///    opposite phase, creating a breathing, counter-oscillating effect.
/// 4. **Centre accent** — a subtle, static orange glow that adds depth without
///    drawing attention (low-opacity [AppColors.accent] radial gradient).
///
/// ## Animation
/// The two glow clouds are driven by a single [AnimationController] that:
/// - Runs for **8 seconds** and reverses (`repeat(reverse: true)`)
/// - Uses [Curves.easeInOut] so the motion accelerates and decelerates smoothly
/// - Controls position offsets via [AnimatedBuilder] so only the [Positioned]
///   widgets rebuild — the gradient base is fully static
///
/// The animation can be disabled via [enableAnimation] for performance-sensitive
/// screens (e.g. admin dashboards with many list items).
///
/// ## Composition pattern
/// Wrap any screen content in [AuroraBackground] to apply the effect:
/// ```dart
/// AuroraBackground(
///   child: Column(children: [...]),
/// )
/// ```
class AuroraBackground extends StatefulWidget {
  /// The widget tree to display on top of the aurora background.
  final Widget child;

  /// When `true` (default), the glow clouds animate continuously.
  /// Set to `false` on performance-sensitive screens.
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
  // [SingleTickerProviderStateMixin] provides the vsync ticker for the
  // animation controller.  Using "Single" (not "Multi") because we only
  // need one controller — both clouds are driven by the same animation value.
  late final AnimationController _controller;

  // A curved wrapper around [_controller].  The raw controller value is linear
  // (0.0 → 1.0); the CurvedAnimation maps it through [Curves.easeInOut] so
  // the motion feels organic rather than mechanical.
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,         // ties the animation to this widget's lifecycle
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true); // ping-pong: 0→1→0→1…
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    // Always dispose animation controllers to release their vsync ticker.
    // Failing to do so causes a common "A TickerProvider was used after being
    // disposed" assertion error.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Layer 1: Base Aurora Gradient ─────────────────────────────────
        // A full-screen gradient that provides the sky backdrop.
        // Positioned.fill expands to cover the entire Stack area.
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,     // Deep indigo at the top
                  Color(0xFF87CEEB),     // Sky blue in the middle
                  AppColors.background,  // Pale azure at the bottom
                ],
                stops: [0.0, 0.6, 1.0], // 60% of the height is the indigo-to-blue transition
              ),
            ),
          ),
        ),

        // ── Layer 2: Top-Right Glow Cloud (animated or static) ────────────
        // The cloud drifts by ±40 px vertically and ±30 px horizontally,
        // giving the impression of slow atmospheric movement.
        if (widget.enableAnimation)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return Positioned(
                top: -120 + (_animation.value * 40),   // oscillates –120 to –80 px
                right: -80 + (_animation.value * 30),  // oscillates –80 to –50 px
                child: const _GlowCloud(
                  color: Colors.white,
                  size: 550,
                  opacity: 0.12, // Very subtle — cloud should feel atmospheric, not harsh
                ),
              );
            },
          )
        else
          // Static fallback — same position as the animation's midpoint
          const Positioned(
            top: -120,
            right: -80,
            child: _GlowCloud(color: Colors.white, size: 550, opacity: 0.12),
          ),

        // ── Layer 3: Bottom-Left Glow Cloud (opposite phase) ─────────────
        // Uses `1.0 - _animation.value` (the inverse phase) so that when
        // the top-right cloud drifts in, this cloud drifts out, and vice versa.
        // This creates a breathing, balancing effect.
        if (widget.enableAnimation)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              final phase = 1.0 - _animation.value; // inverted phase
              return Positioned(
                bottom: -120 + (phase * 40),
                left: -120 + (phase * 30),
                child: const _GlowCloud(
                  color: AppColors.secondary, // Cornflower blue for variety
                  size: 700,
                  opacity: 0.10, // Slightly more transparent than the top cloud
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

        // ── Layer 4: Centre Accent Glow (static) ─────────────────────────
        // A very faint orange radial gradient centred at roughly 200 px from
        // the top.  It adds warmth and depth without being noticeable as a
        // distinct element.  The [BoxShape.circle] + [RadialGradient] pattern
        // creates a perfect glow without an explicit border-radius calculation.
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
                    AppColors.accent.withOpacity(0.06), // 6% accent at the core
                    Colors.transparent,                  // Fades to nothing
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Layer 5: Screen Content ───────────────────────────────────────
        // The actual page content sits on top of all background layers.
        widget.child,
      ],
    );
  }
}

/// A private circular glow disc rendered with a [RadialGradient].
///
/// The three-stop gradient (full opacity → half opacity → transparent) creates
/// a soft, diffused glow rather than a hard-edged circle.
///
/// This widget is private (`_GlowCloud`) because it is an internal building
/// block of [AuroraBackground] and [AuroraGlowCloud].  External code should
/// use [AuroraGlowCloud] for named access.
class _GlowCloud extends StatelessWidget {
  /// The centre colour of the radial gradient glow.
  final Color color;

  /// The diameter of the glow disc in logical pixels.
  /// Large values (500–700) are typical for full-screen aurora effects.
  final double size;

  /// The maximum opacity at the disc centre (0.0–1.0).
  /// Values above 0.2 tend to look too opaque for a subtle atmospheric effect.
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
            color.withOpacity(opacity),         // Core — full glow intensity
            color.withOpacity(opacity * 0.5),   // Mid-ring — 50% fade
            Colors.transparent,                  // Edge — fully transparent
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

/// A public alias for [_GlowCloud] that can be used outside of [AuroraBackground].
///
/// Provides the same radial glow disc for use in other decorative contexts
/// (e.g. onboarding screens, splash screens) without exposing the private class.
///
/// ```dart
/// AuroraGlowCloud(
///   color: AppColors.primary,
///   size: 300,
///   opacity: 0.15,
/// )
/// ```
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
