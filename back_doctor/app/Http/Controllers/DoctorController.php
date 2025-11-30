<?php

namespace App\Http\Controllers;

use App\Models\Doctor;
use Illuminate\Http\Request;

class DoctorController extends Controller
{
    /**
     * Obtener lista de todos los doctores
     */
    public function index(Request $request)
    {
        try {
            $doctors = Doctor::all();

            return response()->json([
                'success' => true,
                'message' => 'Lista de doctores obtenida',
                'data' => $doctors,
                'total' => count($doctors),
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener doctores: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Obtener detalles de un doctor específico
     */
    public function show($id)
    {
        try {
            $doctor = Doctor::find($id);

            if (!$doctor) {
                return response()->json([
                    'success' => false,
                    'message' => 'Doctor no encontrado',
                ], 404);
            }

            return response()->json([
                'success' => true,
                'message' => 'Detalles del doctor obtenidos',
                'data' => $doctor,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener doctor: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Filtrar doctores por especialidad
     */
    public function filterBySpecialty($specialty)
    {
        try {
            $doctors = Doctor::where('specialty', 'LIKE', "%$specialty%")->get();

            return response()->json([
                'success' => true,
                'message' => 'Doctores filtrados',
                'specialty' => $specialty,
                'data' => $doctors,
                'total' => count($doctors),
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al filtrar doctores: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Crear un nuevo doctor (solo admin)
     */
    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'name' => 'required|string|max:255',
                'specialty' => 'required|string|max:255',
                'phone' => 'required|string',
                'address' => 'required|string',
            ]);

            $doctor = Doctor::create($validated);

            return response()->json([
                'success' => true,
                'message' => 'Doctor creado exitosamente',
                'data' => $doctor,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al crear doctor: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Actualizar datos de un doctor
     */
    public function update(Request $request, $id)
    {
        try {
            $doctor = Doctor::find($id);

            if (!$doctor) {
                return response()->json([
                    'success' => false,
                    'message' => 'Doctor no encontrado',
                ], 404);
            }

            $doctor->update($request->all());

            return response()->json([
                'success' => true,
                'message' => 'Doctor actualizado exitosamente',
                'data' => $doctor,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al actualizar doctor: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Eliminar un doctor
     */
    public function destroy($id)
    {
        try {
            $doctor = Doctor::find($id);

            if (!$doctor) {
                return response()->json([
                    'success' => false,
                    'message' => 'Doctor no encontrado',
                ], 404);
            }

            $doctor->delete();

            return response()->json([
                'success' => true,
                'message' => 'Doctor eliminado exitosamente',
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al eliminar doctor: ' . $e->getMessage(),
            ], 500);
        }
    }
}
