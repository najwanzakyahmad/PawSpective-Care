<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
namespace App\Http\Controllers\Firebase;
use App\Http\Controllers\Controller;
use Kreait\Firebase\Contract\Database;
use Kreait\Firebase\Factory;
use Illuminate\Http\Request;

class PetController extends Controller
{
    
    public function __construct(Database $database)
    {
        $this->database = $database;
        $this->tablename = 'mypet';
    }


    public function store(Request $request)
    {
        try {
            $validatedData = $request->validate([
                'OwnerId' => 'required',
                'Parent' => 'required',
                'PetName' => 'required',
                'SpeciesName' => 'required',
                'selectedBreakFast' => 'required',
                'selectedDinner' => 'required',
                'selectedLunch' => 'required',
                'selectedDateBirth' => 'required',
                'selectedDateVaccine' => 'required'
            ]);

            $collectionRef = $this->database->getReference($this->tablename);

            $newDocRef = $collectionRef->push(); 
            $newDocId = $newDocRef->getKey();

            $postData = [
                'idPet' => $newDocId, 
                'OwnerId' => $request->input('OwnerId'),
                'Parent' => $request->input('Parent'),
                'PetName' => $request->input('PetName'),
                'SpeciesName' => $request->input('SpeciesName'),
                'selectedBreakFast' => $request->input('selectedBreakFast'),
                'selectedDinner' => $request->input('selectedDinner'),
                'selectedLunch' => $request->input('selectedLunch'),
                'selectedDateBirth' => $request->input('selectedDateBirth'),
                'selectedDateVaccine' => $request->input('selectedDateVaccine')
            ];

            $newPost = $newDocRef->set($postData);

            return response()->json(['success' => true, 'message' => 'Data added to Firebase', $postData]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }


    public function get($idPet)
    {
        try {
            $data = $this->database->getReference($this->tablename)->getValue();

            if (!empty($data)) {
                if (isset($data[$idPet])) {
                    return response()->json(['success' => true, 'data' => $data[$idPet]]);
                } else {
                    return response()->json(['success' => false, 'message' => 'Data not found for the specified id', $idPet]);
                }
            } else {
                return response()->json(['success' => false, 'message' => 'No data found']);
            }
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }

    public function getNameByOwnerId($OwnerId)
    {
        try {
            $data = $this->database->getReference($this->tablename)->getValue();

            $parentsWithId = [];

            if (!empty($data)) {
                foreach ($data as $id => $entry) {
                    if (isset($entry['OwnerId']) && $entry['OwnerId'] == $OwnerId && isset($entry['PetName'])) {
                        $parentsWithId[] = [
                            'id' => $id,
                            'PetName' => $entry['PetName']
                        ];
                    }
                }

                if (!empty($parentsWithId)) {
                    return response()->json(['success' => true, 'data' => $parentsWithId]);
                }
            }

            return response()->json(['success' => false, 'message' => 'No data found for the specified OwnerId']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }




    public function update(Request $request, $id)
    {
        try {
            $validatedData = $request->validate([
                'Parent' => 'required',
                'PetName' => 'required',
                'SpeciesName' => 'required',
                'selectedBreakFast' => 'required',
                'selectedDinner' => 'required',
                'selectedLunch' => 'required',
                'selectedDateBirth' => 'required',
                'selectedDateVaccine' => 'required'
            ]);

            $postData = ([
                'Parent' => $request->input('Parent'),
                'PetName' => $request->input('PetName'),
                'SpeciesName' => $request->input('SpeciesName'),
                'selectedBreakFast' => $request->input('selectedBreakFast'),
                'selectedDinner' => $request->input('selectedDinner'),
                'selectedLunch' => $request->input('selectedLunch'),
                'selectedDateBirth' => $request->input('selectedDateBirth'),
                'selectedDateVaccine' => $request->input('selectedDateVaccine')
            ]);

            $this->database->getReference($this->tablename . '/' . $id)->update($postData);

            return response()->json(['message' => 'Data berhasil diupdate'], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }

    public function delete($id)
    {
        try {
            
            $this->database->getReference($this->tablename . '/' . $id)->remove();
    
            return response()->json(['message' => 'Data berhasil dihapus'], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Terjadi kesalahan: ' . $e->getMessage()], 500);
        }
    }

    

}
