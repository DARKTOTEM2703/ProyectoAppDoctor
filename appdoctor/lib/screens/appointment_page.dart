import 'package:appdoctor/utils/config.dart';
import 'package:appdoctor/models/appointment_model.dart';
import 'package:appdoctor/services/appointment_service.dart';
import 'package:appdoctor/services/auth_service.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus {
  upcoming,
  complete,
  cancel,
}

class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus estado = FilterStatus.upcoming;
  Alignment _aleniacion = Alignment.centerLeft;
  List<Appointment> appointments = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  /// Carga las citas del usuario autenticado desde el backend
  Future<void> _loadAppointments() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        setState(() {
          _errorMessage = 'Por favor inicia sesión primero';
          _isLoading = false;
        });
        return;
      }

      final fetchedAppointments =
          await AppointmentService.getUserAppointments(token);
      print('🟢 Citas cargadas: ${fetchedAppointments.length}');

      if (mounted) {
        setState(() {
          appointments = fetchedAppointments;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('🔴 Error cargando citas: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Error cargando citas: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// Mapea el estado de la cita a FilterStatus
  FilterStatus _mapStatusToFilter(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return FilterStatus.upcoming;
      case 'complete':
        return FilterStatus.complete;
      case 'cancel':
        return FilterStatus.cancel;
      default:
        return FilterStatus.upcoming;
    }
  }

  /// Cancela una cita
  Future<void> _cancelAppointment(int appointmentId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return;

      await AppointmentService.cancelAppointment(appointmentId, token);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cita cancelada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        _loadAppointments(); // Recarga las citas
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Config.init(context);

    // Filtra las citas según el estado seleccionado
    List<Appointment> appointmentsFiltrados = appointments
        .where(
            (appointment) => _mapStatusToFilter(appointment.status) == estado)
        .toList();

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Horarios de citas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Config.espacioPequeno,
            // Filtros de estado
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (FilterStatus filter in FilterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                estado = filter;
                                if (filter == FilterStatus.upcoming) {
                                  _aleniacion = Alignment.centerLeft;
                                } else if (filter == FilterStatus.complete) {
                                  _aleniacion = Alignment.center;
                                } else if (filter == FilterStatus.cancel) {
                                  _aleniacion = Alignment.centerRight;
                                }
                              });
                            },
                            child: Center(
                              child: Text(
                                filter == FilterStatus.upcoming
                                    ? 'Próximas'
                                    : filter == FilterStatus.complete
                                        ? 'Completadas'
                                        : 'Canceladas',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  alignment: _aleniacion,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Config.colorprimario,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        estado == FilterStatus.upcoming
                            ? 'Próximas'
                            : estado == FilterStatus.complete
                                ? 'Completadas'
                                : 'Canceladas',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Config.espacioPequeno,
            // Lista de citas filtradas
            Expanded(
              child: appointmentsFiltrados.isEmpty
                  ? Center(
                      child: Text(
                        'No hay citas ${estado == FilterStatus.upcoming ? 'próximas' : estado == FilterStatus.complete ? 'completadas' : 'canceladas'}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: appointmentsFiltrados.length,
                      itemBuilder: (context, index) {
                        final appointment = appointmentsFiltrados[index];
                        final isLastElement =
                            appointmentsFiltrados.length == index + 1;
                        final doctor = appointment.doctor;
                        final doctorName = doctor != null
                            ? (doctor['user']?['name'] ?? 'Doctor')
                            : 'Doctor';
                        final specialty = doctor != null
                            ? (doctor['specialty'] ?? 'Medicina General')
                            : 'Medicina General';

                        return Card(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: !isLastElement
                              ? const EdgeInsets.only(bottom: 20)
                              : const EdgeInsets.all(0),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Información del doctor
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Config.colorprimario,
                                      child: Text(
                                        doctorName.isNotEmpty
                                            ? doctorName[0].toUpperCase()
                                            : 'D',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dr. $doctorName',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          specialty,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 15),
                                // Información de fecha y hora
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade700,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            color: Config.colorprimario,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${appointment.date.day}/${appointment.date.month}/${appointment.date.year}',
                                            style: const TextStyle(
                                              color: Config.colorprimario,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_alarm,
                                            color: Config.colorprimario,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            appointment.time,
                                            style: const TextStyle(
                                              color: Config.colorprimario,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                // Botones de acción
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed:
                                            estado == FilterStatus.upcoming
                                                ? () => _cancelAppointment(
                                                    appointment.id)
                                                : null,
                                        child: const Text(
                                          'Cancelar',
                                          style: TextStyle(
                                            color: Config.colorprimario,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Config.colorprimario,
                                        ),
                                        onPressed:
                                            estado == FilterStatus.upcoming
                                                ? () {
                                                    // TODO: Implementar reagendar
                                                  }
                                                : null,
                                        child: const Text(
                                          'Reagendar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
