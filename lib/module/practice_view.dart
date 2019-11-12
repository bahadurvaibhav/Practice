import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:practice/database/database_helper.dart';
import 'package:practice/database/question.dart';
import 'package:practice/module/enum/question_type.dart';
import 'package:practice/module/enum/skill_type.dart';

class PracticePage extends StatefulWidget {
  final SkillType skillType;

  PracticePage({Key key, @required this.skillType}) : super(key: key);

  @override
  _PracticePageState createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  DatabaseHelper helper = DatabaseHelper.instance;
  List<Question> questions = [];

  _save() async {
//    Question question =
//        Question(1, 'Write a joke', QuestionType.ANSWER_TEXT, SkillType.Joke);
//    int id = await helper.insert(question);
//    print('inserted row: $id');
  }

  submit() {}

  showQuestionsAndSubmit(List<Question> questions) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            shrinkWrap: true,
            children: showQuestionnaire(questions),
          ),
        ),
        showSubmit(),
      ],
    );
  }

  showQuestionnaire(List<Question> questions) {
    List<Widget> items = new List<Widget>();
    print('# of questions: ${questions.length}');
    questions.forEach((question) {
      print('Question id: ${question.id}');
      items.add(showQuestion(question));
    });
    print('# of widget questions: ${items.length}');
    return items;
  }

  showSubmit() {
    return FlatButton(
      color: Colors.blue,
      textColor: Colors.white,
      splashColor: Colors.blueAccent,
      onPressed: () => submit(),
      child: Text('Submit'),
    );
  }

  showQuestion(Question question) {
    print('Adding question');
    switch (question.questionType) {
      case QuestionType.ANSWER_TEXT:
        return answerText(question);
        break;
      case QuestionType.RATING:
        return rating(question);
        break;
      case QuestionType.EXPANDABLE_ANSWER_TEXT:
        print('Adding expandable answer text');
        return expandableAnswerText(question);
        break;
      case QuestionType.TEXT:
        return text(question);
        break;
    }
  }

  getOuterStyle(question, answerField) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(question.description),
          answerField,
        ],
      ),
    );
  }

  answerText(question) {
    return getOuterStyle(question, TextField());
  }

  rating(question) {
    return getOuterStyle(
        question,
        RatingBar(
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            // print(rating);
          },
        ));
  }

  expandableAnswerText(question) {
    return getOuterStyle(
        question,
        TextField(
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: null,
        ));
  }

  text(question) {
    return getOuterStyle(question, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Practice"),
      ),
      body: FutureBuilder<List<Question>>(
        future: helper.getBySkill(widget.skillType),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return showQuestionsAndSubmit(snapshot.data);
        },
      ),
    );
  }
}
