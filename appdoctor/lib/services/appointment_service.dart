import 'package:appdoctor/models/appointment_model.dart';
import 'api_service.dart';

class AppointmentService {
  /// Obtener todas las citas del usuario autenticado
  static Future<List<Appointment>> getUserAppointments(String token) async {
    try {
      final response = await ApiService.get('appointments', token: token);
      
      if (response['success'] == true) {
        final data = response['data'] as List;
        return data
            .map((appointmentJson) => Appointment.fromJson(appointmentJson))
            .toList();
      } else {
        throw Exception(response['message'] ?? 'Error al obtener citas');
      }
    } catch (e) {
      print('Error en AppointmentService.getUserAppointments: $e');
      rethrow;
    }
  }

  /// Obtener detalles de una cita específica
  static Future<Appointment> getAppointmentById(int id, String token) async {
    try {
      final response = await ApiService.get('appointments/$id', token: token);
      
      if (response['success'] == true) {
        return Appointment.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Cita no encontrada');
      }
    } catch (e) {
      print('Error en AppointmentService.getAppointmentById: $e');
      rethrow;
    }
  }

  /// Crear una nueva cita (reserva)
  static Future<Appointment> createAppointment({
    required int doctorId,
    required DateTime date,
    required String time,
    String? notes,
    required String token,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0]; // Formato YYYY-MM-DD
      
      final response = await ApiService.post(
        'appointments',
        {
          'doctor_id': doctorId,
          'date': dateStr,
          'time': time,
          if (notes != null) 'notes': notes,
        },
        token: token,
      );
      
      if (response['success'] == true) {
        return Appointment.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Error al crear cita');
      }
    } catch (e) {
      print('Error en AppointmentService.createAppointment: $e');
      rethrow;
    }
  }

  /// Actualizar una cita (cambiar fecha/hora)
  static Future<Appointment> updateAppointment({
    required int appointmentId,
    DateTime? date,
    String? time,
    String? notes,
    required String token,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (date != null) {
        data['date'] = date.toIso8601String().split('T')[0];
      }
      if (time != null) {
        data['time'] = time;
      }
      if (notes != null) {
        data['notes'] = notes;
      }

      final response = await ApiService.put(
        'appointments/$appointmentId',
        data,
        token: token,
      );
      
      if (response['success'] == true) {
        return Appointment.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Error al actualizar cita');
      }
    } catch (e) {
      print('Error en AppointmentService.updateAppointment: $e');
      rethrow;
    }
  }

  /// Cancelar una cita
  static Future<Appointment> cancelAppointment(
    int appointmentId,
    String token,
  ) async {
    try {
      final response =
          await ApiService.delete('appointments/$appointmentId', token: token);
      
      if (response['success'] == true) {
        return Appointment.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Error al cancelar cita');
      }
    } catch (e) {
      print('Error en AppointmentService.cancelAppointment: $e');
      rethrow;
    }
  }

  /// Obtener citas disponibles para un doctor en una fecha
  static Future<List<Map<String, dynamic>>> getAvailableSlots(
    int doctorId,
    DateTime date,
  ) async {
    try {
      final dateStr = date.toIso8601String().split('T')[0];
      final response = await ApiService.get(
        'appointments/available/$doctorId?date=$dateStr',
      );
      
      if (response['success'] == true) {
        final data = response['data'] as List;
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(response['message'] ?? 'Error al obtener horarios');
      }
    } catch (e) {
      print('Error en AppointmentService.getAvailableSlots: $e');
      rethrow;
    }
  }
}
