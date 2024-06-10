import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:pawspective_care/screens/FormFieldBuilder.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pallete.dart';
import 'package:http/http.dart' as http;

class UpdateProfileScreen extends StatefulWidget {
  final String userId;
  final String username;
  final String email;

  const UpdateProfileScreen({
    Key? key,
    required this.userId,
    required this.username,
    required this.email,
  }) : super(key: key); // Menambahkan super(key: key)

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  String? _phoneNumber, _city, _province;

  void updateProfile() async {
    var url = 'https://your-laravel-backend.com/update-profile';

    var response = await http.post(Uri.parse(url), body: {
      'userId': widget.userId,
      'phoneNumber': _phoneNumber,
      'city': _city,
      'province': _province,
    });

    if (response.statusCode == 200) {
      print('Profile updated successfully');
    } else {
      print('Failed to update profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid, color: Colors.white),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1F2544),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF474F7A),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset('assets/images/21.jpg'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    top: 85,
                    left: 80,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xFFFFD0EC),
                      ),
                      child: const Icon(
                        LineAwesomeIcons.camera_retro_solid,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    const SizedBox(height: 50, width: 100,),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Username:', 
                            style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize:20,color: Palette.white),
                          ),
                          Container(
                            width: double.infinity, // Mengatur lebar container
                            padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              color: Palette.fourthColor,
                            ),
                            child: Text(
                              widget.username,
                              style: TextStyle(
                                color: Palette.mainColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Email:', 
                            style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize:20,color: Palette.white),
                          ),
                          Container(
                            width: double.infinity, // Mengatur lebar container
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              color: Palette.fourthColor,
                            ),
                            child: Text(
                              widget.email,
                              style: TextStyle(
                                color: Palette.mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),
                    FormFieldsBuilder.buildTextField("Nomor Telepon", (String? value) {
                      setState(() {
                        _phoneNumber = value;
                      });
                    }),
                    const SizedBox(height: 15),
                    FormFieldsBuilder.buildTextField("Kota", (String? value) {
                      setState(() {
                        _city = value;
                      });
                    }),
                    const SizedBox(height: 15),
                    FormFieldsBuilder.buildTextField("Provinsi", (String? value) {
                      setState(() {
                        _province = value;
                      });
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  updateProfile();
                },
                child: const Text("Update Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
