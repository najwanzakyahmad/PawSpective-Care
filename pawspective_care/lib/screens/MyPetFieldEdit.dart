import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawspective_care/screens/HomePage.dart';
import 'package:pawspective_care/network/api.dart';
import 'navbar.dart';
import 'package:pawspective_care/screens/FormFieldBuilder.dart';
import 'package:pawspective_care/pallete.dart';
import 'myPet.dart';

class MyPetFieldEdit extends StatefulWidget {
  final String id;
  final String userId;

  const MyPetFieldEdit({Key? key, required this.userId, required this.id}) : super(key: key);

  @override
  _MyPetFieldEditState createState() => _MyPetFieldEditState();
}

class _MyPetFieldEditState extends State<MyPetFieldEdit> {
  int _selectedIndex = 0;
  final format = DateFormat('HH:mm');
  final List<String> items = ['Kucing', 'Anjing'];
  String? speciesName, parent, petName, selectedValue;
  DateTime? selectedDateVaccine, selectedDateBirth;
  TimeOfDay? selectedBreakFast, selectedLunch, selectedDinner;
  TimeOfDay? selectedBreakFastData;
  TimeOfDay? selectedLunchData;
  TimeOfDay? selectedDinnerData;
  String speciesNameData = '';
  String parentData = '';
  String petNameData = '';
  String selectedDateBirthData = '';
  String selectedDateVaccineData = '';
  late String id;
  Map<String, dynamic> backendData = {};
  String petData = '';
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void onChanged(String? value) {
    setState(() {
      selectedValue = value;
    });
  }

  TimeOfDay? convertStringToTimeOfDay(String timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    final parts = timeString.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
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
    return DateTime.now();
  }

  Future<void> fetchData() async {
    try {
      await Api.getDataFromBackEnd(widget.id, (data) {
        setState(() {
          speciesNameData = data['SpeciesName'] ?? '';
          parentData = data['Parent'] ?? '';
          petNameData = data['PetName'] ?? '';
          selectedBreakFastData = data['selectedBreakFast'] != null ? convertStringToTimeOfDay(data['selectedBreakFast']) : null;
          selectedLunchData = data['selectedLunch'] != null ? convertStringToTimeOfDay(data['selectedLunch']) : null;
          selectedDinnerData = data['selectedDinner'] != null ? convertStringToTimeOfDay(data['selectedDinner']) : null;
          selectedDateBirthData = data['selectedDateBirth'] ?? '';
          selectedDateVaccineData = data['selectedDateVaccine'] ?? '';
        });
      });
      setState(() {
          isLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
          isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.mainColor,
      body: SingleChildScrollView(
        child: isLoading ? _buildLoading() : _buildContent(),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPet(userId: widget.userId)),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
              );
              break;
          }
        },
        notchBottomBarController: NotchBottomBarController(index: _selectedIndex),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(), 
    );
  }

  Widget _buildContent() {
    return Container(
      margin: const EdgeInsets.only(top: 50, bottom: 10, left: 20, right: 20),
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
              const SizedBox(width: 80),
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
          FormFieldsBuilder.buildDateFieldEdit(selectedDateBirthData, "TANGGAL LAHIR", (DateTime? date) {
            selectedDateBirth = date;
          }),
          const SizedBox(height: 15),
          FormFieldsBuilder.buildTimeFieldEdit("JADWAL MAKAN PAGI", selectedBreakFastData, (TimeOfDay? time) {
            selectedBreakFast = time;
          }),
          const SizedBox(height: 15),
          FormFieldsBuilder.buildTimeFieldEdit("JADWAL MAKAN SIANG", selectedLunchData, (TimeOfDay? time) {
            selectedLunch = time;
          }),
          const SizedBox(height: 15),
          FormFieldsBuilder.buildTimeFieldEdit("JADWAL MAKAN MALAM", selectedDinnerData, (TimeOfDay? time) {
            selectedDinner = time;
          }),
          const SizedBox(height: 15),
          FormFieldsBuilder.buildTextFieldEdit(parentData, "ORANG TUA", (String? value) {
            parent = value;
          }),
          const SizedBox(height: 15),
          FormFieldsBuilder.buildDateFieldEdit(selectedDateVaccineData, "TANGGAL VAKSINASI", (DateTime? date) {
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
                    MaterialPageRoute(builder: (context) => MyPet(userId: widget.userId)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 209, 72, 62),
                ),
                child: Text('Cancel', style: GoogleFonts.inter(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () {
                  Api.updateDataToBackend(
                    context,
                    widget.id, 
                    widget.userId, 
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
                child: Text('Update', style: GoogleFonts.inter(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}