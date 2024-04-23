import 'package:flutter/material.dart';
import 'package:proyek4/pallete.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Palette.thirdColor,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      // selectedItemColor: Color.fromRGBO(129, 104, 157, 1),
      unselectedItemColor: Palette.fourthColor,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Search",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medication),
          label: "Message",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medication_liquid_rounded),
          label: "Medication",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Person",
        ),
      ],
    );
  }
}
