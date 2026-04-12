class ModelCalendarEvent {
  final String eventId;
  final DateTime? time;
  final String title;
  final String fullDescription;
  final bool isHomeWork; // have: Assignment: Google classroom Title
  final String? url;

  ModelCalendarEvent({
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
