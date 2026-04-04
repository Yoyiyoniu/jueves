import 'package:flutter/material.dart';
import 'package:jueves/settings/audio_device_service.dart';
import 'package:jueves/settings/audio_settings.dart';
import 'package:jueves/theme/nothing_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _service = AudioDeviceService();

  List<AudioInputDevice> _inputs = [];
  List<AudioOutputDevice> _outputs = [];
  String? _selectedInputId;
  String? _selectedOutputId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final inputs = await _service.listInputDevices();
    final outputs = await _service.listOutputDevices();
    final savedInput = await AudioSettings.getInputDeviceId();
    final savedOutput = await AudioSettings.getOutputDeviceId();
    setState(() {
      _inputs = inputs;
      _outputs = outputs;
      _selectedInputId = inputs.any((d) => d.id == savedInput)
          ? savedInput
          : null;
      _selectedOutputId = outputs.any((d) => d.id == savedOutput)
          ? savedOutput
          : null;
      _loading = false;
    });
  }

  Future<void> _onInputChanged(String? id) async {
    setState(() => _selectedInputId = id);
    await AudioSettings.setInputDeviceId(id);
  }

  Future<void> _onOutputChanged(String? id) async {
    setState(() => _selectedOutputId = id);
    await AudioSettings.setOutputDeviceId(id);
    if (id != null) await _service.setOutputDevice(id);
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NothingTheme.black,
      appBar: AppBar(
        title: Text(
          '[ Configuracion ]',
          style: NothingTheme.spaceMonoLabel(
            fontSize: NothingTheme.label,
            color: NothingTheme.textSecondary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: NothingTheme.textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: NothingTheme.textSecondary,
                strokeWidth: 1,
              ),
            )
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(NothingTheme.spaceMd),
      children: [
        Text(
          'AUDIO',
          style: NothingTheme.spaceMonoLabel(
            fontSize: NothingTheme.caption,
            color: NothingTheme.textDisabled,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: NothingTheme.spaceMd),
        _buildDropdown(
          label: 'MICROFONO',
          hint: 'Dispositivo por defecto',
          value: _selectedInputId,
          icon: Icons.mic_none_outlined,
          items: _inputs
              .map(
                (d) => DropdownMenuItem<String>(
                  value: d.id,
                  child: _buildDeviceLabel(d.label, d.id),
                ),
              )
              .toList(),
          onChanged: _onInputChanged,
        ),
        const SizedBox(height: NothingTheme.spaceMd),
        const Divider(color: NothingTheme.border, height: 1),
        const SizedBox(height: NothingTheme.spaceMd),
        _buildDropdown(
          label: 'SALIDA DE AUDIO',
          hint: 'Dispositivo por defecto',
          value: _selectedOutputId,
          icon: Icons.volume_up_outlined,
          items: _outputs
              .map(
                (d) => DropdownMenuItem<String>(
                  value: d.id,
                  child: _buildDeviceLabel(d.label, d.id),
                ),
              )
              .toList(),
          onChanged: _onOutputChanged,
        ),
        if (_outputs.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: NothingTheme.spaceSm),
            child: Text(
              'pactl no encontrado. Instala PulseAudio o PipeWire-pulse.',
              style: NothingTheme.spaceMonoLabel(
                fontSize: NothingTheme.caption,
                color: NothingTheme.textDisabled,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDeviceLabel(String label, String id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: NothingTheme.spaceMonoLabel(
            fontSize: NothingTheme.caption,
            color: NothingTheme.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          id,
          style: NothingTheme.spaceMonoLabel(
            fontSize: 9,
            color: NothingTheme.textDisabled,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: NothingTheme.textDisabled),
            const SizedBox(width: NothingTheme.spaceSm),
            Text(
              label,
              style: NothingTheme.spaceMonoLabel(
                fontSize: NothingTheme.caption,
                color: NothingTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: NothingTheme.spaceSm),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: NothingTheme.borderVisible, width: 1),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: NothingTheme.surface,
              hint: Text(
                hint,
                style: NothingTheme.spaceMonoLabel(
                  fontSize: NothingTheme.caption,
                  color: NothingTheme.textDisabled,
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: NothingTheme.textSecondary,
                size: 16,
              ),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(
                    hint,
                    style: NothingTheme.spaceMonoLabel(
                      fontSize: NothingTheme.caption,
                      color: NothingTheme.textDisabled,
                    ),
                  ),
                ),
                ...items,
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
