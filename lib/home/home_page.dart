import 'package:flutter/material.dart';
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
      duration: const Duration(milliseconds: 800),
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Jueves Clap (YAMNet)')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('👏', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 24),
                _buildStatusBadge(),
                const SizedBox(height: 40),
                if (_controller.errorMessage != null) ...[
                  _buildErrorMessage(_controller.errorMessage!),
                  const SizedBox(height: 16),
                ],
                if (_controller.loading)
                  const CircularProgressIndicator()
                else
                  FilledButton.icon(
                    onPressed: _controller.toggle,
                    icon: Icon(_controller.listening ? Icons.stop : Icons.mic),
                    label: Text(_controller.listening ? 'Detener' : 'Iniciar'),
                  ),
              ],
            ),
          ),
          if (_controller.showWelcome) _buildWelcomeOverlay(theme),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _controller.listening
            ? Colors.green.withValues(alpha: 0.15)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _controller.listening ? Icons.graphic_eq : Icons.mic_off,
            size: 16,
            color: _controller.listening ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            _controller.listening ? 'Escuchando...' : 'En pausa',
            style: TextStyle(
              color: _controller.listening ? Colors.green : Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeOverlay(ThemeData theme) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: ScaleTransition(
            scale: Tween(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(
                parent: _welcomeAnimCtrl,
                curve: Curves.elasticOut,
              ),
            ),
            child: FadeTransition(
              opacity: _welcomeAnimCtrl,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('👋', style: TextStyle(fontSize: 60)),
                    const SizedBox(height: 16),
                    Text(
                      '¡Bienvenido Rodrigo!',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
