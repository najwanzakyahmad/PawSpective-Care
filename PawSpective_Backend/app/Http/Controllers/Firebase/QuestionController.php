<?php

namespace App\Http\Controllers\Firebase;

use App\Http\Controllers\Controller;
use Kreait\Firebase\Contract\Database;
use Kreait\Firebase\Exception\FirebaseException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;


class QuestionController extends Controller
{
    public function __construct(Database $database)
    {
        $this->database = $database;
        $this->tablename = 'question';
    }

    public function getQuestion()
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

    public function getQuestionById($questionId)
    {
        try {
            $data = $this->database->getReference($this->tablename)->getValue();

            if (!empty($data)) {
                if (isset($data[$questionId])) {
                    $question = $data[$questionId];
                    return response()->json(['success' => true, 'data' => $question]);
                } else {
                    return response()->json(['success' => true, 'data' => "Question not found"]);
                }
            } else {
                return response()->json(['success' => true, 'data' => "Data not found"]);
            }
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }


    public function postQuestion(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'userId' => 'required',
                'question' => 'required',
                'created' => 'required'
            ]);

            $collectionRef = $this->database->getReference($this->tablename);
            
            $newDocRef = $collectionRef->push();
            $newDocId = $newDocRef->getKey();

            $postData = [
                'questionId' => $newDocId,
                'userId' => $request->input('userId'),
                'question' => $request->input('question'),
                'created' => $request->input('created')
            ];

            $newpost = $newDocRef->set($postData);

            return response()->json(['success' => true, 'data' => $postData]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }
}
