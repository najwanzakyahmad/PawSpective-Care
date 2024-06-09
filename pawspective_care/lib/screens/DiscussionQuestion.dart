  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart'; // Import pustaka intl
  import 'package:pawspective_care/pallete.dart';
  import 'package:pawspective_care/network/api.dart';
  import 'package:pawspective_care/screens/DiscussionPage.dart';
  import 'package:pawspective_care/screens/Information.dart';

  import '../Services/globals.dart';

  class DiscussionQuestion extends StatefulWidget {
    final String userId;
    final String questionId;
    const DiscussionQuestion({Key? key, required this.userId, required this.questionId}) : super(key: key);

    @override
    _DiscussionQuestionState createState() => _DiscussionQuestionState();
  }

  class _DiscussionQuestionState extends State<DiscussionQuestion> {
    Map<String, dynamic>? questionData;
    final List<Map<String, dynamic>> answers = [];
    final TextEditingController answerController = TextEditingController();
    String author = '';
    String question = '';
    String answer = '';
    DateTime? created;
    String questionId = '';
    bool _isLoadingQuestion = false;
    bool _isLoadingAnswers = false;

    @override
    void initState() {
      super.initState();
      fetchQuestionAndAnswers();
    }

    Future<void> fetchQuestionAndAnswers() async {
      setState(() {
        _isLoadingQuestion = true; // Start loading question
        _isLoadingAnswers = true; // Start loading answers
      });
      try {
        // Fetch question details
        await Api.getQuestionById(widget.questionId, (questionData) async {
          if (questionData != null && questionData['userId'] != null) {
            String userId = questionData['userId'];
            
            // Fetch the author's name
            String userName = await Api.getUserById(userId);

            setState(() {
              question = questionData['question'];
              questionId = questionData['questionId'];
              author = userName;
              created = DateTime.parse(questionData['created']); // Assuming created is a String
              _isLoadingQuestion = false; // Stop loading question
            });

            // Fetch answers for the question
            await Api.getAnswerByQuestion(widget.questionId, (answerData) async {
              List<Map<String, dynamic>> answerList = answerData.entries
                  .map((entry) => Map<String, dynamic>.from(entry.value))
                  .toList();
              
              List<Map<String, dynamic>> fetchedAnswers = [];

              for (var answer in answerList) {
                try {
                  String? userId = answer['userId'];
                  if (userId != null) {
                    var userName = await Api.getUserById(userId);
                    
                    fetchedAnswers.add({
                      'answer': answer['answer'],
                      'Author': userName,
                      'created': DateFormat('dd/MM/yyyy').format(DateTime.parse(answer['created'])), // Change date format
                      'questionId': answer['questionId']
                    });

                    print('Successfully fetched answer: $answer');
                  } else {
                    print('User ID is null for answer: $answer');
                  }
                } catch (error) {
                  print('Error fetching user data: $error');
                }
              }

              setState(() {
                answers.addAll(fetchedAnswers);
                _isLoadingAnswers = false; // Stop loading answers
              });
            });
          }
        });
      } catch (error) {
        print('Error fetching data: $error');
        setState(() {
          _isLoadingQuestion = false; // Stop loading question in case of error
          _isLoadingAnswers = false; // Stop loading answers in case of error
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
        body: Column(
          children: [
            if (_isLoadingQuestion) 
              Center(child: CircularProgressIndicator()), // Show loading indicator while fetching question
            if (question.isNotEmpty) ...[
              Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Asked by: $author',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${DateFormat('dd/MM/yyyy').format(created!)}', // Format the created date
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
            ],
            Expanded(
              child: _isLoadingAnswers 
                ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching answers
                : ListView.builder(
                    itemCount: answers.length,
                    itemBuilder: (context, index) {
                      var answer = answers[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                answer['answer'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Answered by: ${answer['Author']}',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${answer['created']}', // Format the created date
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
                        controller: answerController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Palette.grey,
                          hintText: 'Post an answer...',
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
                          answer = answerController.text;
                        });
                        created = DateTime.now();
                        if (created == null || answer.isEmpty) {
                          errorSnackBar(context, "Write your answer");
                        } else {
                          Api.postAnswer(
                            context, widget.userId, answer, created, questionId
                          ).then((_) {
                            // Update UI directly by adding the new answer to the list
                            answers.insert(0, {
                              'answer': answer,
                              'Author': author, // Assuming the current user is the author
                              'created': DateFormat('dd/MM/yyyy').format(created!), // Format the created date
                              'questionId': questionId
                            });
                            answerController.clear(); // Clear the answer text field
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
