import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A glassmorphism card widget using BackdropFilter.
/// Wrap any child in this for a frosted-glass effect.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blurSigma;
  final Color? backgroundColor;
  final Color? borderColor;
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
      borderRadius: br,
      child: BackdropFilter(
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

/// A dark-tinted glass card, useful for overlays on images.
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
      backgroundColor: AppColors.glassCardDark,
      borderColor: Colors.white.withOpacity(0.15),
      blurSigma: 8,
      child: child,
    );
  }
}
