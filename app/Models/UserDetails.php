<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserDetails extends Model
{
     //hasFactory sirve para crear registros de prueba
     use HasFactory;
     /*
        este es un array que contiene los campos que se pueden asignar masivamente
        por lo que se pueden crear registros en la tabla
        con estos campos
      */
        protected $fillable = [
            //Estas son las columnas de la tabla user_details
            'user_id',
            'bio_data',
            'status',
        ];


        //aqui usaremos un belongsTo para la relacion uno a uno con la tabla user
        public function user()
        {
            //Aqui decimos que un usuario tiene relacion con un doctor
            return $this->belongsTo(User::class);
        }
    }
