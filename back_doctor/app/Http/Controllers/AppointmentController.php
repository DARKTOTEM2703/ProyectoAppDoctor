<?php

namespace App\Http\Controllers;

use App\Models\Appointment;
use App\Models\Doctor;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class AppointmentController extends Controller
{
    /**
     * Obtener todas las citas del usuario autenticado
     */
    public function index(Request $request)
    {
        try {
            $user = Auth::user();
            
            $appointments = Appointment::where('user_id', $user->id)
                ->with(['doctor', 'doctor.user'])
                ->orderBy('date', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'message' => 'Citas obtenidas',
                'data' => $appointments,
                'total' => count($appointments),
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener citas: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Obtener detalles de una cita específica
     */
    public function show($id)
    {
        try {
            $appointment = Appointment::with(['doctor', 'user'])->find($id);

            if (!$appointment) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cita no encontrada',
                ], 404);
            }

            return response()->json([
                'success' => true,
                'message' => 'Detalles de la cita',
                'data' => $appointment,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener cita: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Crear una nueva cita (reserva)
     */
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'doctor_id' => 'required|integer|exists:doctors,id',
                'date' => 'required|date|after_or_equal:today',
                'time' => 'required|date_format:H:i',
                'notes' => 'nullable|string|max:500',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Errores de validación',
                    'errors' => $validator->errors(),
                ], 422);
            }

            $user = Auth::user();

            // Validar que no exista una cita con el mismo doctor en la misma fecha y hora
            $existingAppointment = Appointment::where('doctor_id', $request->doctor_id)
                ->where('date', $request->date)
                ->where('time', $request->time)
                ->where('status', '!=', 'cancel')
                ->first();

            if ($existingAppointment) {
                return response()->json([
                    'success' => false,
                    'message' => 'Este horario ya está reservado. Por favor selecciona otro.',
                ], 409);
            }

            $appointment = Appointment::create([
                'user_id' => $user->id,
                'doctor_id' => $request->doctor_id,
                'date' => $request->date,
                'time' => $request->time,
                'status' => 'upcoming',
                'notes' => $request->notes ?? null,
            ]);

            $appointment->load(['doctor', 'doctor.user', 'user']);

            return response()->json([
                'success' => true,
                'message' => 'Cita agendada exitosamente',
                'data' => $appointment,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al crear cita: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Actualizar una cita (cambiar fecha/hora)
     */
    public function update(Request $request, $id)
    {
        try {
            $appointment = Appointment::find($id);

            if (!$appointment) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cita no encontrada',
                ], 404);
            }

            // Verificar que el usuario sea el propietario de la cita
            if ($appointment->user_id != Auth::id()) {
                return response()->json([
                    'success' => false,
                    'message' => 'No tienes permiso para modificar esta cita',
                ], 403);
            }

            $validator = Validator::make($request->all(), [
                'date' => 'sometimes|date|after_or_equal:today',
                'time' => 'sometimes|date_format:H:i',
                'notes' => 'nullable|string|max:500',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Errores de validación',
                    'errors' => $validator->errors(),
                ], 422);
            }

            $appointment->update($request->only(['date', 'time', 'notes']));
            $appointment->load(['doctor', 'doctor.user', 'user']);

            return response()->json([
                'success' => true,
                'message' => 'Cita actualizada exitosamente',
                'data' => $appointment,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al actualizar cita: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Cancelar una cita
     */
    public function destroy($id)
    {
        try {
            $appointment = Appointment::find($id);

            if (!$appointment) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cita no encontrada',
                ], 404);
            }

            // Verificar que el usuario sea el propietario
            if ($appointment->user_id != Auth::id()) {
                return response()->json([
                    'success' => false,
                    'message' => 'No tienes permiso para cancelar esta cita',
                ], 403);
            }

            // Solo permitir cancelación si no ha pasado la cita
            if ($appointment->date < now()->toDateString()) {
                return response()->json([
                    'success' => false,
                    'message' => 'No se pueden cancelar citas pasadas',
                ], 422);
            }

            $appointment->update(['status' => 'cancel']);

            return response()->json([
                'success' => true,
                'message' => 'Cita cancelada exitosamente',
                'data' => $appointment,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al cancelar cita: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Obtener citas disponibles para un doctor en una fecha
     */
    public function getAvailableSlots(Request $request, $doctorId)
    {
        try {
            $validator = Validator::make($request->all(), [
                'date' => 'required|date|after_or_equal:today',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Errores de validación',
                    'errors' => $validator->errors(),
                ], 422);
            }

            $doctor = Doctor::find($doctorId);
            if (!$doctor) {
                return response()->json([
                    'success' => false,
                    'message' => 'Doctor no encontrado',
                ], 404);
            }

            // Horarios disponibles: 9 AM a 5 PM, 1 hora cada slot
            $availableSlots = [];
            for ($hour = 9; $hour < 17; $hour++) {
                $time = sprintf('%02d:00', $hour);
                
                // Verificar si el slot está disponible
                $booked = Appointment::where('doctor_id', $doctorId)
                    ->where('date', $request->date)
                    ->where('time', $time)
                    ->where('status', '!=', 'cancel')
                    ->exists();

                $availableSlots[] = [
                    'time' => $time,
                    'available' => !$booked,
                ];
            }

            return response()->json([
                'success' => true,
                'message' => 'Slots disponibles obtenidos',
                'doctor_id' => $doctorId,
                'date' => $request->date,
                'data' => $availableSlots,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener slots: ' . $e->getMessage(),
            ], 500);
        }
    }
}
