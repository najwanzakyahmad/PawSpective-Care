import 'package:flutter/material.dart';
import 'package:animation_list/animation_list.dart';

import 'package:pawspective_care/pallete.dart';
import 'package:pawspective_care/screens/Information.dart';
import 'HomePage.dart';
import 'MyPetField.dart';
import 'MyPetFieldEdit.dart';
import 'navbar.dart';
import 'package:pawspective_care/network/api.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

class MyPet extends StatefulWidget {
  final String userId;
  const MyPet({Key? key, required this.userId}) : super(key: key);

  @override
  _MyPetState createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> {
  int _selectedIndex = 0; 
  String id = '';
  List<String> backendData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getDataNameFromBackEnd();
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

  Future<void> _getDataNameFromBackEnd() async {
    setState(() {
        isLoading = true;
    });
    final data = await Api.getDataNameFromBackEnd(widget.userId);
    setState(() {
      backendData = data;
      isLoading = false;
    });
  }

  Future<void> _deleteDataPet(BuildContext context, String id, String userId) async {
    await Api.deleteDataFromBackend(context, id, userId);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.mainColor,
      body: Center(
        child: isLoading
          ? CircularProgressIndicator() // Tampilkan animasi loading jika isLoading true
          : AnimationList(
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
                      MaterialPageRoute(builder: (context) => MyPetField(userId: widget.userId)),
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
                MaterialPageRoute(builder: (context) => MyPet(userId: widget.userId)),
              );
              break;
            case 1:
              // Ke halaman MyDoctor
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Information(userId : widget.userId)),
              );
              break;
            case 2:
              // Ke halaman MyPet
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
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
                      text: data.split(' - ')[1], 
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
                  MaterialPageRoute(builder: (context) => MyPetField(userId: widget.userId))
                );
              }, 
              icon: SvgPicture.asset('assets/svgs/icon book.svg'),
            ),
            
            const SizedBox(width: 20),
            IconButton(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => MyPetFieldEdit(id: data.split(' - ')[0], userId: widget.userId))
                );
              }, 
              icon: SvgPicture.asset('assets/svgs/icon edit.svg'),
            ),
            
            const SizedBox(width: 20),
            IconButton(
              onPressed: () async {
                await _deleteDataPet(context, data.split(' - ')[0], widget.userId);
              }, 
              icon: SvgPicture.asset('assets/svgs/icon delete.svg'),
            )
            
          ],
        ),
      ),
    );
  }
}
        

