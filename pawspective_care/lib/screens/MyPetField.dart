import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pawspective_care/screens/HomePage.dart';
import 'package:pawspective_care/network/api.dart';
import 'package:pawspective_care/screens/FormFieldBuilder.dart';
import 'package:pawspective_care/pallete.dart';
import 'MyPet.dart';
import 'navbar.dart';


class MyPetField extends StatefulWidget {
  const MyPetField({Key? key}) : super(key: key);

  @override
  _MyPetFieldState createState() => _MyPetFieldState();
}

class _MyPetFieldState extends State<MyPetField>{
  int _selectedIndex = 0; 
  final format = DateFormat('HH:mm');
  final List<String> items = ['Kucing', 'Anjing'];
  String? speciesName, parent, petName, selectedValue;
  DateTime? selectedDateVaccine, selectedDateBirth; 
  TimeOfDay? selectedBreakFast = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay? selectedLunch, selectedDinner;
  

  void onChanged(String? value) {
    setState(() {
      selectedValue = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.mainColor,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50, bottom: 10, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  RichText(
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
                  SizedBox(width: 80),
                  SvgPicture.asset('assets/images/kucing hitam.svg'),
                ],
              ),

              FormFieldsBuilder.buildDropDownField("JENIS HEWAN", items),

              const SizedBox(height: 15),
              FormFieldsBuilder.buildTextField("NAMA JENIS", (String? value) {
                speciesName = value;
              }),
              const SizedBox(height: 15),
              FormFieldsBuilder.buildTextField("NAMA PELIHARAAN", (String? value) {
                petName = value;
              }),

              const SizedBox(height: 15),
              FormFieldsBuilder.buildDateField("TANGGAL LAHIR", (DateTime? date){
                selectedDateBirth = date;
              }),

              const SizedBox(height: 15),
              FormFieldsBuilder.buildTimeField("JADWAL MAKAN PAGI", selectedBreakFast, (TimeOfDay? time){
                selectedBreakFast = time;
              }),

              const SizedBox(height: 15),
              FormFieldsBuilder.buildTimeField("JADWAL MAKAN SIANG", selectedLunch, (TimeOfDay? time){
                selectedLunch = time;
              }),
              
              const SizedBox(height: 15),
              FormFieldsBuilder.buildTimeField("JADWAL MAKAN MALAM", selectedDinner, (TimeOfDay? time){
                selectedDinner = time;
              }),

              const SizedBox(height: 15),
              FormFieldsBuilder.buildTextField("ORANG TUA", (String? value) {
                parent = value;
              }),

              const SizedBox(height: 15),
              FormFieldsBuilder.buildDateField("TANGGAL VAKSINASI", (DateTime? date){
                selectedDateVaccine = date;
              }),    

              const SizedBox(height: 15),  
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 209, 72, 62),
                    ),
                    child: Text('Back', style:GoogleFonts.inter( color: Colors.white,),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                        sendDataToBackend(
                          context,
                          parent!, petName!, speciesName!,
                          selectedDinner!, selectedBreakFast!, selectedLunch!,
                          selectedDateBirth!, selectedDateVaccine!,
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.thirdColor,
                    ),
                    child: 
                    Text('Next', style:GoogleFonts.inter( color: Colors.white,),),
                  ),
                  
                ]
              ),    
            ],
          ),
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

   
}
