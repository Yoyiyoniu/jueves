import 'package:flutter/material.dart';
import 'package:flutter_agenda/flutter_agenda.dart';
import 'package:jueves/theme/nothing_theme.dart';
import 'agenda_controller.dart';
import 'agenda_event_model.dart';
import 'add_event_dialog.dart';

class AgendaWidget extends StatefulWidget {
  final AgendaController controller;

  const AgendaWidget({super.key, required this.controller});

  @override
  State<AgendaWidget> createState() => _AgendaWidgetState();
}

class _AgendaWidgetState extends State<AgendaWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  /// Builds the single FlutterAgenda resource that holds all events for the day.
  List<Resource> _buildResources() {
    final agendaEvents = widget.controller.eventsForSelectedDate.map((e) {
      return AgendaEvent(
        title: e.title,
        subtitle: e.description ?? '',
        start: SingleDayEventTime(hour: e.start.hour, minute: e.start.minute),
        end: SingleDayEventTime(hour: e.end.hour, minute: e.end.minute),
        backgroundColor: e.color,
        textStyle: const TextStyle(
          color: NothingTheme.textDisplay,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        subtitleStyle: const TextStyle(
          color: NothingTheme.textPrimary,
          fontSize: 10,
          fontWeight: FontWeight.w300,
        ),
      );
    }).toList();

    return [
      Resource(
        head: Header(
          title: '',
          height: 0,
          backgroundColor: Colors.transparent,
          color: Colors.transparent,
          textStyle: const TextStyle(fontSize: 0),
        ),
        events: agendaEvents,
      ),
    ];
  }

  Future<void> _openAddDialog() async {
    final result = await showDialog<AgendaEventModel>(
      context: context,
      builder: (_) =>
          AddEventDialog(initialDate: widget.controller.selectedDate),
    );
    if (result != null) widget.controller.addEvent(result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AgendaHeaderWidget(
          controller: widget.controller,
          onAddTap: _openAddDialog,
        ),
        const Divider(height: 1, color: NothingTheme.border),
        CalendarStripWidget(controller: widget.controller),
        const Divider(height: 1, color: NothingTheme.border),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => AgendaTimelineWidget(
              resources: _buildResources(),
              onAddTap: _openAddDialog,
              hasEvents: widget.controller.eventsForSelectedDate.isNotEmpty,
              height: constraints.maxHeight,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class AgendaHeaderWidget extends StatelessWidget {
  final AgendaController controller;
  final VoidCallback onAddTap;

  const AgendaHeaderWidget({
    super.key,
    required this.controller,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    const months = [
      'ENE',
      'FEB',
      'MAR',
      'ABR',
      'MAY',
      'JUN',
      'JUL',
      'AGO',
      'SEP',
      'OCT',
      'NOV',
      'DIC',
    ];
    final d = controller.selectedDate;
    final label = '${months[d.month - 1]} ${d.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NothingTheme.spaceMd,
        vertical: NothingTheme.spaceSm,
      ),
      child: Row(
        children: [
          Text(
            '[ AGENDA ]',
            style: NothingTheme.spaceMonoLabel(
              fontSize: NothingTheme.label,
              color: NothingTheme.textSecondary,
            ),
          ),
          const SizedBox(width: NothingTheme.spaceSm),
          Text(
            label,
            style: NothingTheme.spaceMonoLabel(
              fontSize: NothingTheme.label,
              color: NothingTheme.textDisabled,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onAddTap,
            child: Container(
              padding: const EdgeInsets.all(NothingTheme.spaceXs),
              decoration: BoxDecoration(
                border: Border.all(color: NothingTheme.borderVisible),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.add,
                size: 14,
                color: NothingTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Calendar Strip ───────────────────────────────────────────────────────────

class CalendarStripWidget extends StatelessWidget {
  final AgendaController controller;

  const CalendarStripWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final selected = controller.selectedDate;
    final days = List.generate(
      14,
      (i) => today.subtract(const Duration(days: 3)).add(Duration(days: i)),
    );

    return SizedBox(
      height: 64,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: NothingTheme.spaceSm,
          vertical: NothingTheme.spaceXs,
        ),
        itemCount: days.length,
        itemBuilder: (_, i) {
          final day = days[i];
          final isSelected =
              day.year == selected.year &&
              day.month == selected.month &&
              day.day == selected.day;
          final isToday =
              day.year == today.year &&
              day.month == today.month &&
              day.day == today.day;
          return DayCellWidget(
            date: day,
            isSelected: isSelected,
            isToday: isToday,
            hasEvents: controller.hasEventsOn(day),
            onTap: () => controller.selectDate(day),
          );
        },
      ),
    );
  }
}

class DayCellWidget extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool hasEvents;
  final VoidCallback onTap;

  const DayCellWidget({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.hasEvents,
    required this.onTap,
  });

  static const _weekdays = ['LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB', 'DOM'];

  @override
  Widget build(BuildContext context) {
    final weekday = _weekdays[date.weekday - 1];
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: isSelected ? NothingTheme.interactive : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(color: NothingTheme.borderVisible)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekday,
              style: NothingTheme.spaceMonoLabel(
                fontSize: 8,
                color: isSelected
                    ? NothingTheme.black
                    : NothingTheme.textDisabled,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              date.day.toString(),
              style: NothingTheme.spaceMonoLabel(
                fontSize: NothingTheme.bodySm,
                color: isSelected
                    ? NothingTheme.black
                    : isToday
                    ? NothingTheme.textDisplay
                    : NothingTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: hasEvents
                    ? (isSelected
                          ? NothingTheme.black
                          : NothingTheme.interactive)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Timeline ─────────────────────────────────────────────────────────────────

class AgendaTimelineWidget extends StatelessWidget {
  final List<Resource> resources;
  final VoidCallback onAddTap;
  final bool hasEvents;
  final double height;

  const AgendaTimelineWidget({
    super.key,
    required this.resources,
    required this.onAddTap,
    required this.hasEvents,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasEvents) {
      return Padding(
        padding: const EdgeInsets.all(NothingTheme.spaceLg),
        child: Center(
          child: Column(
            children: [
              Text(
                'SIN EVENTOS',
                style: NothingTheme.spaceMonoLabel(
                  color: NothingTheme.textDisabled,
                ),
              ),
              const SizedBox(height: NothingTheme.spaceSm),
              GestureDetector(
                onTap: onAddTap,
                child: Text(
                  '+ agregar',
                  style: NothingTheme.spaceGroteskBody(
                    fontSize: NothingTheme.bodySm,
                    color: NothingTheme.interactive,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: FlutterAgenda(
        resources: resources,
        agendaStyle: const AgendaStyle(
          startHour: 0,
          endHour: 24,
          enableMultiDayEvents: false,
          mainBackgroundColor: Color(0xF2000000),
          pillarColor: Color(0xF2000000),
          cornerColor: Color(0xF2000000),
          timelineColor: Color(0xF2000000),
          timelineItemColor: Color(0xF2000000),
          timelineBorderColor: NothingTheme.border,
          decorationLineBorderColor: NothingTheme.border,
          timeItemTextColor: NothingTheme.textDisabled,
          timeItemTextStyle: TextStyle(
            color: NothingTheme.textDisabled,
            fontSize: 11,
            fontWeight: FontWeight.w300,
          ),
          timeItemWidth: 48,
          timeSlot: TimeSlot.half,
          headersPosition: HeadersPosition.top,
          headerLogo: HeaderLogo.bar,
          direction: TextDirection.ltr,
          visibleTimeBorder: false,
        ),
        onTap: (clickedTime, object) {},
      ),
    );
  }
}
