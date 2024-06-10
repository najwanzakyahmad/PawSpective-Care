import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:pawspective_care/screens/updateProfilePage.dart';
import 'package:pawspective_care/screens/homepage.dart';
import 'package:pawspective_care/Services/getData.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pallete.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ProfileMenuWidget.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;
  late String _username = '';
  late String _email = '';

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil data dari backend saat widget diinisialisasi
    fetchData();
  }

  void fetchData() async {
    try {
      print(widget.userId);
      Map<String, dynamic> userData = await UserDataService.getUserData(widget.userId);
      print(userData);
      setState(() {
        // Perbarui state dengan data yang diperoleh
        _username = userData['name'] ?? 'Username Not Found';
        _email = userData['email'] ?? 'Email Not Found';
      });
      print(_username);
      print(_email);
    } catch (e) {
      print('Error fetching user data: $e'); // Tangkap dan cetak error jika terjadi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
            );
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid, color: Colors.white),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1F2544),
      ),
      body: Container(
        color: const Color(0xFF474F7A), // Warna latar belakang diterapkan di sini
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        child: const Icon(LineAwesomeIcons.pencil_alt_solid, size: 18.0, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username:', 
                        style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 20, color: Palette.white),
                      ),
                      Container(
                        width: double.infinity, // Mengatur lebar container
                        padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: Palette.fourthColor,
                        ),
                        child: Text(
                          _username,
                          style: TextStyle(
                            color: Palette.mainColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Email:', 
                        style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 20, color: Palette.white),
                      ),
                      Container(
                        width: double.infinity, // Mengatur lebar container
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: Palette.fourthColor,
                        ),
                        child: Text(
                          _email,
                          style: TextStyle(
                            color: Palette.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateProfileScreen(userId: widget.userId, username: _username, email: _email)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Edit Profile", style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Delete Profile", style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                ProfileMenuWidget(title: "Logout", icon: LineAwesomeIcons.sign_out_alt_solid, textColor: Colors.red, endIcon: false, onPress: () {}),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //     // Handle navigation here based on index
      //     switch (index) {
      //       case 0:
      //         // Ke halaman MyPet
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => MyPet(userId: widget.userId)),
      //         );
      //         break;
      //       case 2:
      //         // Ke halaman HomePage
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
      //         );
      //         break;
      //     }
      //   },
      //   notchBottomBarController: NotchBottomBarController(index: _selectedIndex),
      // ),
    );
  }
}
