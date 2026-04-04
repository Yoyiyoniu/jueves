import 'package:flutter/material.dart';
import 'package:jueves/theme/nothing_theme.dart';

class WelcomeModal extends StatelessWidget {
  const WelcomeModal({super.key, required AnimationController welcomeAnimCtrl})
    : _welcomeAnimCtrl = welcomeAnimCtrl;

  final AnimationController _welcomeAnimCtrl;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: NothingTheme.black.withValues(alpha: 0.9),
        child: Center(
          child: FadeTransition(
            opacity: _welcomeAnimCtrl,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: NothingTheme.space2xl,
                vertical: NothingTheme.spaceXl,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: NothingTheme.spaceLg,
              ),
              decoration: BoxDecoration(
                color: NothingTheme.surface,
                border: Border.all(color: NothingTheme.borderVisible, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('👋', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: NothingTheme.spaceLg),
                  Text(
                    '¡BIENVENIDO!',
                    style: NothingTheme.spaceGroteskBody(
                      fontSize: NothingTheme.heading,
                      letterSpacing: -0.24,
                      color: NothingTheme.textDisplay,
                    ),
                  ),
                  const SizedBox(height: NothingTheme.spaceSm),
                  Text(
                    'RODRIGO',
                    style: NothingTheme.spaceMonoLabel(
                      fontSize: NothingTheme.label,
                      color: NothingTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
