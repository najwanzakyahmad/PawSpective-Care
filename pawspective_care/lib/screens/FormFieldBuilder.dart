import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animated_drop_down_form_field/animated_drop_down_form_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_format_field/date_format_field.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:pawspective_care/pallete.dart';

class FormFieldsBuilder {
  static final DateFormat format = DateFormat('HH:mm');

  static Widget buildDateField(String labelText, Function(DateTime?) onComplete) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        SizedBox(height: 27),
        Text(
          labelText, 
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize:20,color: Palette.white),
        ),
        DateFormatField(
          type: DateFormatType.type4,
          onComplete: onComplete,
          decoration: InputDecoration(
            fillColor: Palette.fourthColor,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ), 
        ),
      ],
    );
  }

  static Widget buildDropDownField(String labelText, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        Text(
          labelText, 
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize:20,color: Palette.white),
        ),
        AnimatedDropDownFormField(
          items: items.map((item) => Text(item)).toList(),
          dropDownAnimationParameters:const SizingDropDownAnimationParameters(
            axis:Axis.vertical,
            duration: Duration(seconds:1),
            curve:Curves.linear,
          ),
          
          buttonDecoration:BoxDecoration(
            color: Palette.fourthColor,
            borderRadius: BorderRadius.circular(14),
          ),
          listBackgroundDecoration: BoxDecoration(
            color: Palette.fourthColor,
            borderRadius: BorderRadius.circular(14),
          ),
          
          listHeight: 100,
          listPadding: EdgeInsets.only(bottom: 5),
          listScrollPhysics: BouncingScrollPhysics(),
        ),
      ],
    );
  }

  static Widget buildTextField(String labelText, Function(String?) onSave) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Atur teks dimulai dari kiri
      children: [
        Text(
          labelText, 
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize:20,color: Palette.white),
        ),
        TextFormField(
          style: const TextStyle(
            color: Palette.mainColor,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
            filled: true,
            fillColor: Palette.fourthColor,
          ),
          onChanged : onSave,
        ),
      ],
    );
  }

  static Widget buildTimeField(String labelText, TimeOfDay? initialValue, Function(TimeOfDay?) onSave) {
    final initialDateTime = DateTime.now().add(Duration(hours: initialValue?.hour ?? 0, minutes: initialValue?.minute ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.white),
        ),
        DateTimeField(
          format: format,
          initialValue: initialDateTime, 
          style: TextStyle(color: Palette.mainColor),
          decoration: InputDecoration(
            fillColor: Palette.fourthColor,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            suffixIcon: Icon(Icons.access_time),
          ),
          onShowPicker: (context, currentValue) async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            if (time != null) {
              onSave(time);
              return DateTimeField.convert(time);
            }
          },
          onChanged: (dateTime) {
            if (dateTime != null) {
              final newTime = TimeOfDay.fromDateTime(dateTime);
              onSave(newTime);
            }
          },
        ),
      ],
    );
  }


  //////////untuk edit
  static Widget buildDateFieldEdit(String hintText, String labelText, Function(DateTime?) onComplete) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        SizedBox(height: 27),
        Text(
          labelText, 
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize:20,color: Palette.white),
        ),
        DateFormatField(
          type: DateFormatType.type4,
          onComplete: onComplete,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Palette.fourthColor,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ), 
        ),
      ],
    );
  }

  static Widget buildDropDownFieldEdit(String hintText, String labelText, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        Text(
          labelText, 
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize:20,color: Palette.white),
        ),
        AnimatedDropDownFormField(
          items: items.map((item) => Text(item)).toList(),
          dropDownAnimationParameters:const SizingDropDownAnimationParameters(
            axis:Axis.vertical,
            duration: Duration(seconds:1),
            curve:Curves.linear,
          ),
          
          buttonDecoration:BoxDecoration(
            color: Palette.fourthColor,
            borderRadius: BorderRadius.circular(14),
          ),
          listBackgroundDecoration: BoxDecoration(
            color: Palette.fourthColor,
            borderRadius: BorderRadius.circular(14),
          ),
          
          listHeight: 100,
          listPadding: EdgeInsets.only(bottom: 5),
          listScrollPhysics: BouncingScrollPhysics(),
        ),
      ],
    );
  }

  static Widget buildTextFieldEdit(String hintText, String labelText, Function(String?) onSave) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Atur teks dimulai dari kiri
      children: [
        Text(
          labelText, 
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize:20,color: Palette.white),
        ),
        TextFormField(
          style: const TextStyle(
            color: Palette.mainColor,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
            filled: true,
            fillColor: Palette.fourthColor,
          ),
          onChanged : onSave,
        ),
      ],
    );
  }

  static Widget buildTimeFieldEdit(String labelText, TimeOfDay? initialValue, Function(TimeOfDay?) onSave) {
    final initialDateTime = DateTime.now().add(Duration(hours: initialValue?.hour ?? 0, minutes: initialValue?.minute ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.white),
        ),
        DateTimeField(
          format: format,
          initialValue: initialDateTime, 
          style: TextStyle(color: Palette.mainColor),
          decoration: InputDecoration(
            fillColor: Palette.fourthColor,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            suffixIcon: Icon(Icons.access_time),
          ),
          onShowPicker: (context, currentValue) async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            if (time != null) {
              onSave(time);
              return DateTimeField.convert(time);
            }
          },
          onChanged: (dateTime) {
            if (dateTime != null) {
              final newTime = TimeOfDay.fromDateTime(dateTime);
              onSave(newTime);
            }
          },
        ),
      ],
    );
  }

}
