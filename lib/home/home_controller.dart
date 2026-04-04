import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';
import 'package:jueves/detector/audio_processor.dart';

class HomeController extends ChangeNotifier {
  final AudioProcessor _processor = AudioProcessor();

  bool _listening = false;
  bool _loading = false;
  String? _errorMessage;
  DateTime? _lastClapTime;
  int _consecutiveClaps = 0;
  bool _showWelcome = false;

  bool get listening => _listening;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  bool get showWelcome => _showWelcome;

  HomeController() {
    _processor.onClapDetected = _handleClapDetected;
    _processor.onError = _handleError;
  }

  void _handleClapDetected() {
    final now = DateTime.now();

    if (_lastClapTime != null &&
        now.difference(_lastClapTime!).inMilliseconds < 600) {
      _consecutiveClaps++;
    } else {
      _consecutiveClaps = 1;
    }

    _lastClapTime = now;

    if (_consecutiveClaps == 2) {
      _showWelcome = true;
      notifyListeners();

      Future.delayed(const Duration(seconds: 2), () {
        _showWelcome = false;
        notifyListeners();
      });
    }
  }

  void _handleError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> toggle() async {
    if (_listening) {
      await _processor.stop();
      _listening = false;
      notifyListeners();
      return;
    }

    if (!kIsWeb &&
        (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
      // No solicitar permisos en desktop
    } else {
      final granted = await Permission.microphone.request();
      if (!granted.isGranted) return;
    }

    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _processor.start();
      _loading = false;
      _listening = true;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _processor.stop();
    super.dispose();
  }
}
