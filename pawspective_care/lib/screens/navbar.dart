import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:pawspective_care/pallete.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int) onTap;
  final NotchBottomBarController notchBottomBarController; 

  const CustomBottomNavigationBar({
    Key? key,
    required this.onTap,
    required this.notchBottomBarController, // Remove the '?'
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedNotchBottomBar(
      kIconSize: 24,
      kBottomRadius: 20,
      bottomBarItems: [
        BottomBarItem(
          inActiveItem: SvgPicture.asset('assets/svgs/icon _paw.svg'),
          activeItem: SvgPicture.asset('assets/svgs/icon _paw.svg'),
        ),
        BottomBarItem(
          inActiveItem: SvgPicture.asset('assets/svgs/icon _chat bubble.svg'),
          activeItem: SvgPicture.asset('assets/svgs/icon _chat bubble.svg'),
        ),
        BottomBarItem(
          inActiveItem: SvgPicture.asset('assets/svgs/icon _home.svg'),
          activeItem: SvgPicture.asset('assets/svgs/icon _home.svg'),
        ),
        BottomBarItem(
          inActiveItem: SvgPicture.asset('assets/svgs/icon _doctor.svg'),
          activeItem: SvgPicture.asset('assets/svgs/icon _doctor.svg'),
        ),
        BottomBarItem(
          inActiveItem: SvgPicture.asset('assets/svgs/icon _profil.svg'),
          activeItem: SvgPicture.asset('assets/svgs/icon _profil.svg'),
        ),
      ],
      onTap: onTap,
      color: Palette.thirdColor,
      removeMargins: true,
      bottomBarWidth: MediaQuery.of(context).size.width,
      durationInMilliSeconds: 300,
      showLabel: true,
      itemLabelStyle: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
      showShadow: true,
      showBlurBottomBar: false,
      blurOpacity: 0.2,
      blurFilterX: 5.0,
      blurFilterY: 10.0,
      notchColor: Colors.black87,
      notchGradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Palette.thirdColor,
          Palette.secondaryColor
        ],
      ),
      showTopRadius: true,
      showBottomRadius: true,
      elevation: 2.0,
      bottomBarHeight: 62.0,
      notchBottomBarController: notchBottomBarController, // Pass the new parameter here
    );
  }
}
