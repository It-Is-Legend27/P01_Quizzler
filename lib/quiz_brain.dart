/// Author: Angel Badillo Hernandez
///
/// Github: @It-Is-Legend27
///
/// Description:
///
/// This package allows the user to make get requests from the
/// localhost:8888 API (api.py).
///
/// Functions:
///
/// [nextQuestion]
///
/// [getQuestionText]
///
/// [getCorrectAnswer]
///
/// [isFinished]
///
/// [reset]
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String _host = '192.168.1.76:8080';

class QuizBrain {
  QuizBrain() {
    reset(); // Reset api each time
  }

  /// Increments id in the API.
  ///
  /// Makes a get request to localhost:8888/next to increment id.
  Future<void> nextQuestion() async {
    Uri url = Uri.http(_host, '/next');

    // Await the http get response
    await http.get(url);
  }

  /// Get a question from the API.
  ///
  /// Makes a get request to localhost:8888/question, decodes json-formatted
  /// response, the returns the question as a string.
  Future<String> getQuestionText() async {
    Uri url = Uri.http(_host, '/question');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      String question = jsonResponse['question'];
      return question;
    }
    return '';
  }

  /// Get the answer corresponding to the question from the API.
  ///
  /// Makes a get request to localhost:8888/answer, decodes json-formatted
  /// response, the returns the correct answer.
  Future<bool> getCorrectAnswer() async {
    Uri url = Uri.http(_host, '/answer');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      bool answer = jsonResponse['answer'];
      return answer;
    }
    return false;
  }

  /// Check if id is over the amount of questions.
  ///
  /// Makes a get request to localhost:8888/finished, decodes json-formatted
  /// response, the returns true if id == the number of questions, false
  /// otherwise.
  Future<bool> isFinished() async {
    Uri url = Uri.http(_host, '/finished');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      bool isFinished = jsonResponse['isFinished'];
      return isFinished;
    }
    // This should never happen, but if we get an error, return true to prevent
    // infinite loop
    return true;
  }

  /// Reset id to 0.
  ///
  /// Makes a get request to localhost:8888/reset to reset the id to 0.
  Future<void> reset() async {
    Uri url = Uri.http(_host, '/reset');
    await http.get(url);
  }
}
