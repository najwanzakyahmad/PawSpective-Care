<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Firebase\AuthController;
use App\Http\Controllers\Firebase\UserController;
use App\Http\Controllers\Firebase\ArtikelController;
use App\Http\Controllers\Firebase\PetController;

Route::post('/auth/register', [AuthController::class, 'registrasi']);
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/checkToken', [AuthController::class, 'checkToken']);
Route::post('/auth/signout', [AuthController::class, 'logout']);

Route::post('/artikel', [ArtikelController::class, 'create']);
Route::post('/mypet', [PetController::class, 'store']);
Route::get('/mypet/{id}', [PetController::class, 'get']);
Route::get('/mypet/getName/{OwnerId}', [PetController::class, 'getNameByOwnerId']);
Route::put('/mypet/{id}', [PetController::class, 'update']);
Route::delete('/mypet/{id}', [PetController::class, 'delete']);


Route::middleware('auth:sanctum')->get('/user', function (Request $request){
    return $request->user();
});

Route::middleware('auth:sanctum')->group(function () {
    Route::get("/test", function () {
        return "test berhasil";
    });
    // Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/refresh', [AuthController::class, 'refresh']);
});

