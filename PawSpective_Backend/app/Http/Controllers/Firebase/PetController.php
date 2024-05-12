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


    public function get()
    {
        try {
            $data = $this->database->getReference($this->tablename)->getValue();

            if (!empty($data)) {
                return response()->json(['success' => true, 'data' => $data]);
            } else {
                return response()->json(['success' => false, 'message' => 'No data found']);
            }
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }

    public function getName()
    {
        try {
            $data = $this->database->getReference($this->tablename)->getValue();

            $parentsWithId = [];

            if (!empty($data)) {
                foreach ($data as $id => $entry) {
                    if (isset($entry['Parent'])) {
                        $parentsWithId[] = [
                            'id' => $id,
                            'Parent' => $entry['Parent']
                        ];
                    }
                }

                if (!empty($parentsWithId)) {
                    return response()->json(['success' => true, 'data' => $parentsWithId]);
                }
            }

            return response()->json(['success' => false, 'message' => 'No data found']);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }



    public function getDataById($id)
    {
        try {
            $data = $this->database->getReference($this->tablename)->getValue();

            if (!empty($data)) {
                if (isset($data[$id])) {
                    $entry = $data[$id];

                    $speciesName = isset($entry['SpeciesName']) ? $entry['SpeciesName'] : null;
                    $parent = isset($entry['Parent']) ? $entry['Parent'] : null;
                    $petName = isset($entry['PetName']) ? $entry['PetName'] : null;
                    $selectedBreakFast = isset($entry['selectedBreakFast']) ? $entry['selectedBreakFast'] : null;
                    $selectedLunch = isset($entry['selectedLunch']) ? $entry['selectedLunch'] : null;
                    $selectedDinner = isset($entry['selectedDinner']) ? $entry['selectedDinner'] : null;
                    $selectedDateBirth = isset($entry['selectedDateBirth']) ? $entry['selectedDateBirth'] : null;
                    $selectedDateVaccine = isset($entry['selectedDateVaccine']) ? $entry['selectedDateVaccine'] : null;

                    return response()->json([
                        'success' => true,
                        'data' => [
                            'speciesName' => $speciesName,
                            'parent' => $parent,
                            'petName' => $petName,
                            'selectedBreakFast' => $selectedBreakFast,
                            'selectedLunch' => $selectedLunch,
                            'selectedDinner' => $selectedDinner,
                            'selectedDateBirth' => $selectedDateBirth,
                            'selectedDateVaccine' => $selectedDateVaccine,
                        ]
                    ]);
                } else {
                    return response()->json(['success' => false, 'message' => 'No data found for the specified ID']);
                }
            } else {
                return response()->json(['success' => false, 'message' => 'No data found']);
            }
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
