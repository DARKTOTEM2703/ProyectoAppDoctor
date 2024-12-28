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

        //Aqui se crea la base de datos de doctores
        //y esta tabla doctor hará referencia a la tabla de usuarios
        //cuando un nuevo doctor se registre, doctor details creara
        Schema::create('doctors', function (Blueprint $table) {
            $table->increments(column: 'id'); //Aqui el id se cambia a auto incrementable
            $table->unsignedBigInteger('doc_id')->unique(); //Aqui usamos unsignedBigInteger para que el id sea positivo
            $table->string('category')->nullable(); //Se agrega la cadena de txt para la categoria, pero asignamos nullable para que no sea obligatorio
            $table->unsignedInteger('patients')->nullable(); //Aqui se agrega el numero de pacientes, pero asignamos nullable para que no sea obligatorio
            $table->unsignedInteger('experience')->nullable(); //Aqui se agrega la experiencia, pero asignamos nullable para que no sea obligatorio
            $table->longText('bio_data')->nullable(); //Aqui se agrega la bio data, pero asignamos nullable para que no sea obligatorio
            $table->string('status')->nullable();//Aqui se agrega la cadena de txt para el status, pero asignamos nullable para que no sea obligatorio


            $table->timestamps();//Aqui se agrega la fecha de creacion y actualizacion
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