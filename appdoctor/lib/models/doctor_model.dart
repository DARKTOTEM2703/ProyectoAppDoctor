class Doctor {
  final int id;
  final int docId;
  final String? category;
  final int? patients;
  final int? experience;
  final String? bioData;
  final String? status;
  final String? doctorName;
  final String? doctorProfile;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Doctor({
    required this.id,
    required this.docId,
    this.category,
    this.patients,
    this.experience,
    this.bioData,
    this.status,
    this.doctorName,
    this.doctorProfile,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory para crear un Doctor desde JSON
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as int,
      docId: json['doc_id'] as int,
      category: json['category'] as String?,
      patients: json['patients'] as int?,
      experience: json['experience'] as int?,
      bioData: json['bio_data'] as String?,
      status: json['status'] as String?,
      doctorName: json['doctor_name'] as String?,
      doctorProfile: json['doctor_profile'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convertir Doctor a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doc_id': docId,
      'category': category,
      'patients': patients,
      'experience': experience,
      'bio_data': bioData,
      'status': status,
      'doctor_name': doctorName,
      'doctor_profile': doctorProfile,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Crear una copia con valores modificados
  Doctor copyWith({
    int? id,
    int? docId,
    String? category,
    int? patients,
    int? experience,
    String? bioData,
    String? status,
    String? doctorName,
    String? doctorProfile,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Doctor(
      id: id ?? this.id,
      docId: docId ?? this.docId,
      category: category ?? this.category,
      patients: patients ?? this.patients,
      experience: experience ?? this.experience,
      bioData: bioData ?? this.bioData,
      status: status ?? this.status,
      doctorName: doctorName ?? this.doctorName,
      doctorProfile: doctorProfile ?? this.doctorProfile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Doctor(id: $id, name: $doctorName, category: $category)';
  }
}
