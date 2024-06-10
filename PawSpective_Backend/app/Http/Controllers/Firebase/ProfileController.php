<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
namespace App\Http\Controllers\Firebase;
use App\Http\Controllers\Controller;
use Kreait\Firebase\Contract\Database;
use Kreait\Firebase\Factory;
use Illuminate\Http\Request;

class ProfileController extends Controller
{

    public function __construct(Database $database)
    {
        $this->database = $database;
        $this->tablename = 'profile';
    }
    public function updateProfile(Request $request)
    {
        try {
            // Validasi data yang diterima
            $validatedData = $request->validate([
                '_username' => 'required',
                '_email' => 'required',
                '_password' => 'required',
                '_phoneNumber' => 'required',
                '_city' => 'required',
                '_province' => 'required',
            ]);
    
            // Simpan data ke Firebase
            $collectionRef = $this->database->getReference($this->tablename);
            $newDocRef = $collectionRef->push();
            $newDocId = $newDocRef->getKey();
    
            $postData = [
                '_username' => $request->input('Username'),
                '_email' => $request->input('Email'),
                '_password' => $request->input('Password'),
                '_phoneNumber' => $request->input('PhoneNumber'),
                '_city' => $request->input('City'),
                '_province' => $request->input('Province'),
            ];
    
            $newPost = $newDocRef->set($postData);
    
            return response()->json(['success' => true, 'message' => 'Profile updated successfully']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }
    

    // Metode lain seperti get, update, dan delete bisa ditambahkan di sini

}