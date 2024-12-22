<?php

namespace App\Actions\Fortify;
use App\Models\Doctor;
use App\Models\User;
use App\Models\UserDetails;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Laravel\Fortify\Contracts\CreatesNewUsers;
use Laravel\Jetstream\Jetstream;

// Este es el registro nuevo de usuario/doctor

class CreateNewUser implements CreatesNewUsers
{
    use PasswordValidationRules;

    public function create(array $input)
    {
        Validator::make($input, [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => $this->passwordRules(),
            'terms' => Jetstream::hasTermsAndPrivacyPolicyFeature() ? ['accepted', 'required'] : '',
        ])->validate();

        $user = User::create([
            'name' => $input['name'],
            'email' => $input['email'],
            'type'=>$input['type'], // añadimos el campo type para diferenciar entre usuario y doctor
            'password' => Hash::make($input['password']),
        ]);

        /*Este if es para que si el tipo de usuario es doctor
        se cree un registro en la tabla doctors
        con los campos que se pueden asignar masivamente
        que estan en el array $fillable de la clase Doctor
         */

        if($input['type'] == 'doctor'){
            $doctorInfo = Doctor::create([
            'name'=>$input['name'],
            'email'=>$input['email'],
            'type'=>$input['type'],
            'password'=>Hash::make($input['password']),
            ]);

            /* Este if es para que si el tipo de usuario es user
            se cree un registro en la tabla user_details
            con los campos que se pueden asignar masivamente
            que estan en el array $fillable de la clase UserDetails
            */

            if($input['type'] == 'doctor'){
                $doctorInfo = Doctor::create([
                    'doctor_id'=>$user->id,
                    'status'=>'active',
                ]);
            }
            /*este else if es para que si el tipo de usuario es user
            se cree un registro en la tabla user_details
            con los campos que se pueden asignar masivamente
            que estan en el array $fillable de la clase UserDetails
             */

            else if($input['type'] == 'user'){
                $userInfo = UserDetails::create([
                    'user_id'=>$user->id,
                    'status'=>'active',
                ]);
            }
            //ahora, añadimos una entrada al registro form

            return $user;
        }
    }
}
