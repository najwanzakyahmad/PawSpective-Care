<?php

namespace App\Http\Controllers\Firebase;

use App\Http\Controllers\Controller;
use Kreait\Firebase\Contract\Database;
use Kreait\Firebase\Exception\FirebaseException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;


class AnswerController extends Controller
{
    public function __construct(Database $database)
    {
        $this->database = $database;
        $this->tablename = 'answer';
    }

    public function getAnswer()
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

    public function getAnswerByQuestion($questionId)
    {
        try {
            $data = $this->database->getReference($this->tablename)->getValue();

            if (!empty($data)) {
                $answers = [];

                foreach ($data as $answerId => $answer) {
                    if ($answer['questionId'] === $questionId) {
                        $answers[$answerId] = $answer;
                    }
                }

                if (!empty($answers)) {
                    return response()->json(['success' => true, 'data' => $answers]);
                } else {
                    return response()->json(['success' => false, 'message' => 'Answer not found']);
                }
            } else {
                return response()->json(['success' => false, 'message' => 'Data not found']);
            }
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }



    public function postAnswer(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'userId' => 'required',
                'questionId' => 'required',
                'answer' => 'required',
                'created' => 'required'
            ]);

            $collectionRef = $this->database->getReference($this->tablename);
            
            $newDocRef = $collectionRef->push();
            $newDocId = $newDocRef->getKey();

            $postData = [
                'answerId' => $newDocId,
                'questionId' => $request->input('questionId'),
                'userId' => $request->input('userId'),
                'answer' => $request->input('answer'),
                'created' => $request->input('created')
            ];

            $newpost = $newDocRef->set($postData);

            return response()->json(['success' => true, 'data' => $postData]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }
}
