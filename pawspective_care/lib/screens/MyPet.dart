import 'package:flutter/material.dart';
import 'package:animation_list/animation_list.dart';

import 'package:pawspective_care/pallete.dart';
import 'HomePage.dart';
import 'MyPetField.dart';
import 'MyPetFieldEdit.dart';
import 'navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

class MyPet extends StatefulWidget {
  const MyPet({Key? key}) : super(key: key);

  @override
  _MyPetState createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> {
  int _selectedIndex = 0; 
  String id = '';
  List<String> backendData = [];

  @override
  void initState() {
    super.initState();
    getDataNameFromBackEnd();
  }


  Widget _buildTile(String title, Color backgroundColor) {
    return Container(
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: backgroundColor,
      ),
    );
  }

  Future<void> getDataNameFromBackEnd() async {
    try {
      final url = 'http://10.0.2.2:8000/api/mypet/getName';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] is List<dynamic>) {
          List<String> processedData = [];

          // Iterasi melalui setiap entri dalam data
          for (var entry in jsonData['data']) {
            // Periksa apakah entri memiliki kunci 'id' dan 'Parent'
            if (entry.containsKey('id') && entry.containsKey('Parent')) {
              // Tambahkan kombinasi 'id' dan 'Parent' ke dalam processedData
              processedData.add('${entry['id']} - ${entry['Parent']}');
            }
          }

          setState(() {
            backendData = processedData;
          });
          print('Response: ${response.body}');
        } else {
          print('Failed to get data. Invalid response format.');
        }
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


  Future<void> deleteDataFromBackend(BuildContext context, String id) async {
    final url = 'http://10.0.2.2:8000/api/mypet/$id'; // Gunakan ID untuk menentukan data yang akan dihapus
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Data berhasil dihapus!');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPet()));
    } else {
      print('Gagal menghapus data. Kode status: ${response.statusCode}');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPet()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.mainColor,
      body: Center(
        child: AnimationList(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: "MY PET",
                  style: GoogleFonts.inter(
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Gunakan map untuk mengubah setiap item dalam backendData menjadi widget
            ...backendData.map((data) => buildPetContainer(data)).toList(),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => MyPetField()),
                );
              },
              icon: SvgPicture.asset(
                'assets/svgs/icon plus.svg',
              ),
            )
          ],
          duration: 1000,
          reBounceDepth: 10.0,
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Handle navigation here based on index
          switch (index) {
            case 0:
              // Ke halaman MyPet
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPet()),
              );
              break;
            // case 1:
            //   // Ke halaman MyDoctor
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => MyDoctor()),
            //   );
            //   break;
            case 2:
              // Ke halaman MyPet
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            // case 3:
            //   // Ke halaman Chat
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => ChatPage()),
            //   );
            //   break;
            // case 4:
            //   // Ke halaman Profil
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => ProfilPage()),
            //   );
            //   break;
            // default:
            // break;
          }
        },
        notchBottomBarController: NotchBottomBarController(index: _selectedIndex),
      ),
    );
  }

  // Fungsi untuk membangun widget Container untuk setiap item dalam backendData
  Widget buildPetContainer(String data) {
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Palette.thirdColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Kucing kecil.png',
                ),
                const SizedBox(height: 10),
                Container(
                  width: 100,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: data.split(' - ')[1], // Ganti teks "Pussy" dengan data
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 40),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context)=> MyPetField())
                );
              }, 
              icon: SvgPicture.asset('assets/svgs/icon book.svg'),
            ),
            
            const SizedBox(width: 20),
            IconButton(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => MyPetFieldEdit(id: data.split(' - ')[0]))
                );
              }, 
              icon: SvgPicture.asset('assets/svgs/icon edit.svg'),
            ),
            
            const SizedBox(width: 20),
            IconButton(
              onPressed: (){
                Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => MyPet()));
              }, 
              icon: SvgPicture.asset('assets/svgs/icon delete.svg'),
            )
            
          ],
        ),
      ),
    );
  }

}
