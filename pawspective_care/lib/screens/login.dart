import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawspective_care/Services/auth_services.dart';
import 'package:pawspective_care/Services/globals.dart';
import 'package:pawspective_care/RoundedButton.dart';
import 'package:pawspective_care/screens/homepage.dart';
import 'package:pawspective_care/screens/starting.dart';
import 'package:pawspective_care/screens/signup.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../network/api.dart';
import '../pallete.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  bool _isLoading = false; 

  void loginPressed() async {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      setState(() {
        _isLoading = true; 
      });
      try {
        http.Response response = await AuthServices.login(_email, _password);
        Map<String, dynamic> responseMap = jsonDecode(response.body);
        
        if (response.statusCode == 200) {
          String token = responseMap['token'];
          print('Token: $token'); // Log the token
          
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          print('Decoded Token: $decodedToken'); // Log the decoded token
          
          String email = decodedToken['email'];
          String userId = await Api.getIdByEmail(email);
          
          if (userId.isNotEmpty) {
            print('userId : $userId');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomePage(userId: userId),
              ),
            );
          } else {
            errorSnackBar(context, 'Invalid token: uid is null');
          }
        } else {
          errorSnackBar(context, responseMap.values.first);
        }
      } catch (e) {
        errorSnackBar(context, 'Error during login');
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false; // Set isLoading ke false setelah proses login selesai
        });
      }
    } else {
      errorSnackBar(context, 'Enter all fields');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1F2544),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: const Color(0xFF474F7A),
              ),
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // App logo
                  // SizedBox(
                  //   height: 150,
                  //   width: 150,
                  //   child: Image.asset('assets/app_logo.png'), // Replace with your logo image
                  // ),

                  // Username field
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                      decoration: InputDecoration(
                        label:Text('EMAIL', style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),), 
                        filled: true, // Aktifkan background fill
                        fillColor: const Color(0xFFFFD0EC), // Warna latar belakang dalam format hexadecimal
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0), // Tambahkan BorderRadius di sini
                        ),
                      ),
                    ),
                  ),

                  // Password field
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                      decoration: InputDecoration(
                        label:Text('PASSWORD', style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),), 
                        filled: true, // Aktifkan background fill
                        fillColor: const Color(0xFFFFD0EC), // Warna latar belakang dalam format hexadecimal
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0), // Tambahkan BorderRadius di sini
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : loginPressed, // Nonaktifkan tombol jika isLoading true
                    child: _isLoading // Tampilkan CircularProgressIndicator jika isLoading true, jika tidak tampilkan teks tombol
                        ? CircularProgressIndicator() 
                        : Text("LOGIN"),
                  ),

                  const SizedBox(height: 30),

                  Container(width: 250,
                    child: Material(
                      elevation: 5, 
                      color: Palette.grey,
                      borderRadius: BorderRadius.circular(100),
                      child: MaterialButton(
                        onPressed: (){
                          ;
                        },
                        minWidth: 120,
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/google.png', height: 24), // Replace 'google_icon.png' with your actual image asset
                            SizedBox(width: 5), // Add some spacing between the image and text
                            Text(
                              'Sign in with Google',
                              style: const TextStyle(color: Palette.thirdColor, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 160, left: 25),
            child: Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 16, // Atur jarak dari bawah layar sesuai kebutuhan
            left: 0,   // Atur posisi horizontal sesuai kebutuhan
            right: 0,  // Atur posisi horizontal sesuai kebutuhan
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SignUpPage(),
                  ),
                );
              },
              child: Text('Belum punya akun? Daftar sekarang',
              textAlign: TextAlign.center, 
              style: TextStyle(color: Colors.white,)),
            ),
          ),
        ],
      ),
    );
  }
}
