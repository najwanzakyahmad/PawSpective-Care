import 'package:flutter/material.dart';
import 'package:proyek4/screens/bottom_navbar.dart';
import 'package:proyek4/screens/chat_page.dart';
import 'package:proyek4/pallete.dart';

class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AIChatPage(), bottomNavigationBar: BottomNavbar());
  }
}
