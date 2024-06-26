import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawspective_care/screens/DiscussionPage.dart';
import 'package:pawspective_care/screens/MyPet.dart';
import 'package:pawspective_care/screens/MyPetField.dart';
import 'package:pawspective_care/screens/MyPetFieldEdit.dart';

import '../screens/DiscussionQuestion.dart';

class Api {

  static Future<List<String>> getDataNameFromBackEnd(String userId) async {
    try {
      final url = 'http://10.0.2.2:8000/api/mypet/getName/$userId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] is List<dynamic>) {
          List<String> processedData = [];

          for (var entry in jsonData['data']) {
            if (entry.containsKey('id') && entry.containsKey('PetName')) {
              processedData.add('${entry['id']} - ${entry['PetName']}');
            }
          }

          print('Response: ${response.body}');
          return processedData;
        } else {
          print('Failed to get data. Invalid response format.');
        }
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return [];
  }

  static Future<void> getDataFromBackEnd(String id, Function(Map<String, dynamic>) onDataReceived) async {
    try {
      final url = 'http://10.0.2.2:8000/api/mypet/$id';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] != null) {
          Map<String, dynamic> data = jsonData['data'];
          onDataReceived(data); // Call the callback function with the fetched data
        } else {
          print('Failed to get data. Data is null.');
        }
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  static Future<void> sendDataToBackend(
      BuildContext context, String userId,
      String parent, String petName, String speciesName,
      TimeOfDay selectedDinner, TimeOfDay selectedBreakFast, TimeOfDay selectedLunch,
      DateTime selectedDateBirth, DateTime selectedDateVaccine
  ) async {
    final url = 'http://10.0.2.2:8000/api/mypet';
    final response = await http.post(
      Uri.parse(url),
      body: { 
        'OwnerId': userId,
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
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPet(userId: userId)));
    } else {
      print('Gagal mengirim data. Kode status: ${response.statusCode}');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPetField(userId: userId)));
    }
  }

  static Future<void> updateDataToBackend(
    BuildContext context,
    String id, String userId,
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
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyPet(userId: userId)));
    } else {
      print('Gagal mengupdate data. Kode status: ${response.statusCode}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyPetFieldEdit(id: id, userId: userId)));
    }
  }

  // Fungsi untuk menghapus data
  static Future<void> deleteDataFromBackend(BuildContext context, String id, String userId) async {
    final url = 'http://10.0.2.2:8000/api/mypet/$id'; // Gunakan ID untuk menentukan data yang akan dihapus
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Data berhasil dihapus!');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPet(userId: userId)));
    } else {
      print('Gagal menghapus data. Kode status: ${response.statusCode}');
    }
  }

  static Future<void> getQuestion(Function(Map<String, dynamic>) onDataReceived) async {
    try {
      final url = 'http://10.0.2.2:8000/api/discussion/question';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] != null) {
          Map<String, dynamic> data = jsonData['data'];
          onDataReceived(data); 
        } else {
          print('Failed to get data. Data is null.');
        }
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  static Future<void> getQuestionById(String questionId, Function(Map<String, dynamic>) onDataReceived) async {
    try {
      final url = 'http://10.0.2.2:8000/api/discussion/question/$questionId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] != null) {
          Map<String, dynamic> data = jsonData['data'];
          onDataReceived(data); 
        } else {
          print('Failed to get data. Data is null.');
        }
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  static Future<void> postQuestion(
    BuildContext context, String userId, 
    String question, DateTime? created
  ) async {
    final url = 'http://10.0.2.2:8000/api/discussion/question';
    final response = await http.post(
      Uri.parse(url),
      body: { 
        'userId' : userId,
        'question' : question,
        'created' : created.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('Data berhasil dikirim!');
    } else {
      print('Gagal mengirim data. Kode status: ${response.statusCode}');
    }
  }

  static Future<void> postAnswer(
    BuildContext context, String userId, 
    String answer, DateTime? created, String questionId,
  ) async {
    final url = 'http://10.0.2.2:8000/api/discussion/answer';
    final response = await http.post(
      Uri.parse(url),
      body: { 
        'userId' : userId,
        'answer' : answer,
        'questionId' : questionId,
        'created' : created.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('Data berhasil dikirim!');
    } else {
      print('Gagal mengirim data. Kode status: ${response.statusCode}');
    }
  }

  static Future<void> getAnswerByQuestion(String questionId, Function(Map<String, dynamic>) onDataReceived) async {
    try {
      final url = 'http://10.0.2.2:8000/api/discussion/answer/$questionId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] != null) {
          Map<String, dynamic> data = jsonData['data'];
          onDataReceived(data); 
        } else {
          print('Failed to get data. Data is null.');
        }
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  static Future<String> getUserById(String userId) async {
    try {
      final url = 'http://10.0.2.2:8000/api/user/getUser/$userId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] != null) {
          return jsonData['data'];
        } else {
          throw Exception('Failed to get data. Data is null.');
        }
      } else {
        throw Exception('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  static Future<String> getIdByEmail(String email) async {
    try {
      final url = 'http://10.0.2.2:8000/api/user/getId/$email';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] != null) {
          return jsonData['data'];
        } else {
          throw Exception('Failed to get data. Data is null.');
        }
      } else {
        throw Exception('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
