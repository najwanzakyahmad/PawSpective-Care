import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';

import 'package:pawspective_care/pallete.dart';
import 'DiscussionPage.dart';
import 'HomePage.dart';
import 'MyPet.dart';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:pawspective_care/screens/navbar.dart';

class Information extends StatefulWidget {
  final String userId;
  const Information({Key? key, required this.userId}) : super(key: key);

  @override
  _Information createState() => _Information();
}

class _Information extends State<Information>{
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children :[
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => DiscussionPage(userId: widget.userId)));
              },
              child: Image.asset(
                'assets/images/Kucing kecil.png',
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap:() {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)));
              },
              child: Image.asset(
                'assets/images/Kucing.png',
              ),
            ),
          ],
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
                MaterialPageRoute(builder: (context) => Information(userId: widget.userId)),
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
            //     MaterialPageRoute(builder: (context) => MyDoctor()),
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
}