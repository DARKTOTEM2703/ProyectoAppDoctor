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
        Schema::create('user_details', callback: function (Blueprint $table) {
         $table->increments('id'); //Creamos una id autoincremental para que el usuario tenga un id único en la base de datos
         $table->unsignedInteger('user_id')->unique(); //Creamos un id de usuario único y positivo
         $table->string('category')->nullable(); //Creamos una cadena de texto para la categoria, pero asignamos nullable para que no sea obligatorio
         $table->unsignedInteger('patients')->nullable(); //Creamos un numero de pacientes, pero asignamos nullable para que no sea obligatorio
         $table->unsignedInteger('experience')->nullable(); //Creamos la experiencia, pero asignamos nullable para que no sea obligatorio
         $table->longText('bio_data')->nullable(); //Creamos la bio data, pero asignamos nullable para que no sea obligatorio
         $table->string('status')->nullable(); //Creamos una cadena de texto para el status, pero asignamos nullable para que no sea obligatorio
         $table->foreign('user')->references('id')->on('users')->onDelete('cascade'); //Creamos una llave foranea de usuario que hace referencia a la tabla de usuarios y se agrega onDelete('cascade') para que si se elimina el usuario, se elimine tambien el detalle del usuario
         $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade'); //Creamos una llave foranea de user_id que hace referencia a la tabla de usuarios y se agrega onDelete('cascade') para que si se elimina el usuario, se elimine tambien el detalle del usuario
         $table->timestamps(); //Creamos la fecha de creacion y actualizacion
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
