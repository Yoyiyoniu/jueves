import 'package:flutter/material.dart';
import 'package:jueves/theme/nothing_theme.dart';
import 'agenda_event_model.dart';

class AddEventDialog extends StatefulWidget {
  final DateTime initialDate;

  const AddEventDialog({super.key, required this.initialDate});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  Color _selectedColor = NothingTheme.interactive;

  static const _colors = [
    NothingTheme.interactive,
    NothingTheme.accent,
    NothingTheme.success,
    NothingTheme.warning,
    Color(0xFFAA66CC),
  ];

  @override
  void initState() {
    super.initState();
    final now = TimeOfDay.now();
    _startTime = now;
    _endTime = TimeOfDay(hour: (now.hour + 1) % 24, minute: now.minute);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: NothingTheme.interactive,
            surface: NothingTheme.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _submit() {
    if (_titleCtrl.text.trim().isEmpty) return;
    final date = widget.initialDate;
    final start = DateTime(
      date.year,
      date.month,
      date.day,
      _startTime.hour,
      _startTime.minute,
    );
    var end = DateTime(
      date.year,
      date.month,
      date.day,
      _endTime.hour,
      _endTime.minute,
    );
    if (!end.isAfter(start)) end = start.add(const Duration(hours: 1));

    final event = AgendaEventModel(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      start: start,
      end: end,
      color: _selectedColor,
    );
    Navigator.of(context).pop(event);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: NothingTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: NothingTheme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(NothingTheme.spaceMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '[ NUEVO EVENTO ]',
              style: NothingTheme.spaceMonoLabel(
                fontSize: NothingTheme.label,
                color: NothingTheme.textSecondary,
              ),
            ),
            const SizedBox(height: NothingTheme.spaceMd),
            TextField(
              controller: _titleCtrl,
              autofocus: true,
              style: NothingTheme.spaceGroteskBody(
                color: NothingTheme.textDisplay,
              ),
              decoration: const InputDecoration(
                hintText: 'Título',
                hintStyle: TextStyle(color: NothingTheme.textDisabled),
              ),
            ),
            const SizedBox(height: NothingTheme.spaceSm),
            TextField(
              controller: _descCtrl,
              style: NothingTheme.spaceGroteskBody(
                fontSize: NothingTheme.bodySm,
                color: NothingTheme.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Descripción (opcional)',
                hintStyle: TextStyle(color: NothingTheme.textDisabled),
              ),
            ),
            const SizedBox(height: NothingTheme.spaceMd),
            Row(
              children: [
                _TimeButton(
                  label: 'INICIO',
                  time: _startTime,
                  onTap: () => _pickTime(isStart: true),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NothingTheme.spaceSm,
                  ),
                  child: Text(
                    '→',
                    style: NothingTheme.spaceMonoLabel(
                      color: NothingTheme.textDisabled,
                    ),
                  ),
                ),
                _TimeButton(
                  label: 'FIN',
                  time: _endTime,
                  onTap: () => _pickTime(isStart: false),
                ),
              ],
            ),
            const SizedBox(height: NothingTheme.spaceMd),
            Row(
              children: _colors
                  .map(
                    (c) => GestureDetector(
                      onTap: () => setState(() => _selectedColor = c),
                      child: Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(
                          right: NothingTheme.spaceSm,
                        ),
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: _selectedColor == c
                              ? Border.all(
                                  color: NothingTheme.textDisplay,
                                  width: 2,
                                )
                              : null,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: NothingTheme.spaceMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'CANCELAR',
                    style: NothingTheme.spaceMonoLabel(
                      color: NothingTheme.textDisabled,
                    ),
                  ),
                ),
                const SizedBox(width: NothingTheme.spaceSm),
                OutlinedButton(
                  onPressed: _submit,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: NothingTheme.interactive),
                    padding: const EdgeInsets.symmetric(
                      horizontal: NothingTheme.spaceMd,
                      vertical: NothingTheme.spaceSm,
                    ),
                  ),
                  child: Text(
                    'AGREGAR',
                    style: NothingTheme.spaceMonoLabel(
                      color: NothingTheme.interactive,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  const _TimeButton({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: NothingTheme.spaceSm,
          vertical: NothingTheme.spaceXs,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: NothingTheme.borderVisible),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: NothingTheme.spaceMonoLabel(
                fontSize: 9,
                color: NothingTheme.textDisabled,
              ),
            ),
            Text(
              '$h:$m',
              style: NothingTheme.spaceMonoLabel(
                fontSize: NothingTheme.bodySm,
                color: NothingTheme.textDisplay,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
