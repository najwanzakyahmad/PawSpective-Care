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
    public function store(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'userId' => 'required',
                'username' => 'required',
                'email' => 'required',
                'phoneNumber' => 'required',
                'city' => 'required',
                'province' => 'required',
            ]);
    
            // Simpan data ke Firebase
            $collectionRef = $this->database->getReference($this->tablename);
            $newDocRef = $collectionRef->push();
            $newDocId = $newDocRef->getKey();
    
            $postData = [
                'userId' => $request->input('userId'),
                'username' => $request->input('username'),
                'email' => $request->input('email'),
                'phoneNumber' => $request->input('phoneNumber'),
                'city' => $request->input('city'),
                'province' => $request->input('province'),
            ];
    
            $newPost = $newDocRef->set($postData);
    
            return response()->json(['success' => true, 'message' => 'Profile updated successfully']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }
    public function getProfile($data)
    {
        try {
            $users = $this->database->getReference($this->tablename)->getValue();
    
            if (!empty($users)) {
                foreach ($users as $userId => $userData) {
                    if ($userData['userId'] == $data) {
                        return response()->json(['success' => true, 'data' => $userData]);
                    }
                }
                return response()->json(['success' => false, 'message' => 'Data not found']);
            } else {
                return response()->json(['success' => false, 'message' => 'No users found']);
            }
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }
    

    // Metode lain seperti get, update, dan delete bisa ditambahkan di sini

}