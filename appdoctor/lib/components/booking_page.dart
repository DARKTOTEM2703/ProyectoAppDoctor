import 'package:appdoctor/components/custom_appbar.dart';
import 'package:appdoctor/models/doctor_model.dart';
import 'package:appdoctor/services/appointment_service.dart';
import 'package:appdoctor/services/auth_service.dart';
import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  final Doctor? doctor;

  const BookingPage({
    super.key,
    this.doctor,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
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
  bool _isLoading = false;

  // Ajustamos firstDay al inicio del día actual
  static final DateTime firstDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  static final DateTime lastDay = DateTime(2026, 12, 31); // Fecha límite
  static const double rowHeight = 48.0; // Altura de filas del calendario

  @override
  Widget build(BuildContext context) {
    Config.init(context); // Inicializa configuración global
    
    // Obtener doctor del argumento si no fue proporcionado
    final doctor = ModalRoute.of(context)?.settings.arguments as Doctor? ?? widget.doctor;

    if (doctor == null) {
      return Scaffold(
        appBar: CustomAppBar(
          appTitle: 'Error',
          icon: const Icon(Icons.arrow_back_ios),
        ),
        body: const Center(
          child: Text('Error: No se encontró doctor'),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Reservar cita con ${doctor.doctorName}',
        icon: const Icon(Icons.arrow_back_ios),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      _buildCalendar(), // Llamar al método para construir el calendario
                      const SizedBox(height: 20),
                      const Text(
                        'Selecciona tu horario de consulta',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.espacioPequeno, // Espaciado pequeño
                    ],
                  ),
                ),
                _isWeekend
                    ? SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 30),
                          alignment: Alignment.center,
                          child: const Text(
                            'Lo siento, no se pueden hacer citas los fines de semana, por favor selecciona otra fecha',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                    : SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final hour = index + 9; // Calcula la hora inicial (9 AM)
                            final displayHour =
                                hour > 12 ? hour - 12 : hour;
                            final period = hour >= 12 ? "PM" : "AM";
                            final timeStr = '${hour.toString().padLeft(2, '0')}:00';

                            return InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  if (_currentIndex == index) {
                                    _currentIndex = null;
                                    _timeSelected = false;
                                  } else {
                                    _currentIndex = index;
                                    _timeSelected = true;
                                  }
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _currentIndex == index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  color: _currentIndex == index
                                      ? Config.colorprimario
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    '$displayHour:00 $period',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _currentIndex == index
                                          ? Colors.white
                                          : null,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: 8, // Última cita a las 4 PM
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1.5,
                        ),
                      ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 80),
                    child: BookingButton(
                      isEnabled: _timeSelected && _dateSelected,
                      doctor: doctor,
                      selectedDate: _currentDay,
                      selectedTimeIndex: _currentIndex,
                      onPressed: _createAppointment,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Crear cita en el servidor
  Future<void> _createAppointment() async {
    if (_currentIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un horario')),
      );
      return;
    }

    final doctor = ModalRoute.of(context)?.settings.arguments as Doctor? ?? widget.doctor;
    if (doctor == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor inicia sesión primero')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(
            'login_page',
            (route) => false,
          );
        }
        return;
      }

      final hour = _currentIndex! + 9;
      final timeStr = '${hour.toString().padLeft(2, '0')}:00';

      final appointment = await AppointmentService.createAppointment(
        doctorId: doctor.id,
        date: _currentDay,
        time: timeStr,
        token: token,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Cita creada exitosamente!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushNamed('success_booking', arguments: appointment);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear cita: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Construcción del widget del calendario
  Widget _buildCalendar() {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: firstDay,
      lastDay: lastDay,
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: rowHeight,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Config.colorprimario,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blueAccent,
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
    if (selectedDay.isBefore(firstDay) || selectedDay.isAfter(lastDay)) {
      // Verificar si la fecha seleccionada está dentro del rango válido
      return;
    }
    setState(() {
      _currentDay = selectedDay;
      _focusedDay = focusedDay;
      _isWeekend = selectedDay.weekday == DateTime.saturday ||
          selectedDay.weekday == DateTime.sunday;

      if (_isWeekend) {
        _timeSelected = false;
        _currentIndex = null;
        _dateSelected = false;
      } else {
        _dateSelected = true;
      }
    });
  }
}

class BookingButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;
  final Doctor doctor;
  final DateTime selectedDate;
  final int? selectedTimeIndex;

  const BookingButton({
    required this.isEnabled,
    required this.onPressed,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTimeIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? Config.colorprimario : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: const Text(
          'Crear cita',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
