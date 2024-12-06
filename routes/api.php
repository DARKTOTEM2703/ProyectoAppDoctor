<?php
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/users', function () {
return response()->json([
'users' => [
['id' => 1, 'name' => 'John Doe'],
['id' => 2, 'name' => 'Jane Doe']
]
]);
});
