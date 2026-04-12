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
    'time': time,
    'title': title,
    'fullDescription': fullDescription,
  };
}
