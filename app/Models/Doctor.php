<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;// Import the HasFactory trait
use Illuminate\Database\Eloquent\Model; // Import the Model class



class Doctor extends Model // Model sirve para interactuar con la base de datos
{

    //hasFactory sirve para crear registros de prueba
    use HasFactory;
 // protected $fillable es un array que contiene los campos que se pueden asignar masivamente
    protected $fillable = [
        /*Estas son las columnas de la tabla doctors
        las cuales se pueden asignar masivamente
        por lo que se pueden crear registros en la tabla
        con estos campos*/
        'doctor_id',
        'category',
        'patients',
        'experiences',
        'bio_data',
        'status',
    ];

    //aqui creamos un metodo para la relacion uno a uno con la tabla user

    public function user()
    {

        return $this->belongsTo(User::class);
    }
}
