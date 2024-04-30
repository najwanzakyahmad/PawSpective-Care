import 'package:flutter/material.dart';
import 'package:pawspective_care/pallete.dart';

class ChatMessage {
  final String messageContent;
  final String messageType;

  ChatMessage({required this.messageContent, required this.messageType});
}

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Halo, Arya", messageType: "receiver"),
    ChatMessage(messageContent: "Apa kabar?", messageType: "receiver"),
    ChatMessage(
        messageContent: "Hei Agam, aku baik2 aja. wbu?", messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, oke lah.", messageType: "receiver"),
    ChatMessage(messageContent: "bjir bang", messageType: "sender"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Palette.thirdColor,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                const CircleAvatar(
                  backgroundImage: AssetImage("images/batmanpfp.jpg"),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Agam",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.pets_outlined,
                        size: 16,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // body: Container());
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == "receiver"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Palette.grey,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      messages[index].messageContent,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Palette.thirdColor,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Tulis Pesan...",
                          fillColor: Palette.grey,
                          filled: true,
                          hintStyle: const TextStyle(color: Palette.fontColor),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none)),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Palette.fourthColor,
                        size: 30,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Palette.thirdColor,
                    elevation: 0,
                    child: const Icon(
                      Icons.send_outlined,
                      color: Palette.fourthColor,
                      size: 26,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
