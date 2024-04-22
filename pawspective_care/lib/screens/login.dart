import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers for username and password fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
        backgroundColor: Color(0xFF1F2544),
      ),
      backgroundColor: Color(0xFF474F7A),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // App logo
              Container(
                height: 150,
                width: 150,
                child: Image.asset('assets/app_logo.png'), // Replace with your logo image
              ),

              // Username field
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'USERNAME',
                    filled: true, // Aktifkan background fill
                    fillColor: Color(0xFFFFD0EC), // Warna latar belakang dalam format hexadecimal
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0), // Tambahkan BorderRadius di sini
                    ),
                  ),
                ),
              ),

              // Password field
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'PASSWORD',
                    filled: true, // Aktifkan background fill
                    fillColor: Color(0xFFFFD0EC), // Warna latar belakang dalam format hexadecimal
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0), // Tambahkan BorderRadius di sini
                    ),
                  ),
                  obscureText: true,
                ),
              ),

              // Login button
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle login logic here
                    // You can call an API or perform authentication here
                    print('Login button pressed. Username: ${_usernameController.text}, Password: ${_passwordController.text}');
                  },
                  child: Text('LOGIN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2544), // Perbaikan di sini
                  ),
                ),
              ),

              // Divider line
              Divider(
                thickness: 1.0,
              ),

              // Google sign-in button
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/google.png', height: 24), // Replace with your Google sign-in icon image
                    Text('  Sign in with Google'),
                  ],
                ),
              ),

              // Text for sign-up
              TextButton(
                onPressed: () {
                  // Handle sign-up navigation here
                  print('Sign-up button pressed');
                },
                child: Text('Belum punya akun? Sign up sekarang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}