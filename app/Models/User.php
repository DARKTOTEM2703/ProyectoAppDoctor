<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Fortify\TwoFactorAuthenticatable;
use Laravel\Jetstream\HasProfilePhoto;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens;

    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory;
    use HasProfilePhoto;
    use Notifiable;
    use TwoFactorAuthenticatable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'type', // aqui al agregar type podemos definir si es doctor o paciente
        'email',
        'password',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
        'two_factor_recovery_codes',
        'two_factor_secret',
    ];

    /**
     * The accessors to append to the model's array form.
     *
     * @var array<int, string>
     */
    protected $appends = [
        'profile_photo_url',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }


    //Aqui definimos la relacion uno a uno con la tabla user_details
    public function doctor()
    {
        //Aqui decimos que un usuario tiene relacion con un doctor
        return $this->hasOne(Doctor::class, 'doctor_id');
        //aqui retornamos la relacion uno a uno con la tabla doctor
        //$this es para decir que se relaciona con el modelo User
        //hasOne es para decir que tiene un registro en la tabla doctor
        //Doctor::class es para decir que se relaciona con la clase Doctor
        //'doctor_id' es para decir que se relaciona con el campo doctor_id
    }

        public function user_details()
        {
            //Aqui decimos que un usuario tiene relacion con un user_details
            return $this->hasOne(UserDetails::class, 'user_id');
            //aqui retornamos la relacion uno a uno con la tabla user_details
            //$this es para decir que se relaciona con el modelo User
            //hasOne es para decir que tiene un registro en la tabla user_details
            //UserDetails::class es para decir que se relaciona con la clase UserDetails
            //'user_id' es para decir que se relaciona con el campo user_id
        }
    }