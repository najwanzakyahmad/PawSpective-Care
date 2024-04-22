import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Text editing controllers for each field
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIGN UP'),
        backgroundColor: Color(0xFF1F2544),
      ),
      backgroundColor: Color(0xFF474F7A),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text above form fields
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Create your account',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),

              // Email field
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: _emailController,
                    decoration: InputDecoration(
                    labelText: 'EMAIL',
                    filled: true, // Aktifkan background fill
                    fillColor: Color(0xFFFFD0EC), // Warna latar belakang dalam format hexadecimal
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0), // Tambahkan BorderRadius di sini
                    ),
                  ),
                ),
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
                    labelText: 'Password',
                    filled: true, // Aktifkan background fill
                    fillColor: Color(0xFFFFD0EC), // Warna latar belakang dalam format hexadecimal
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0), // Tambahkan BorderRadius di sini
                    ),
                  ),
                  obscureText: true,
                ),
              ),

              // Confirm password field
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'CONFIRM PASSWORD',
                    filled: true, // Aktifkan background fill
                    fillColor: Color(0xFFFFD0EC), // Warna latar belakang dalam format hexadecimal
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0), // Tambahkan BorderRadius di sini
                    ),
                  ),
                  obscureText: true,
                ),
              ),

              // Sign up button
              Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle sign up logic here
                    // You can call an API or perform user registration here
                    print('Sign Up button pressed. Email: ${_emailController.text}, Username: ${_usernameController.text}, Password: ${_passwordController.text}');
                  },
                  child: Text('SIGN UP'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1F2544), // Perubahan pada line ini
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

              // Text below sign up button
              TextButton(
                onPressed: () {
                  // Handle navigation to login screen here
                  print('Sign-in button pressed');
                },
                child: Text('Sudah punya akun? Login sekarang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
