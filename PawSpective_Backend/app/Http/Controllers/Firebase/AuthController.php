<?php

namespace App\Http\Controllers\Firebase;

use App\Http\Controllers\Controller;
use Kreait\Firebase\Contract\Database;
use Kreait\Firebase\Contract\Auth;
use Kreait\Firebase\Exception\Auth\RevokedIdToken;
use Kreait\Firebase\Exception\FirebaseException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;


class AuthController extends Controller
{
  protected $auth;
  protected $database;
  protected $tablename;
  
  public function __construct(Database $database, Auth $auth)
  {
    $this->database = $database;
    $this->tablename = 'user';
    $this->auth = $auth;
  }

  public function registrasi(Request $request)
  {
      try {
          $request->validate([
              'name' => 'required|string',
              'email' => 'required|email|unique:users,email',
              'password' => 'required|string',
          ]);

          // Create user in Firebase Authentication
          $user = $this->auth->createUserWithEmailAndPassword($request->input('email'), $request->input('password'));
          $id = $user->uid;

          // Prepare data to store in Realtime Database
          $postData = [
              'userId' => $id,
              'name' => $request->input('name'),
              'email' => $request->input('email'),
              'password' => Hash::make($request->input('password')),
          ];

          // Store user data in Realtime Database
          $this->database->getReference($this->tablename)->getChild($id)->set($postData);

          return response()->json(['success' => true, 'message' => 'Data added to Firebase and user created']);
      } catch (\Exception $e) {
          return response()->json(['success' => false, 'message' => $e->getMessage()]);
      }
  }

  public function login(Request $request)
  {
    try {
      $request->validate([
        'email' => 'required|email',
        'password' => 'required|string',
      ]);

      $email = $request->input('email');
      $password = $request->input('password');

      $signInResult = $this->auth->signInWithEmailAndPassword($email, $password);
      $idToken = $signInResult->idToken();

      // Set masa kadaluwarsa jadi satu jam
      // $customClaims = [
      //   'expires_in' => time() + 3600,
      // ];
      // $this->auth->setCustomUserClaims($signInResult->firebaseUserId(), $customClaims);

      return response()->json(['token' => $idToken], 200);
    } catch (\Exception $e) {
      return response()->json(['message' => $e->getMessage()], 401);
    }
  }

  public function logout(Request $request)
  {
    $response = (object) [];
    $token = $request->bearerToken();
    $response->token = $token;

    try {
      $verifiedIdToken = $this->auth->verifyIdToken($token);
      $uid = $verifiedIdToken->claims()->get('sub');

      $this->auth->revokeRefreshTokens($uid);

      return response()->json(['message' => 'Logout berhasil'], 200);
    } catch (FirebaseException $e) {
      return response()->json(['error' => $e->getMessage()], 500);
    }
  }

  public function checkToken(Request $request)
  {
    $token = $request->bearerToken();

    try {
      $verifiedIdToken = $this->auth->verifyIdToken($token);

      $expirationTime = $verifiedIdToken->claims()->get('expires_in');
      if (time() >= $expirationTime) {
        return response()->json(['error' => 'The token is invalid'], 401);
      }

      $email = $verifiedIdToken->claims()->get('email');
      $uid = $verifiedIdToken->claims()->get('sub');
      $user = $this->auth->getUser($uid);

      return response()->json([
        'email' => $email,
        'uid' => $uid,
        'user' => $user
      ], 200);
    } catch (FailedToVerifyToken $e) {
      return response()->json(['error' => 'The token is invalid'], 401);
    } catch (FirebaseException $e) {
      return response()->json(['error' => $e->getMessage()], 500);
    }
  }
}
