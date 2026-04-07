import 'package:flutter/foundation.dart';
import 'agenda_event_model.dart';

class AgendaController extends ChangeNotifier {
  final List<AgendaEventModel> _events = [];
  DateTime _selectedDate = DateTime.now();

  List<AgendaEventModel> get events => List.unmodifiable(_events);
  DateTime get selectedDate => _selectedDate;

  List<AgendaEventModel> get eventsForSelectedDate {
    return _events.where((e) {
      final d = _selectedDate;
      return e.start.year == d.year &&
          e.start.month == d.month &&
          e.start.day == d.day;
    }).toList()..sort((a, b) => a.start.compareTo(b.start));
  }

  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  void addEvent(AgendaEventModel event) {
    _events.add(event);
    notifyListeners();
  }

  void removeEvent(String id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  bool hasEventsOn(DateTime date) {
    return _events.any(
      (e) =>
          e.start.year == date.year &&
          e.start.month == date.month &&
          e.start.day == date.day,
    );
  }
}
