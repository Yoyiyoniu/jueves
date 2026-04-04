import 'dart:async';
import 'dart:typed_data';
import 'package:record/record.dart';
import 'package:jueves/yamnet_http_classifier.dart';

class AudioProcessor {
  final AudioRecorder _recorder = AudioRecorder();
  final YamNetHttpClassifier _classifier = YamNetHttpClassifier();

  // Buffer acumulador de muestras
  final List<double> _buffer = [];

  // YAMNet necesita exactamente 15600 muestras (0.975s @ 16kHz)
  static const int _windowSize = 15600;

  // Solapamiento del 50% entre ventanas (evita perder aplausos en el borde)
  static const int _hopSize = 7800;

  void Function()? onClapDetected;
  void Function(String)? onError;

  StreamSubscription<Uint8List>? _streamSubscription;
  bool _isProcessing = false;

  Future<void> start() async {
    // Verificar que el servidor Python está disponible
    final serverAvailable = await _classifier.checkServer();
    if (!serverAvailable) {
      throw Exception(
        'Servidor Python no disponible.\n'
        'Ejecuta: python server.py',
      );
    }

    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        numChannels: 1,
        sampleRate: 16000,
      ),
    );

    _streamSubscription = stream.listen(_onAudioData);
  }

  void _onAudioData(Uint8List bytes) {
    // Convertir bytes PCM16 a float32 normalizado [-1.0, 1.0]
    final samples = Int16List.view(bytes.buffer);
    for (final s in samples) {
      _buffer.add(s / 32768.0);
    }

    // Procesar cuando tenemos suficientes muestras
    while (_buffer.length >= _windowSize) {
      final window = Float32List.fromList(_buffer.sublist(0, _windowSize));

      // Clasificar de forma asíncrona sin bloquear
      if (!_isProcessing) {
        _isProcessing = true;
        _classifier
            .classify(window)
            .then((isClap) {
              if (isClap) {
                onClapDetected?.call();
              }
              _isProcessing = false;
            })
            .catchError((error) {
              onError?.call(error.toString());
              _isProcessing = false;
            });
      }

      // Avanzar la ventana (hop)
      _buffer.removeRange(0, _hopSize);
    }
  }

  Future<void> stop() async {
    await _streamSubscription?.cancel();
    _streamSubscription = null;
    await _recorder.stop();
    await _recorder.dispose();
    _buffer.clear();
  }
}
