import 'package:flutter/material.dart';
import '../pallete.dart';


class RoundedButton extends StatelessWidget {
  final String btnText;
  final Function onBtnPressed;
  const RoundedButton(
    {super.key,required this.btnText, required this.onBtnPressed, required Widget child});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5, 
      color: Palette.grey,
      borderRadius: BorderRadius.circular(100),
      child: MaterialButton(
        onPressed: (){
          onBtnPressed();
        },
        minWidth: 120,
        height: 20,
        child: Text(
          btnText,
          style: const TextStyle(color: Palette.thirdColor, fontSize: 16), 
        )
      ),
    );
  }
}