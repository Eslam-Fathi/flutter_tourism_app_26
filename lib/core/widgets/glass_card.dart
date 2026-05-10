import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A **glassmorphism** card widget that applies a frosted-glass visual effect
/// using [BackdropFilter] and a semi-transparent background.
///
/// ## What is Glassmorphism?
/// Glassmorphism is a UI design trend that makes surfaces look like frosted
/// glass — blurring whatever is behind them and adding a subtle border to
/// suggest depth and layering.  It pairs especially well with gradient
/// backgrounds like [AuroraBackground].
///
/// ## How it works technically
/// 1. [ClipRRect] clips the subtree to a rounded rectangle.
/// 2. [BackdropFilter] with [ImageFilter.blur] applies a Gaussian blur to
///    everything **behind** this widget (the content underneath in the
///    [Stack], not the card's own children).
/// 3. A [Container] with a semi-transparent [AppColors.glassWhite] background
///    and a [AppColors.glassBorder] border completes the illusion.
///
/// > **Performance note**: [BackdropFilter] is one of the most expensive
/// > Flutter operations because it forces the engine to save, blur, and
/// > composite a layer.  Avoid using multiple [GlassCard]s on the same
/// > screen; prefer one large one and normal opaque children inside it.
///
/// ## Usage
/// ```dart
/// // Standard light glass card (default):
/// GlassCard(
///   child: Column(children: [...]),
/// )
///
/// // Custom blur, padding, and border radius:
/// GlassCard(
///   blurSigma: 20,
///   padding: const EdgeInsets.all(24),
///   borderRadius: BorderRadius.circular(16),
///   child: Text('Custom glass'),
/// )
///
/// // Dark glass (for overlays on images) — use GlassDarkCard:
/// GlassDarkCard(child: Text('Dark overlay'))
/// ```
class GlassCard extends StatelessWidget {
  /// The widget to display inside the glass card.
  final Widget child;

  /// Internal padding applied to [child].
  /// Defaults to `EdgeInsets.all(16)`.
  final EdgeInsetsGeometry? padding;

  /// Corner radius of the frosted glass panel.
  /// Defaults to `BorderRadius.circular(24)`.
  final BorderRadius? borderRadius;

  /// Gaussian blur intensity applied to everything behind the card.
  ///
  /// Higher values = more blur.  `12` is a comfortable default.
  /// Very high values (> 30) can degrade performance noticeably on low-end
  /// devices.
  final double blurSigma;

  /// Background tint colour of the card.
  ///
  /// Should be a semi-transparent colour (e.g. [AppColors.glassWhite] at 10%
  /// opacity) so the blur effect is visible through the surface.
  final Color? backgroundColor;

  /// Colour of the 1.5 px border that outlines the glass panel.
  /// Defaults to [AppColors.glassBorder] (20% white).
  final Color? borderColor;

  /// Whether to render the 1.5 px border.  Set to `false` for a borderless
  /// glass effect (useful in very dense layouts).
  final bool hasBorder;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.blurSigma = 12,
    this.backgroundColor,
    this.borderColor,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(24);
    return ClipRRect(
      // ClipRRect must wrap BackdropFilter; without it the blur leaks outside
      // the rounded corners and produces an ugly square-blur artefact.
      borderRadius: br,
      child: BackdropFilter(
        // sigmaX/sigmaY control the blur radius in each axis.
        // Using equal values (isotropic blur) is standard for glass effects.
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.glassWhite,
            borderRadius: br,
            border: hasBorder
                ? Border.all(
                    color: borderColor ?? AppColors.glassBorder,
                    width: 1.5,
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// A darker variant of [GlassCard] designed for overlaying semi-transparent
/// panels **on top of images** (e.g. the bottom caption area of a service card).
///
/// Uses [AppColors.glassCardDark] (15% black) as the background, a slightly
/// reduced blur sigma (8 instead of 12), and a faint white border at 15%
/// opacity to remain visible over dark images.
///
/// ```dart
/// Stack(
///   children: [
///     Image.network(imageUrl, fit: BoxFit.cover),
///     Positioned(
///       bottom: 0,
///       child: GlassDarkCard(
///         child: Text('Service Name', style: TextStyle(color: Colors.white)),
///       ),
///     ),
///   ],
/// )
/// ```
class GlassDarkCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const GlassDarkCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: padding,
      borderRadius: borderRadius,
      backgroundColor: AppColors.glassCardDark,           // 15% black tint
      borderColor: Colors.white.withOpacity(0.15),        // Subtle white border
      blurSigma: 8,                                       // Lighter blur over images
      child: child,
    );
  }
}
