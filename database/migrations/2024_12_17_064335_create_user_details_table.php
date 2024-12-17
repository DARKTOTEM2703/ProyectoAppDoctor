<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        //Aqui creamos las tablas que necesitamos para el proyecto
        //En este caso creamos la tabla user_details
        //Cuando un nuevo usuario se registra, se crea un nuevo registro en esta tabla
        Schema::create('user_details', function (Blueprint $table) {
            //Aqui definimos la id de manera autoincrementable
            $table->increments('id');
            //Aqui definimos el id del usuario
            $table->unsignedInteger('user_id')->unique(); //unsignedInteger es un entero sin signo y unique es para que no se repita
            //Aqui definimos el numero de pacientes que tiene el usuario
            $table->longText('bio_data'); // longText es para texto largo
            // Aqui definimos el estado del usuario
            $table->unsignedInteger('status') -> nullable(); // nullable es para que pueda ser nulo
            //Aqui relacionamos la tabla de usuarios con la tabla de user_details
            $table->foreign(columns: 'user_id')->references('id')->on('users')->onDelete('cascade');
            //onDelete('cascade') es para que si se elimina el usuario se elimine el user_details
            $table->timestamps(); //timestamps es para que se creen dos columnas en la tabla que se llaman created_at y updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_details');
    }
};