<?php

namespace App\Http\Controllers\Firebase;

use App\Http\Controllers\Controller;
use Kreait\Firebase\Contract\Database;
use Illuminate\Http\JsonResponse;
use Kreait\Firebase\Contract\Auth;
use Kreait\Firebase\Exception\FirebaseException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;


class UserController extends Controller
{
    protected $database;
    protected $tablename;

    public function __construct(Database $database)
    {
        $this->database = $database;
        $this->tablename = 'user';
    }

    public function index(): JsonResponse
    {
        try {
            // Dapatkan referensi ke node pengguna di database realtime
            $usersRef = $this->database->getReference('users');

            // Dapatkan data pengguna dari database realtime
            $usersSnapshot = $usersRef->getSnapshot();
            $usersSnapshotValue = $usersSnapshot->getValue();
            $currentUserId = auth()->id();
            

            $users = [];
            if (is_array($usersSnapshotValue)) {
                foreach ($usersSnapshotValue as $userId => $userData) {
                // Jika ID pengguna tidak sama dengan ID pengguna saat ini, tambahkan ke daftar pengguna
                if ($userId !== $currentUserId) {
                    $users[] = [
                        'id' => $userId,
                        'name' => $userData['name'], // Misalnya, asumsikan ada field 'name' di node pengguna
                        // Tambahkan informasi lain yang Anda perlukan dari node pengguna
                    ];
                }
            }
        }

            return $this->success($users);
        } catch (\Exception $e) {
            return $this->error($e->getMessage());
        }
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

}
