<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Doctor extends Model
{
    protected $fillable = [
        'doc_id',
        'category',
        'patients',
        'experience',
        'bio_data',
        'status',
    ];

    protected $casts = [
        'patients' => 'integer',
        'experience' => 'integer',
    ];

    /**
     * Relación con el usuario (doctor es un tipo de usuario)
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'doc_id');
    }

    /**
     * Relación con las citas
     */
    public function appointments(): HasMany
    {
        return $this->hasMany(Appointment::class);
    }

    /**
     * Incluir datos del usuario cuando se consulte el doctor
     */
    protected $with = ['user'];

    /**
     * Personalizar la serialización para incluir datos del usuario
     */
    protected $appends = ['doctor_name', 'doctor_profile'];

    public function getDoctorNameAttribute()
    {
        return $this->user ? $this->user->name : null;
    }

    public function getDoctorProfileAttribute()
    {
        return $this->user ? $this->user->profile_photo_url ?? null : null;
    }
}

