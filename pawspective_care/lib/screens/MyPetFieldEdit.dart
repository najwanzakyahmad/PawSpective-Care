import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pawspective_care/screens/HomePage.dart';
import 'package:pawspective_care/network/api.dart';
import 'navbar.dart';
import 'package:pawspective_care/screens/FormFieldBuilder.dart';
import 'package:pawspective_care/pallete.dart';
import 'myPet.dart';


class MyPetFieldEdit extends StatefulWidget {
  final String id;

  const MyPetFieldEdit({Key? key, required this.id}) : super(key: key);

  @override
  _MyPetFieldEditState createState() => _MyPetFieldEditState();
}

class _MyPetFieldEditState extends State<MyPetFieldEdit>{
  int _selectedIndex = 0;
  final format = DateFormat('HH:mm');
  final List<String> items = ['Kucing', 'Anjing'];
  String? speciesName, parent, petName, selectedValue;
  DateTime? selectedDateVaccine, selectedDateBirth; 
  TimeOfDay? selectedBreakFast = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay? selectedLunch, selectedDinner;
  late String speciesNameData = '';
  late String parentData = '';
  late String petNameData = '';
  late TimeOfDay selectedBreakFastData = TimeOfDay(hour: 0, minute: 0);
  late TimeOfDay selectedLunchData = TimeOfDay(hour: 0, minute: 0);
  late TimeOfDay selectedDinnerData = TimeOfDay(hour: 0, minute: 0);
  late String selectedDateBirthData = '';
  late String selectedDateVaccineData = '';
  late String id;

  Map<String, dynamic> backendData = {};
  

  @override
  void initState() {
    super.initState();
    getDataFromBackEnd();
  }

  void onChanged(String? value) {
    setState(() {
      selectedValue = value;
    });
  }

  TimeOfDay convertStringToTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  DateTime parseDate(String dateString) {
    final List<String> parts = dateString.split('-');
    if (parts.length == 3) {
      final int day = int.tryParse(parts[0]) ?? 1;
      final int month = int.tryParse(parts[1]) ?? 1;
      final int year = int.tryParse(parts[2]) ?? DateTime.now().year;
      return DateTime(year, month, day);
    }
    // Jika format tidak sesuai, kembalikan tanggal default
    return DateTime.now();
  }

  Future<void> getDataFromBackEnd() async {
    try {
      final url = 'http://10.0.2.2:8000/api/mypet/${widget.id}'; // Sesuaikan URL dengan endpoint Anda
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        // Pengecekan untuk memastikan bahwa data tidak null
        if (jsonData.containsKey('data') && jsonData['data'] != null) {
          // Ambil nilai dari objek 'data' dalam respons
          Map<String, dynamic> data = jsonData['data'];

          // Tetapkan nilai dari objek 'data' ke variabel-variabel yang sesuai
          setState(() {
            speciesNameData = data['speciesName'] ?? ''; // Penambahan pengecekan untuk setiap nilai
            parentData = data['parent'] ?? '';
            petNameData = data['petName'] ?? '';
            selectedBreakFastData = convertStringToTimeOfDay(data['selectedBreakFast'] ?? '');
            selectedLunchData = convertStringToTimeOfDay(data['selectedLunch'] ?? '');
            selectedDinnerData = convertStringToTimeOfDay(data['selectedDinner'] ?? '');
            selectedDateBirthData = data['selectedDateBirth'] ?? '';
            selectedDateVaccineData = data['selectedDateVaccine'] ?? '';
          });

          print('Response: ${response.body}');
        } else {
          print('Failed to get data. Data is null.');
        }
      } else {
        print('Failed to get data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


  Future<void> updateDataToBackend(
    BuildContext context,
    String id, // ID data yang akan diupdate
    String parent, String petName, String speciesName,
    TimeOfDay? selectedDinner, TimeOfDay? selectedBreakFast, TimeOfDay? selectedLunch,
    DateTime? selectedDateBirth, DateTime? selectedDateVaccine
  ) async {
    final url = 'http://10.0.2.2:8000/api/mypet/${widget.id}'; // Gunakan ID untuk menentukan data yang akan diupdate
    final response = await http.put(
      Uri.parse(url),
      body: { 
        'Parent': parent,
        'SpeciesName': speciesName,
        'PetName': petName,

        'selectedBreakFast': selectedBreakFast != null ? '${selectedBreakFast.hour}:${selectedBreakFast.minute}' : '',
        'selectedDinner': selectedDinner != null ? '${selectedDinner.hour}:${selectedDinner.minute}' : '',
        'selectedLunch': selectedLunch != null ? '${selectedLunch.hour}:${selectedLunch.minute}' : '', 

        'selectedDateBirth': selectedDateBirth != null ? '${selectedDateBirth.day}-${selectedDateBirth.month}-${selectedDateBirth.year}' : '',
        'selectedDateVaccine': selectedDateVaccine != null ? '${selectedDateVaccine.day}-${selectedDateVaccine.month}-${selectedDateVaccine.year}' : '',      
      },
    );

    if (response.statusCode == 200) {
      print('Data berhasil diupdate!');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPet()));
    } else {
      print('Gagal mengupdate data. Kode status: ${response.statusCode}');
      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyPetFieldEdit(id: widget.id,)));
    }
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
              FormFieldsBuilder.buildTextFieldEdit(speciesNameData, "NAMA JENIS", (String? value) {
                speciesName = value;
              }),
              const SizedBox(height: 15),
              FormFieldsBuilder.buildTextFieldEdit(petNameData, "NAMA PELIHARAAN", (String? value) {
                petName = value;
              }),

              const SizedBox(height: 15),
              FormFieldsBuilder.buildDateFieldEdit(selectedDateBirthData, "TANGGAL LAHIR",  (DateTime? date){
                selectedDateBirth = date;
              }),

              const SizedBox(height: 15),
              FormFieldsBuilder.buildTimeFieldEdit("JADWAL MAKAN PAGI", selectedBreakFastData, (TimeOfDay? time){
                selectedBreakFast = time;
              }),

              const SizedBox(height: 15),
              FormFieldsBuilder.buildTimeFieldEdit("JADWAL MAKAN SIANG", selectedLunchData, (TimeOfDay? time){
                selectedLunch = time;
              }),
                            
              const SizedBox(height: 15),
              FormFieldsBuilder.buildTimeFieldEdit("JADWAL MAKAN MALAM", selectedDinnerData, (TimeOfDay? time){
                selectedDinner = time;
              }),

              const SizedBox(height: 15),
              FormFieldsBuilder.buildTextFieldEdit(parentData, "ORANG TUA", (String? value) {
                parent = value;
              }),

              const SizedBox(height: 15),
              FormFieldsBuilder.buildDateFieldEdit(selectedDateVaccineData, "TANGGAL VAKSINASI", (DateTime? date){
                selectedDateVaccine = date;
              }),   


              const SizedBox(height: 15),  
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context)=> MyPet()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 209, 72, 62),
                    ),
                    child: Text('Cancel', style:GoogleFonts.inter( color: Colors.white,),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      updateDataToBackend(
                        context,
                        id = widget.id,
                        parent ?? parentData,
                        petName ?? petNameData,
                        speciesName ?? speciesNameData,
                        selectedDinner ?? selectedDinnerData,
                        selectedBreakFast ?? selectedBreakFastData,
                        selectedLunch ?? selectedLunchData,
                        selectedDateBirth ?? parseDate(selectedDateBirthData),
                        selectedDateVaccine ?? parseDate(selectedDateVaccineData),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.thirdColor,
                    ),
                    child: 
                    Text('Update', style:GoogleFonts.inter( color: Colors.white,),),
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
