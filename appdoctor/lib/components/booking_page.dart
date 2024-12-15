import 'package:appdoctor/components/custom_appbar.dart';
import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  // Declaración de variables
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  static DateTime lastDay = DateTime(2026, 12, 31); // Fecha límite
  static const double rowHeight = 48.0; // Altura de filas del calendario

  @override
  Widget build(BuildContext context) {
    Config.init(context); // Inicializa configuración global
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Información del Doctor',
        icon: const Icon(Icons.arrow_back_ios),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                _buildCalendar(), // Llamar al método para construir el calendario
                const SizedBox(
                    height: 20), // Espaciado adicional si es necesario
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Construcción del widget del calendario
  Widget _buildCalendar() {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime.now(),
      lastDay: lastDay,
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: rowHeight,
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Config.colorprimario,
          shape: BoxShape.circle,
        ),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Mes',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: _onDaySelected,
    );
  }

  // Método manejador de selección de día
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _currentDay = selectedDay;
      _focusedDay = focusedDay;
      _dateSelected = true;
      _isWeekend = selectedDay.weekday == DateTime.saturday ||
          selectedDay.weekday == DateTime.sunday;

      if (_isWeekend) {
        _timeSelected = false;
        _currentIndex = null;
      }
    });
  }
}
