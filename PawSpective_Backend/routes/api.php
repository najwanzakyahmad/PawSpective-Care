<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Firebase\AuthController;
use App\Http\Controllers\Firebase\QuestionController;
use App\Http\Controllers\Firebase\AnswerController;
use App\Http\Controllers\Firebase\ArtikelController;
use App\Http\Controllers\Firebase\PetController;
use App\Http\Controllers\Firebase\UserController;

Route::post('/auth/register', [AuthController::class, 'registrasi']);
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/checkToken', [AuthController::class, 'checkToken']);
Route::post('/auth/signout', [AuthController::class, 'logout']);

Route::post('/artikel', [ArtikelController::class, 'create']);

Route::post('/discussion/question', [QuestionController::class, 'postQuestion']);
Route::get('/discussion/question', [QuestionController::class, 'getQuestion']);
Route::get('/discussion/question/{questionId}', [QuestionController::class, 'getQuestionById']);

Route::post('/discussion/answer', [AnswerController::class, 'postAnswer']);
Route::get('/discussion/answer', [AnswerController::class, 'getAnswer']);
Route::get('/discussion/answer/{questionId}', [AnswerController::class, 'getAnswerByQuestion']);

Route::get('/user', [UserController::class, 'getUser']);
Route::get('/user/getUser/{id}', [UserController::class, 'getUserById']);
Route::get('/user/getId/{email}', [UserController::class, 'getIdByEmail']);

Route::post('/mypet', [PetController::class, 'store']);
Route::get('/mypet/{id}', [PetController::class, 'get']);
Route::get('/mypet/getName/{OwnerId}', [PetController::class, 'getNameByOwnerId']);
Route::put('/mypet/{id}', [PetController::class, 'update']);
Route::delete('/mypet/{id}', [PetController::class, 'delete']);


// Route::middleware('auth:sanctum')->get('/user', function (Request $request){
//     return $request->user();
// });

Route::middleware('auth:sanctum')->group(function () {
    Route::get("/test", function () {
        return "test berhasil";
    });
    // Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/refresh', [AuthController::class, 'refresh']);
});

