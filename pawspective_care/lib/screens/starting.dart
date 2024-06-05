import 'package:flutter/material.dart';
import 'package:pawspective_care/screens/login.dart';

class starting extends StatelessWidget {
  const starting({super.key});

  @override
  Widget build(BuildContext context){

    Future.delayed(const Duration(seconds: 3)).then((value) => {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ), 
        (route) => false
      )
    });

    return Scaffold(
      // body: Stack(children: [Image.asset('assets/images/starting.png', fit: BoxFit.fill)],),
      backgroundColor: Color(0xff1f2544),   
    );
  }
}