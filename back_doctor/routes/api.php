<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DoctorController;
use App\Http\Controllers\AppointmentController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Ruta de prueba para verificar conexión desde Flutter
Route::get('/test', function () {
    return response()->json([
        'success' => true,
        'message' => '¡Conexión exitosa con Laravel!',
        'timestamp' => now(),
        'server_ip' => request()->ip(),
    ]);
});

// Ruta para obtener la IP del servidor (para detección automática)
Route::get('/server-ip', function () {
    // Obtiene la IP del servidor desde las variables de entorno o request
    $serverIp = request()->getHost();
    
    // Si está en localhost, intenta obtener la IP real de la red local
    if ($serverIp === 'localhost' || $serverIp === '127.0.0.1') {
        $serverIp = gethostbyname(gethostname());
    }
    
    return response()->json([
        'success' => true,
        'server_ip' => $serverIp,
        'server_port' => request()->getPort(),
        'full_url' => request()->getSchemeAndHttpHost(),
        'timestamp' => now(),
    ]);
});

// ============ RUTAS PÚBLICAS (Sin autenticación) ============

// Autenticación
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Doctores - Lectura pública
Route::get('/doctors', [DoctorController::class, 'index']);
Route::get('/doctors/{id}', [DoctorController::class, 'show']);
Route::get('/doctors/specialty/{specialty}', [DoctorController::class, 'filterBySpecialty']);

// Citas - Rutas públicas
Route::get('/appointments/available/{doctorId}', [AppointmentController::class, 'getAvailableSlots']);

// ============ RUTAS PROTEGIDAS (Requieren autenticación Sanctum) ============

Route::middleware('auth:sanctum')->group(function () {
    // Datos del usuario autenticado
    Route::get('/user', [AuthController::class, 'getUser']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // Doctores - Administración (solo para usuarios autenticados)
    Route::post('/doctors', [DoctorController::class, 'store']);
    Route::put('/doctors/{id}', [DoctorController::class, 'update']);
    Route::delete('/doctors/{id}', [DoctorController::class, 'destroy']);

    // Citas - Rutas protegidas
    Route::get('/appointments', [AppointmentController::class, 'index']);
    Route::get('/appointments/{id}', [AppointmentController::class, 'show']);
    Route::post('/appointments', [AppointmentController::class, 'store']);
    Route::put('/appointments/{id}', [AppointmentController::class, 'update']);
    Route::delete('/appointments/{id}', [AppointmentController::class, 'destroy']);
});
