import 'package:shared_preferences/shared_preferences.dart';

class AudioSettings {
  static const _keyInputDevice = 'audio_input_device_id';
  static const _keyOutputDevice = 'audio_output_device_id';

  static Future<String?> getInputDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyInputDevice);
  }

  static Future<void> setInputDeviceId(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_keyInputDevice);
    } else {
      await prefs.setString(_keyInputDevice, id);
    }
  }

  static Future<String?> getOutputDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyOutputDevice);
  }

  static Future<void> setOutputDeviceId(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_keyOutputDevice);
    } else {
      await prefs.setString(_keyOutputDevice, id);
    }
  }
}
