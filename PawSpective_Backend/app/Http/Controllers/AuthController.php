<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    function register(Request $req){
        $rules=[
            'name'=>"required|string",
            'email'=>"required|string|unique:users",
            'password'=>"required|string|min:6",
        ];
        $validator = Validator::make($req->all(), $rules);
        if($validator->fails()){
            return response()->json($validator->errors(), 400);
        }
        $user = User::create([
            'name'=>$req->name,
            'email'=>$req->email,
            'password'=>Hash::make($req->password)
        ]);
        $token = $user->createToken('Personal Access Token')->plainTextToken;
        $response = ['user'=>$user, 'token'=>$token];
        return response()->json($response, 200);
    }
    function login(Request $req) {
        $rules=[
            'email'=> 'required',
            'password'=>'required|string'
        ];
        $req->validate($rules);
        $user = User::where('email', $req->email)->first();
        if($user && Hash::check($req->password, $user->password)){
            $token = $user->createToken('Personal Access Token')->plainTextToken;
            $response=['user'=>$user, 'token'=>$token];
            return response()->json($response, 200);
        }
        $response = ['message'=>'Incorrect email or password'];
        return response()->json($response, 400);
    }
}
