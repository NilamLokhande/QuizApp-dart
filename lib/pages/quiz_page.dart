import 'package:flutter/material.dart';
import 'package:quiz/Utils/Questions.dart';
import 'package:quiz/Utils/quiz.dart';
import '../Utils/Questions.dart';
import '../Utils/quiz.dart';
import '../UI/answer_button.dart';
import '../UI/question_rext.dart';
import '../UI/correct_wrong.dart';
import './score_page.dart';

class QuizPage extends StatefulWidget {
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question("Light travels in a straight line", true),
    new Question("Pizza is healthy", false),
    new Question("The Great Wall of China is visible from space.", false),
    new Question("Mount Everest is the highest mountain in the world", true),
    new Question(
        "Coffee became a popular drink in North America when the Boston Tea Party made tea hard to come by",
        true)
  ]);

  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlaySholudBeVisible = false;

  @override
  void initState() {
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  void handleAnswer(bool answer) {
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    this.setState(() {
      overlaySholudBeVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column(
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true)),
            new QuestionText(questionText, questionNumber),
            new AnswerButton(false, () => handleAnswer(false)),
          ],
        ),
        overlaySholudBeVisible == true
            ? new CorrectWrong(isCorrect, () {
                if (quiz.length == questionNumber) {
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new ScorePage(quiz.score, quiz.length)),
                      (Route route) => route == null);
                  return;
                }
                currentQuestion = quiz.nextQuestion;
                this.setState(() {
                  overlaySholudBeVisible = false;
                  questionText = currentQuestion.question;
                  questionNumber = quiz.questionNumber;
                });
              })
            : new Container()
      ],
    );
  }
}
