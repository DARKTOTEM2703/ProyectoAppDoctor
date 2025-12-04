<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Doctor;
use Illuminate\Support\Facades\Hash;

class DoctorSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Datos de doctores de ejemplo
        $doctorsData = [
            [
                'name' => 'Dr. Juan Pérez',
                'email' => 'juan.perez@hospital.com',
                'category' => 'General',
                'patients' => 150,
                'experience' => 15,
                'bio_data' => 'Médico general con 15 años de experiencia en atención primaria.',
                'status' => 'available',
            ],
            [
                'name' => 'Dra. María García',
                'email' => 'maria.garcia@hospital.com',
                'category' => 'Cardiología',
                'patients' => 120,
                'experience' => 12,
                'bio_data' => 'Cardióloga especializada en enfermedades del corazón y presión arterial.',
                'status' => 'available',
            ],
            [
                'name' => 'Dr. Carlos López',
                'email' => 'carlos.lopez@hospital.com',
                'category' => 'Dermatología',
                'patients' => 100,
                'experience' => 10,
                'bio_data' => 'Dermatólogo con especialidad en tratamiento de acné y manchas de piel.',
                'status' => 'available',
            ],
            [
                'name' => 'Dra. Ana Martínez',
                'email' => 'ana.martinez@hospital.com',
                'category' => 'Ginecología',
                'patients' => 80,
                'experience' => 8,
                'bio_data' => 'Ginecóloga obstetra con experiencia en control prenatal y parto.',
                'status' => 'available',
            ],
            [
                'name' => 'Dr. Roberto Sánchez',
                'email' => 'roberto.sanchez@hospital.com',
                'category' => 'Odontología',
                'patients' => 200,
                'experience' => 20,
                'bio_data' => 'Dentista especializado en ortodoncia e implantes dentales.',
                'status' => 'available',
            ],
            [
                'name' => 'Dra. Laura González',
                'email' => 'laura.gonzalez@hospital.com',
                'category' => 'Neumología',
                'patients' => 110,
                'experience' => 14,
                'bio_data' => 'Neumóloga especializada en asma, EPOC y enfermedades respiratorias.',
                'status' => 'available',
            ],
            [
                'name' => 'Dr. Francisco Torres',
                'email' => 'francisco.torres@hospital.com',
                'category' => 'Oftalmología',
                'patients' => 130,
                'experience' => 11,
                'bio_data' => 'Oftalmólogo especializado en cirugía refractiva y cataratas.',
                'status' => 'available',
            ],
            [
                'name' => 'Dra. Patricia Ruiz',
                'email' => 'patricia.ruiz@hospital.com',
                'category' => 'Pediatría',
                'patients' => 180,
                'experience' => 13,
                'bio_data' => 'Pediatra con experiencia en atención integral de niños.',
                'status' => 'available',
            ],
        ];

        // Crear usuarios y doctores
        foreach ($doctorsData as $data) {
            // Crear usuario
            $user = User::create([
                'name' => $data['name'],
                'email' => $data['email'],
                'password' => Hash::make('password123'), // Contraseña por defecto
            ]);

            // Crear registro de doctor
            Doctor::create([
                'doc_id' => $user->id,
                'category' => $data['category'],
                'patients' => $data['patients'],
                'experience' => $data['experience'],
                'bio_data' => $data['bio_data'],
                'status' => $data['status'],
            ]);
        }
    }
}
