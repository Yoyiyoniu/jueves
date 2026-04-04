import 'dart:io';
import 'package:record/record.dart';

class AudioInputDevice {
  final String id;
  final String label;
  const AudioInputDevice({required this.id, required this.label});
}

class AudioOutputDevice {
  final String id; // PulseAudio sink name
  final String label;
  const AudioOutputDevice({required this.id, required this.label});
}

class AudioDeviceService {
  final AudioRecorder _recorder = AudioRecorder();

  /// Lista los dispositivos de entrada disponibles via record
  Future<List<AudioInputDevice>> listInputDevices() async {
    try {
      final devices = await _recorder.listInputDevices();
      return devices
          .map((d) => AudioInputDevice(id: d.id, label: d.label))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Lista los sinks de PulseAudio disponibles via pactl
  Future<List<AudioOutputDevice>> listOutputDevices() async {
    try {
      final result = await Process.run('pactl', ['list', 'short', 'sinks']);
      if (result.exitCode != 0) return [];

      final lines = (result.stdout as String)
          .split('\n')
          .where((l) => l.trim().isNotEmpty);

      return lines.map((line) {
        // formato: <index>\t<name>\t<module>\t<sample>\t<state>
        final parts = line.split('\t');
        final name = parts.length > 1 ? parts[1].trim() : line.trim();
        // Etiqueta legible: quitar prefijo alsa_output. y sufijos largos
        final label = name
            .replaceAll('alsa_output.', '')
            .replaceAll('alsa_input.', '')
            .split('.')[0];
        return AudioOutputDevice(id: name, label: label);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  /// Mueve el sink-input de esta app al sink elegido.
  /// Busca el sink-input cuyo nombre de aplicación contenga [appName].
  Future<void> setOutputDevice(String sinkName,
      {String appName = 'jueves'}) async {
    try {
      // Obtener lista de sink-inputs
      final result =
          await Process.run('pactl', ['list', 'short', 'sink-inputs']);
      if (result.exitCode != 0) return;

      final lines = (result.stdout as String)
          .split('\n')
          .where((l) => l.trim().isNotEmpty);

      for (final line in lines) {
        final parts = line.split('\t');
        if (parts.isEmpty) continue;
        final inputIndex = parts[0].trim();
        // Mover este sink-input al nuevo sink
        await Process.run('pactl', ['move-sink-input', inputIndex, sinkName]);
      }
    } catch (_) {}
  }

  void dispose() {
    _recorder.dispose();
  }
}
