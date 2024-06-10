import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawspective_care/pallete.dart';
import 'package:pawspective_care/screens/MyPet.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:pawspective_care/screens/navbar.dart';
import 'package:pawspective_care/screens/profilePage.dart';


class HomePage extends StatefulWidget {
  final String userId;
  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2; 

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: Palette.mainColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 27),
              _topBar(),
              _gap(),
              _greetings(),
              _gap(),
              _myPet(),
              _gap(),
              _discussSession(),
              _gap(),
               Expanded(child: Container()),
            ],
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.6,
            child: _article(),
          ),
        ],
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
                MaterialPageRoute(builder: (context) => MyPet(userId: widget.userId)),
              );
              break;
            // case 1:
            //   // Ke halaman MyDoctor
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => ChatPage()),
            //   );
            //   break;
            case 2:
              // Ke halaman MyPet
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
              );
              break;
            // case 3:
            //   // Ke halaman Chat
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => MyDoctor()),
            //   );
            //   break;
            case 4:
              // Ke halaman Profil
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(userId: widget.userId)),
              );
              break;
            // default:
            // break;
          }
        },
        notchBottomBarController: NotchBottomBarController(index: _selectedIndex),
      ),
    );
  }

  DraggableScrollableSheet _article() {
    List<Widget> titles = List.generate(
      20,
      (index) => ListTile(
        title: Text(
          'Title ${index + 1}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Palette.white,
          ),
        ),
      ),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          
          decoration: const BoxDecoration(
            color: Palette.mainColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), 
              topRight: Radius.circular(20))
          ),
          child: ListView(
            controller: scrollController,
            children: [
              SizedBox(height: 10),
              ...titles,
            ],
          ),
        );
      },
    );
  }

  Container _discussSession() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      height: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 20,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "TRENDING DISCUSS",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
            height: 103,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _discussTopic(),
                _discussTopic(),
                _discussTopic(),
                _discussTopic(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _discussTopic() {
    return GestureDetector(
      onTap: () {
        // Tindakan yang ingin dilakukan ketika widget ditekan
        debugPrint('Discuss topic tapped.');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                color: Palette.fourthColor,
              ),
            ),
            SizedBox(height: 4),
            Flexible(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Pussy",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _gap() {
    return const SizedBox(
      height: 10,
    );
  }

  Container _search() {
    return Container(
      width: 306,
      height: 50,
      child: TextFormField(
        style: const TextStyle(
          color: Palette.white,
        ),
        decoration: InputDecoration(
          suffixIcon: const Icon(
            Icons.search,
            color: Palette.fourthColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          filled: true,
          fillColor: Palette.secondaryColor,
        ),
      ),
    );
  }

  AspectRatio _myPet() {
    return AspectRatio(
      aspectRatio: 336 / 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cardMyPet(),
                _nextButtonMyPet(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _nextButtonMyPet() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Palette.fourthColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              debugPrint("Button MyPet tapped");
            },
            icon: const Icon(
              Icons.chevron_right,
              color: Palette.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _cardMyPet() {
    return GestureDetector(
      onTap: () {
        //link kemana
        debugPrint('Card tapped.');
      },
      child: Container(
        width: 136,
        height: 148,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xff474f7a),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Kucing kecil.png',
            ),
            SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Pussy",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AspectRatio _greetings() {
    return AspectRatio(
      aspectRatio: 336 / 184,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xff474f7a),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: "HELLO\nUSER!",
                      style: GoogleFonts.inter(
                        fontSize: 45,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Image.asset(
              'assets/images/Kucing.png',
              height: 137,
              width: 155,
            ),
          ],
        ),
      ),
    );
  }

  Padding _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _search(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              color: Color(0xffffd9bf),
            ),
          )
        ],
      ),
    );
  }
}
