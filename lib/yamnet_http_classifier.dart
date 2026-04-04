import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class YamNetHttpClassifier {
  static const String _baseUrl = 'http://localhost:5000';
  bool _isServerAvailable = false;

  /// Verifica si el servidor Python está disponible
  Future<bool> checkServer() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/health'))
          .timeout(const Duration(seconds: 2));
      _isServerAvailable = response.statusCode == 200;
      return _isServerAvailable;
    } catch (e) {
      _isServerAvailable = false;
      return false;
    }
  }

  /// Clasifica una ventana de audio y retorna true si detecta un aplauso
  Future<bool> classify(Float32List audioSamples) async {
    if (!_isServerAvailable) {
      throw Exception(
        'Servidor Python no disponible. Ejecuta: python server.py',
      );
    }

    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/classify'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'samples': audioSamples.toList()}),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['clap'] as bool;
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al clasificar: $e');
    }
  }

  /// Obtiene la confianza de la última clasificación
  Future<double> getConfidence(Float32List audioSamples) async {
    if (!_isServerAvailable) {
      return 0.0;
    }

    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/classify'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'samples': audioSamples.toList()}),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['confidence'] as double;
      }
    } catch (e) {
      // Ignorar errores
    }
    return 0.0;
  }
}
