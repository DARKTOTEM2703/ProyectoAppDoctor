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
        Schema::create('doctors', function (Blueprint $table) {
            $table->increments('id'); //Aqui el id se cambia a auto incrementable
            $table->unsignedBigInteger('doc_id')->unique(); //Aqui usamos unsignedBigInteger para que el id sea positivo
            $table->string('category')->nullable(); //Se agrega la cadena de txt para la categoria, pero asignamos nullable para que no sea obligatorio
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