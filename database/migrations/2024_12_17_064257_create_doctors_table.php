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
        //y esta tabla hace referencia a la tabla de usuarios
        //cuando el nuevo doctor se registra, se crea un nuevo registro en esta tabla
        Schema::create('doctors', function (Blueprint $table) {
            //Aqui definimos la id de manera autoincrementable
            $table->increments('id');
            //Aqui definimos el id del doctor
            $table->unsignedInteger('doctor_id')->unique(); //unsignedInteger es un entero sin signo y unique es para que no se repita
            //Aqui definimos el numero de pacientes que tiene el doctor
            $table->string('category');
            //Aqui definimos el numero de pacientes que tiene el doctor
            $table->unsignedInteger('patients')->nullable(); // nullable es para que pueda ser nulo
            //Aqui definimos el numero de años de experiencia que tiene el doctor
            $table->unsignedInteger('experiences')->nullable(); // nullable es para que pueda ser nulo
            // Aqui definimos los datos biograficos del doctor
            $table->longText('bio_data'); // longText es para texto largo
            // Aqui definimos el estado del doctor
            $table->unsignedInteger('status') -> nullable(); // nullable es para que pueda ser nulo
            //Aqui relacionamos la tabla de doctores con la tabla de usuarios
            $table->foreign('doctor_id')->references('id')->on('users')->onDelete('cascade');
            //onDelete('cascade') es para que si se elimina el usuario se elimine el doctor


            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('doctors');
    }
};