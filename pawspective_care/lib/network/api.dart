import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawspective_care/screens/MyPet.dart';
import 'package:pawspective_care/screens/MyPetField.dart';
import 'package:pawspective_care/screens/MyPetFieldEdit.dart';

Future<void>    sendDataToBackend(
      BuildContext context,
      String parent, String petName, String speciesName,
      TimeOfDay selectedDinner, TimeOfDay selectedBreakFast, TimeOfDay selectedLunch,
      DateTime selectedDateBirth, DateTime selectedDateVaccine
    ) async {
    final url = 'http://10.0.2.2:8000/api/mypet';
    final response = await http.post(
      Uri.parse(url),
      body: { 
        'Parent': parent,
        'SpeciesName': speciesName,
        'PetName': petName,

        'selectedBreakFast': '${selectedBreakFast.hour}:${selectedBreakFast.minute}',
        'selectedDinner': '${selectedDinner.hour}:${selectedDinner.minute}',
        'selectedLunch': '${selectedLunch.hour}:${selectedLunch.minute}', 

        'selectedDateBirth': '${selectedDateBirth.day}-${selectedDateBirth.month}-${selectedDateBirth.year}',
        'selectedDateVaccine': '${selectedDateVaccine.day}-${selectedDateVaccine.month}-${selectedDateVaccine.year}',      
      },
    );

    if (response.statusCode == 200) {
      print('Data berhasil dikirim!');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPet()));
    } else {
      print('Gagal mengirim data. Kode status: ${response.statusCode}');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPetField()));
    }
  }


  Future<void> getDataFromBackEnd() async {
    try {
      final url = 'http://10.0.2.2:8000/api/mypet';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }


    // Fungsi untuk mengirim data untuk update
  Future<void> updateDataToBackend(
    BuildContext context,
    String id, // ID data yang akan diupdate
    String parent, String petName, String speciesName,
    TimeOfDay? selectedDinner, TimeOfDay? selectedBreakFast, TimeOfDay? selectedLunch,
    DateTime? selectedDateBirth, DateTime? selectedDateVaccine
  ) async {
    final url = 'http://10.0.2.2:8000/api/mypet/$id'; // Gunakan ID untuk menentukan data yang akan diupdate
    final response = await http.put(
      Uri.parse(url),
      body: { 
        'Parent': parent,
        'SpeciesName': speciesName,
        'PetName': petName,

        'selectedBreakFast': selectedBreakFast != null ? '${selectedBreakFast.hour}:${selectedBreakFast.minute}' : '',
        'selectedDinner': selectedDinner != null ? '${selectedDinner.hour}:${selectedDinner.minute}' : '',
        'selectedLunch': selectedLunch != null ? '${selectedLunch.hour}:${selectedLunch.minute}' : '', 

        'selectedDateBirth': selectedDateBirth != null ? '${selectedDateBirth.day}-${selectedDateBirth.month}-${selectedDateBirth.year}' : '',
        'selectedDateVaccine': selectedDateVaccine != null ? '${selectedDateVaccine.day}-${selectedDateVaccine.month}-${selectedDateVaccine.year}' : '',      
      },
    );

    if (response.statusCode == 200) {
      print('Data berhasil diupdate!');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPet()));
    } else {
      print('Gagal mengupdate data. Kode status: ${response.statusCode}');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPet()));
    }
  }

  // Fungsi untuk menghapus data
  Future<void> deleteDataFromBackend(BuildContext context, String id) async {
    final url = 'http://10.0.2.2:8000/api/mypet/$id'; // Gunakan ID untuk menentukan data yang akan dihapus
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Data berhasil dihapus!');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPet()));
    } else {
      print('Gagal menghapus data. Kode status: ${response.statusCode}');
    }
  }

}
