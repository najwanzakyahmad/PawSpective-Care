<?php

namespace App\Http\Controllers\Firebase;

use App\Http\Controllers\Controller;
use Kreait\Firebase\Contract\Database;
use Kreait\Firebase\Exception\FirebaseException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;


class UserController extends Controller
{
    public function __construct(Database $database)
    {
        $this->database = $database;
        $this->tablename = 'user';
    }

    public function getUser()
    {
        try {
            $data = $this->database->getReference($this->tablename)->getValue();

            if (!empty($data)) {
                return response()->json(['success' => true, 'data' => $data]);
            }else{
                return response()->json(['success' => true, 'data' => "Data not found"]);
            }
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }

    public function getUserById($userId)
    {
        try {
            $data = $this->database->getReference($this->tablename)->getValue();

            if (!empty($data)) {
                if (isset($data[$userId])) {
                    $name = $data[$userId]['name']; // Mengambil nilai 'name' dari data
                    return response()->json(['success' => true, 'data' => $name]); // Mengirimkan hanya 'name' sebagai data
                } else {
                    return response()->json(['success' => false, 'message' => 'Data not found for the specified id', $userId]);
                }
            } else {
                return response()->json(['success' => false, 'message' => 'No data found']);
            }
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }

    public function getIdByEmail($email)
    {
        try {
            $data = $this->database->getReference($this->tablename)->getValue();

            if (!empty($data)) {
                foreach ($data as $userId => $userData) {
                    if ($userData['email'] === $email) {
                        return response()->json(['success' => true, 'data' => $userId]);
                    }
                }
                return response()->json(['success' => false, 'message' => 'Data not found for the specified email']);
            } else {
                return response()->json(['success' => false, 'message' => 'No data found']);
            }
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }
    public function getUserId($userId)
    {
        try {
            $data = $this->database->getReference('user')->getValue();

            if (!empty($data)) {
                if (isset($data[$userId])) {
                    $name = $data[$userId]['name']; // Mengambil nilai 'name' dari data
                    return response()->json(['success' => true, 'data' => $name]); // Mengirimkan hanya 'name' sebagai data
                } else {
                    return response()->json(['success' => false, 'message' => 'Data not found for the specified id', $userId]);
                }
            } else {
                return response()->json(['success' => false, 'message' => 'No data found']);
            }
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }
    public function getUserdata($data)
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
    

}
