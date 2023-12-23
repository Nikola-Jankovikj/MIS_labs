import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/Midterm.dart';

class CalendarWidget extends StatelessWidget {
  final List<Midterm> midterms;

  const CalendarWidget({Key? key, required this.midterms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Midterm Calendar'),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: _getCalendarDataSource(),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell) {
            _handleDateTap(context, details.date!);
          }
        },
      ),
    );
  }

  _DataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    for (var midterm in midterms) {
      appointments.add(Appointment(
        startTime: midterm.date,
        endTime: midterm.date.add(const Duration(hours: 2)),
        subject: midterm.subject,
      ));
    }

    return _DataSource(appointments);
  }

  void _handleDateTap(BuildContext context, DateTime selectedDate) {
    List<Midterm> midtermsForSelectedDate = midterms
        .where((midterm) =>
    midterm.date.year == selectedDate.year &&
        midterm.date.month == selectedDate.month &&
        midterm.date.day == selectedDate.day)
        .toList();

    if (midtermsForSelectedDate.isNotEmpty) {
      _showMidtermsDialog(context, selectedDate, midtermsForSelectedDate);
    }
  }

  void _showMidtermsDialog(
      BuildContext context, DateTime selectedDate, List<Midterm> midterms) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Midterms on ${selectedDate.toLocal()}'),
          content: Column(
            children: midterms
                .map((midterm) => Text(
                '${midterm.subject} - ${midterm.date.hour}:${midterm.date.minute}'))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
