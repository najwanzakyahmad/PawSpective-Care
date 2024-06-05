<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
// use App\Http\Controllers\Firebase\AuthController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Firebase\UserController;
use App\Http\Controllers\Firebase\ArtikelController;
use App\Http\Controllers\Firebase\PetController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/artikel', [ArtikelController::class, 'create']);
Route::post('/mypet', [PetController::class, 'store']);
Route::get('/mypet', [PetController::class, 'get']);
Route::get('/mypet/getName', [PetController::class, 'getName']);
Route::get('/mypet/{id}', [PetController::class, 'getDataById']);
Route::put('/mypet/{id}', [PetController::class, 'update']);
Route::delete('/mypet/{id}', [PetController::class, 'delete']);

Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->get('/user', function (Request $request){
    return $request->user();
});
