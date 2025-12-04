import 'package:appdoctor/models/doctor_model.dart';
import 'api_service.dart';

class DoctorService {
  /// Obtener lista de todos los doctores
  static Future<List<Doctor>> getAllDoctors() async {
    try {
      final response = await ApiService.get('doctors');
      
      if (response['success'] == true) {
        final data = response['data'] as List;
        return data.map((doctorJson) => Doctor.fromJson(doctorJson)).toList();
      } else {
        throw Exception(response['message'] ?? 'Error al obtener doctores');
      }
    } catch (e) {
      print('Error en DoctorService.getAllDoctors: $e');
      rethrow;
    }
  }

  /// Obtener detalles de un doctor específico
  static Future<Doctor> getDoctorById(int id) async {
    try {
      final response = await ApiService.get('doctors/$id');
      
      if (response['success'] == true) {
        return Doctor.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Doctor no encontrado');
      }
    } catch (e) {
      print('Error en DoctorService.getDoctorById: $e');
      rethrow;
    }
  }

  /// Obtener doctores por especialidad
  static Future<List<Doctor>> getDoctorsBySpecialty(String specialty) async {
    try {
      final response = await ApiService.get('doctors/specialty/$specialty');
      
      if (response['success'] == true) {
        final data = response['data'] as List;
        return data.map((doctorJson) => Doctor.fromJson(doctorJson)).toList();
      } else {
        throw Exception(response['message'] ?? 'Error al filtrar doctores');
      }
    } catch (e) {
      print('Error en DoctorService.getDoctorsBySpecialty: $e');
      rethrow;
    }
  }

  /// Crear un nuevo doctor (solo admin)
  static Future<Doctor> createDoctor({
    required String name,
    required String specialty,
    required String phone,
    required String address,
    required String token,
  }) async {
    try {
      final response = await ApiService.post(
        'doctors',
        {
          'name': name,
          'specialty': specialty,
          'phone': phone,
          'address': address,
        },
        token: token,
      );
      
      if (response['success'] == true) {
        return Doctor.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Error al crear doctor');
      }
    } catch (e) {
      print('Error en DoctorService.createDoctor: $e');
      rethrow;
    }
  }
}
