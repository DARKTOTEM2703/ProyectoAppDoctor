class Appointment {
  final int id;
  final int userId;
  final int doctorId;
  final DateTime date;
  final String time;
  final String status; // upcoming, complete, cancel
  final String? notes;
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? doctor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.status,
    this.notes,
    this.user,
    this.doctor,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory para crear un Appointment desde JSON
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      doctorId: json['doctor_id'] as int,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      user: json['user'] as Map<String, dynamic>?,
      doctor: json['doctor'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convertir Appointment a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'doctor_id': doctorId,
      'date': date.toIso8601String().split('T')[0],
      'time': time,
      'status': status,
      'notes': notes,
      'user': user,
      'doctor': doctor,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Obtener nombre del doctor
  String? getDoctorName() {
    if (doctor != null && doctor!.containsKey('user')) {
      return doctor!['user']['name'];
    }
    return null;
  }

  /// Obtener información del doctor
  String? getDoctorCategory() {
    if (doctor != null) {
      return doctor!['category'];
    }
    return null;
  }

  /// Crear una copia con valores modificados
  Appointment copyWith({
    int? id,
    int? userId,
    int? doctorId,
    DateTime? date,
    String? time,
    String? status,
    String? notes,
    Map<String, dynamic>? user,
    Map<String, dynamic>? doctor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      user: user ?? this.user,
      doctor: doctor ?? this.doctor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Appointment(id: $id, doctorId: $doctorId, date: $date, time: $time, status: $status)';
  }
}
