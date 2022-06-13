/// Author: Angel Badillo Hernandez / @It-IsLegend27
///
/// Assignment 4: Quizzler w/ FastApi
///
/// Class: CMPS-4443-101: MOB
///
/// Description: This is a simple quiz app. The quiz is true/false style.
/// The "QuizBrain" relies on a python FASTAPI. An instance of the QuizBrain
/// is controls progression of the quiz, and retrieves data for via get requests
/// to the API and decoding the response.
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quiz_brain.dart';

QuizBrain quizBrain = QuizBrain();
void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          title: const Center(
              child: Text(
            '¿Quizzler?',
            style: TextStyle(
              fontFamily: 'Bangers',
              fontSize: 50.0,
            ),
          )),
        ),
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [
    const Icon(Icons.arrow_forward_ios, color: Colors.white)
  ]; // Keeps track of the user's answers

  String currentQuestion = '';

  /// Get a question and assign it to currentQuestion
  void setQuestionText() async {
    String temp = await quizBrain.getQuestionText();
    setState(() {
      currentQuestion = temp;
    });
  }

  /// Check the user's answer, then check if the quiz if over.
  /// If it is over, add the appropriate icon to the scoreKeeper, then
  /// display the Alert. Once closed, reset the scoreKeeper.
  /// If the quiz is not over, add the appropriate icon to the scoreKeeper,
  /// then move to the next question.
  void checkAnswer(bool userPickedAnswer) async {
    bool correctAnswer = await quizBrain.getCorrectAnswer();
    bool isFinished = await quizBrain.isFinished();
    setState(() {
      // Check if there are no more questions, add icon to scoreKeeper.
      // Then display the Alert. Once Alert is closed, reset scoreKeeper.
      if (isFinished) {
        // If the user picked the right answer, add check
        if (userPickedAnswer == correctAnswer) {
          scoreKeeper.add(const Icon(
            Icons.check,
            color: Colors.green,
          ));
        }
        // Otherwise, add close
        else {
          scoreKeeper.add(const Icon(
            Icons.close,
            color: Colors.red,
          ));
        }
        Alert(
          style: const AlertStyle(
            isCloseButton: false,
            isOverlayTapDismiss: false,
          ),
          context: context,
          image: Image.asset('images/party.gif'),
          title: "Finished!",
          desc: "Press OK to restart the quiz!",
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
                quizBrain.reset();
                scoreKeeper = [
                  // Marks the starting point
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  )
                ];
              },
              width: 120,
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show();
      } else {
        // If the user picked the right answer, add check
        if (userPickedAnswer == correctAnswer) {
          scoreKeeper.add(const Icon(
            Icons.check,
            color: Colors.green,
          ));
        }
        // Otherwise, add close (x)
        else {
          scoreKeeper.add(const Icon(
            Icons.close,
            color: Colors.red,
          ));
        }
        // Increment counter
        quizBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setQuestionText(); // Set question text before we use it
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                currentQuestion,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: const Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              child: const Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        const Divider(color: Colors.white, thickness: 1),
        Container(
          color: Colors.grey[900],
          child: Row(
            children: scoreKeeper,
          ),
        ),
      ],
    );
  }
}
