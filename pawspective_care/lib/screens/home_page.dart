import 'package:flutter/material.dart';
import 'package:pawspective_care/screens/bottom_navbar.dart';
import 'package:pawspective_care/screens/chat_page.dart';
import 'package:pawspective_care/pallete.dart';

class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AIChatPage(), bottomNavigationBar: BottomNavbar());
  }
}
