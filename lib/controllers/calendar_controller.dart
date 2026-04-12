import 'dart:convert';
import 'dart:io';
import 'package:puppeteer/puppeteer.dart';

class CalendarEvent {
  final String eventId;
  final DateTime? time;
  final String title;
  final String fullDescription;
  final bool isHomeWork; // have: Assignment: Google classroom Title
  final String? url;

  CalendarEvent({
    required this.eventId,
    this.time,
    this.url,
    required this.title,
    required this.fullDescription,
    required this.isHomeWork,
  });

  Map<String, dynamic> toJson() => {
    'eventId': eventId,
    'time': time?.toIso8601String(),
    'title': title,
    'fullDescription': fullDescription,
    'isHomeWork': isHomeWork,
    'url': url,
  };
}

class CalendarController {
  static final _timeRegex = RegExp(
    r'^\d{1,2}(:\d{2})?(am|pm)$',
    caseSensitive: false,
  );

  Future<List<CalendarEvent>> getMothCalendar() async {
    await Process.start('chromium', [
      '--remote-debugging-port=9222',
    ], runInShell: true);

    await Future.delayed(Duration(milliseconds: 1500));

    var browser = await puppeteer.connect(browserUrl: 'http://localhost:9222');
    var myPage = await browser.newPage();

    await myPage.goto(
      'https://calendar.google.com/calendar/u/1/r?pli=1',
      wait: Until.domContentLoaded,
    );

    await myPage.waitForSelector(
      '[role="main"]',
      timeout: Duration(seconds: 10),
    );

    final rawEvents = await myPage.evaluate<List>('''() => {
      const chips = document.querySelectorAll('[data-eventchip]');
      return Array.from(chips).map(chip => {
        const eventId = chip.getAttribute('data-eventid') || '';
        const timeEl = chip.querySelector('span.DvyQhe');
        const titleEl = chip.querySelector('span.WBi6vc');
        const descEl = chip.querySelector('span.XuJrye');
        
        // Intenta obtener URL del evento si existe
        const linkEl = chip.querySelector('a[href]');
        const url = linkEl ? linkEl.href : null;
        
        return {
          eventId,
          time: timeEl ? timeEl.innerText.trim() : null,
          title: titleEl ? titleEl.innerText.trim() : '',
          fullDescription: descEl ? descEl.innerText.trim() : '',
          url: url,
        };
      });
    }''');

    final events = rawEvents
        .map((e) {
          final map = Map<String, dynamic>.from(e as Map);
          final timeStr = map['time'] as String?;
          final title = map['title'] as String;

          final isHomeWork = title.startsWith('Assignment:');

          DateTime? parsedTime;
          if (timeStr != null && _timeRegex.hasMatch(timeStr)) {
            // Crear un DateTime con la hora parseada (usando fecha de hoy como base)
            final now = DateTime.now();
            final hourMatch = RegExp(
              r'(\d{1,2})(?::(\d{2}))?(am|pm)',
            ).firstMatch(timeStr.toLowerCase());

            if (hourMatch != null) {
              int hour = int.parse(hourMatch.group(1)!);
              int minute = int.tryParse(hourMatch.group(2) ?? '0') ?? 0;
              final isPM = hourMatch.group(3) == 'pm';

              if (isPM && hour != 12) hour += 12;
              if (!isPM && hour == 12) hour = 0;

              parsedTime = DateTime(now.year, now.month, now.day, hour, minute);
            }
          }

          return CalendarEvent(
            eventId: map['eventId'] as String,
            time: parsedTime,
            url: map['url'] as String?,
            title: title,
            fullDescription: map['fullDescription'] as String,
            isHomeWork: isHomeWork,
          );
        })
        .where((event) => event.time != null)
        .toList();

    await browser.close();

    return events;
  }
}

void main() async {
  var calendar = await CalendarController().getMothCalendar();

  print(jsonEncode(calendar.map((e) => e.toJson()).toList()));
}
