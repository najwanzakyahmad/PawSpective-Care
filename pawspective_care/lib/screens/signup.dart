import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pawspective_care/Services/auth_services.dart';
import 'package:pawspective_care/Services/globals.dart';
import '../pallete.dart';
import 'package:pawspective_care/screens/login.dart';
import 'package:http/http.dart' as http;
import '../RoundedButton.dart'; // Jika file RoundedButton.dart berada di level yang sama dengan SignUpPage

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email = '';
  String _password = '';
  String _name = '';
  bool _isLoading = false;

  void createAccountPressed() async {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
    if (emailValid) {
      setState(() {
        _isLoading = true;
      });

      // Simulasi proses pembuatan akun
      await Future.delayed(Duration(seconds: 2));

      http.Response response = await AuthServices.register(_name, _email, _password);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseMap['success'] == false && responseMap['message'] == 'The email address is already in use by another account.'){
          errorSnackBar(context, 'Email address is already in use by another account');
        }
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage(),
            ));
      } else {
        errorSnackBar(context, responseMap.values.first[0]);
      }
    } else {
      errorSnackBar(context, 'Email not valid');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void errorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFF1F2544))),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                  color: const Color(0xFF474F7A),
                ),
                height: MediaQuery.of(context).size.height - 200,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'NAME',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFFD0EC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'EMAIL',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFFD0EC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text(
                            'PASSWORD',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFFD0EC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : createAccountPressed, // Nonaktifkan tombol jika isLoading true
                      child: _isLoading // Tampilkan CircularProgressIndicator jika isLoading true, jika tidak tampilkan teks tombol
                          ? CircularProgressIndicator() 
                          : Text("SIGN UP"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 250,
                      child: Material(
                        elevation: 5,
                        color: Palette.grey,
                        borderRadius: BorderRadius.circular(100),
                        child: MaterialButton(
                          onPressed: () {
                            // Add your Google sign-in logic here
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
                'SIGN UP',
                style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              bottom: 16, // Atur jarak dari bawah layar sesuai kebutuhan
              left: 0, // Atur posisi horizontal sesuai kebutuhan
              right: 0, // Atur posisi horizontal sesuai kebutuhan
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                  );
                },
                child: Text(
                  'Sudah punya akun? Login sekarang',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
