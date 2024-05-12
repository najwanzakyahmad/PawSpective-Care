<?php

namespace App\Http\Controllers\Firebase;

use App\Http\Controllers\Controller;
use Kreait\Firebase\Contract\Database;
use Illuminate\Http\Request;


class ArtikelController extends Controller
{
    public function __construct(Database $database)
    {
        $this->database = $database;
        $this->tablename = 'artikel';
    }

    public function create(Request $request)
    {
        try {
            $request->validate([
                'title' => 'required|string',
                'content' => 'required|string',
            ]);

            $collectionRef = $this->database->getReference($this->tablename);

            $newDocRef = $collectionRef->push(); 
            $newDocId = $newDocRef->getKey();

            $postData = [
                'idArticle' => $newDocId,
                'title' => $request->input('title'),
                'content' => $request->input('content')
            ];

            $newPost = $newDocRef->set($postData);

            return response()->json(['success' => true, 'message' => 'Data added to Firebase']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }
}