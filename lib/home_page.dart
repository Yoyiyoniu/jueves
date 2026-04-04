import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';
import 'package:jueves/audio_processor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final AudioProcessor _processor = AudioProcessor();
  late AnimationController _animCtrl;
  int _clapCount = 0;
  bool _listening = false;
  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _processor.onClapDetected = () {
      setState(() => _clapCount++);
      _animCtrl.forward(from: 0);
    };
    _processor.onError = (error) {
      setState(() => _errorMessage = error);
    };
  }

  Future<void> _toggle() async {
    if (_listening) {
      await _processor.stop();
      setState(() => _listening = false);
      return;
    }

    // En Linux/Windows/macOS desktop no se necesitan permisos
    if (!kIsWeb &&
        (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
      // No solicitar permisos en desktop
    } else {
      // En Android/iOS sí se necesitan permisos
      final granted = await Permission.microphone.request();
      if (!granted.isGranted) return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      await _processor.start();
      setState(() {
        _loading = false;
        _listening = true;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Jueves Clap (YAMNet)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.6).animate(
                CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut),
              ),
              child: const Text('👏', style: TextStyle(fontSize: 80)),
            ),
            const SizedBox(height: 24),
            Text('$_clapCount', style: theme.textTheme.displayLarge),
            Text('aplausos detectados', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _listening
                    ? Colors.green.withOpacity(0.15)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _listening ? Icons.graphic_eq : Icons.mic_off,
                    size: 16,
                    color: _listening ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _listening ? 'Escuchando...' : 'En pausa',
                    style: TextStyle(
                      color: _listening ? Colors.green : Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            if (_errorMessage != null) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_loading)
              const CircularProgressIndicator()
            else
              FilledButton.icon(
                onPressed: _toggle,
                icon: Icon(_listening ? Icons.stop : Icons.mic),
                label: Text(_listening ? 'Detener' : 'Iniciar'),
              ),
            if (_clapCount > 0) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => setState(() => _clapCount = 0),
                child: const Text('Reiniciar contador'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _processor.stop();
    _animCtrl.dispose();
    super.dispose();
  }
}
