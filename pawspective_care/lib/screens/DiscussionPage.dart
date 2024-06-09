import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import pustaka intl
import 'package:pawspective_care/pallete.dart';
import 'package:pawspective_care/network/api.dart';
import 'package:pawspective_care/screens/Information.dart';
import '../Services/globals.dart';
import 'DiscussionQuestion.dart';

class DiscussionPage extends StatefulWidget {
  final String userId;
  const DiscussionPage({Key? key, required this.userId}) : super(key: key);

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  final List<Map<String, dynamic>> questions = [];
  final TextEditingController questionController = TextEditingController();
  String question = '';
  DateTime? created;
  String author= '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getQuestions();
  }

  Future<void> getQuestions() async {
    setState(() {
      _isLoading = true; // Mulai loading
    });
    try {
      await Api.getQuestion((data) async {
        print('data : $data');
        List<Map<String, dynamic>> questionList = data.entries
            .map((entry) => Map<String, dynamic>.from(entry.value))
            .toList();
        
        print('questionList : $questionList');
        List<Map<String, dynamic>> fetchedQuestions = [];

        for (var question in questionList) {
          try {
            String? userId = question['userId'];
            if (userId != null) {
              var userName = await Api.getUserById(userId);
              
              fetchedQuestions.add({
                'question': question['question'],
                'Author': userName,
                'created': DateFormat('dd/MM/yyyy').format(DateTime.parse(question['created'])), // Ubah format tanggal
                'questionId': question['questionId']
              });

              print('Successfully fetched question: $question');
            } else {
              print('User ID is null for question: $question');
            }
          } catch (error) {
            print('Error fetching user data: $error');
          }
        }

        setState(() {
          questions.addAll(fetchedQuestions);
          _isLoading = false; // Berhenti loading
        });
      });
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _isLoading = false; // Berhenti loading di kasus error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.mainColor,
      appBar: AppBar(
        backgroundColor: Palette.fourthColor,
        title: Text('Discussion Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator()) // Tampilkan loading indicator jika sedang memuat
        : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: questions.asMap().entries.map((entry) {
                  Map<String, dynamic> question = entry.value;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiscussionQuestion(userId: widget.userId, questionId: question['questionId']),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question['question'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            // Tampilkan penulis pertanyaan
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Asked by: ${question['Author']}',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '${question['created']}',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Palette.thirdColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: questionController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Palette.grey,
                        hintText: 'Post a question...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                    ),
                  ),
                  IconButton(
                    color: Palette.fourthColor,
                    icon: Icon(Icons.send),
                    onPressed: (){
                      setState(() {
                        question = questionController.text;
                      });
                      created = DateTime.now();
                      if (created == null || question.isEmpty) {
                        errorSnackBar(context, "Write your answer");
                      } else {
                        Api.postQuestion(
                          context, widget.userId, question, created
                        ).then((_) {
                          // Update UI directly by adding the new answer to the list
                          questions.insert(0, {
                            'question': question,
                            'Author': widget.userId, // Assuming the current user is the author
                            'created': DateFormat('dd/MM/yyyy').format(created!), // Format the created date
                          });
                          questionController.clear(); // Clear the answer text field
                          setState(() {}); // Call setState after clearing the text field
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
