import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pawspective_care/Services/globals.dart'; // Pastikan Anda mengimpor atau mendefinisikan variabel baseURL dan header

class UserDataService {
  static Future<Map<String, dynamic>> getUserData(String userId) async {
    var url = Uri.parse('http://10.0.2.2:8000/api/getuser/$userId');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    // print(response.body);

    if (response.statusCode == 200) {
      // Respons sukses, parsing dan kembalikan data
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['data'];
    } else {
      // Gagal mendapatkan data, lempar exception
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> getAllUserData(String userId) async {
    var url = Uri.parse('http://10.0.2.2:8000/api/profile/$userId');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    print(response.body);

    if (response.statusCode == 200) {
      // Respons sukses, parsing dan kembalikan data
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['data'];
    } else {
      // Gagal mendapatkan data, lempar exception
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}