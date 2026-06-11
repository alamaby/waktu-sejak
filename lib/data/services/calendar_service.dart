import 'package:add_2_calendar/add_2_calendar.dart' as calendar;

import '../models/event_model.dart';

class CalendarService {
  const CalendarService();

  Future<bool> addEvent(EventModel event, {required String description}) {
    final calendarEvent = calendar.Event(
      title: event.name,
      description: description,
      startDate: event.targetDate,
      endDate: event.targetDate.add(const Duration(hours: 1)),
    );

    return calendar.Add2Calendar.addEvent2Cal(calendarEvent);
  }
}
