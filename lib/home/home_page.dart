import 'package:flutter/material.dart';
import 'package:jueves/theme/nothing_theme.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final HomeController _controller;
  late AnimationController _welcomeAnimCtrl;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _welcomeAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
        if (_controller.showWelcome) {
          _welcomeAnimCtrl.forward(from: 0);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _welcomeAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NothingTheme.black,
      appBar: AppBar(
        title: const Text(
          '[ JUEVES ]',
          style: TextStyle(
            fontSize: NothingTheme.label,
            letterSpacing: 0.88,
            color: NothingTheme.textSecondary,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Dot grid background (subtle)
          Positioned.fill(child: CustomPaint(painter: DotGridPainter())),

          // Main content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: NothingTheme.spaceLg,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('👏', style: TextStyle(fontSize: 96)),

                    const SizedBox(height: NothingTheme.space3xl),

                    _buildStatusIndicator(),

                    const SizedBox(height: NothingTheme.space2xl),

                    if (_controller.errorMessage != null) ...[
                      _buildErrorMessage(),
                      const SizedBox(height: NothingTheme.spaceLg),
                    ],

                    _buildControlButton(),
                  ],
                ),
              ),
            ),
          ),

          // Welcome overlay
          if (_controller.showWelcome) _buildWelcomeOverlay(),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: NothingTheme.spaceMd,
        vertical: NothingTheme.spaceSm,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: _controller.listening
              ? NothingTheme.accent
              : NothingTheme.borderVisible,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status dot
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _controller.listening
                  ? NothingTheme.accent
                  : NothingTheme.textDisabled,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: NothingTheme.spaceSm),

          // Status text
          Text(
            _controller.listening ? 'ESCUCHANDO' : 'EN PAUSA',
            style: TextStyle(
              fontSize: NothingTheme.label,
              letterSpacing: 0.88,
              color: _controller.listening
                  ? NothingTheme.textDisplay
                  : NothingTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(NothingTheme.spaceMd),
      decoration: BoxDecoration(
        border: Border.all(color: NothingTheme.accent, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '[!]',
            style: TextStyle(
              fontSize: NothingTheme.body,
              color: NothingTheme.accent,
            ),
          ),
          const SizedBox(width: NothingTheme.spaceSm),
          Flexible(
            child: Text(
              _controller.errorMessage!,
              style: const TextStyle(
                fontSize: NothingTheme.caption,
                color: NothingTheme.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton() {
    if (_controller.loading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: NothingTheme.textDisplay,
        ),
      );
    }

    return FilledButton(
      onPressed: _controller.toggle,
      style: FilledButton.styleFrom(
        backgroundColor: _controller.listening
            ? NothingTheme.accent
            : NothingTheme.textDisplay,
        foregroundColor: _controller.listening
            ? NothingTheme.textDisplay
            : NothingTheme.black,
        minimumSize: const Size(160, 44),
      ),
      child: Text(
        _controller.listening ? 'DETENER' : 'INICIAR',
        style: const TextStyle(fontSize: 13, letterSpacing: 0.78),
      ),
    );
  }

  Widget _buildWelcomeOverlay() {
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
                  const Text(
                    '¡BIENVENIDO!',
                    style: TextStyle(
                      fontSize: NothingTheme.heading,
                      letterSpacing: -0.24,
                      color: NothingTheme.textDisplay,
                    ),
                  ),
                  const SizedBox(height: NothingTheme.spaceSm),
                  const Text(
                    'RODRIGO',
                    style: TextStyle(
                      fontSize: NothingTheme.label,
                      letterSpacing: 0.88,
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

/// Dot grid background painter (Nothing motif)
class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = NothingTheme.border
      ..style = PaintingStyle.fill;

    const spacing = 16.0;
    const dotRadius = 0.5;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
