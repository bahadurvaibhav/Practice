import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:practice/database/database_helper.dart';
import 'package:practice/database/form.dart';
import 'package:practice/database/question.dart';
import 'package:practice/database/question_answer.dart';
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
  var questionAnswers = new Map();

  submit() {
    String createdAt = DateFormat.yMMMMd("en_US").format(new DateTime.now());
    PracticeForm newForm = new PracticeForm(widget.skillType, createdAt);
    var formId;
    helper.insertForm(newForm).then((value) {
      formId = value;
      questionAnswers.forEach((key, value) {
        QuestionAnswer questionAnswer =
            new QuestionAnswer(key, value.toString(), formId);
        helper.insertQuestionAnswer(questionAnswer);
      });
    });
    Navigator.pop(context);
  }

  /* get question answers for Form id
  helper.getQuestionAnswersByFormId(formId).then((value) {
          var index = value.length - 1;
          print(
              'Question Answer with Form id: ${value[index].formId} and Question id: ${value[index].questionId} with text: ${value[index].answer}');
        });*/

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
    questions.forEach((question) {
      items.add(showQuestion(question));
    });
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
    switch (question.questionType) {
      case QuestionType.ANSWER_TEXT:
        return answerText(question);
        break;
      case QuestionType.RATING:
        return rating(question);
        break;
      case QuestionType.EXPANDABLE_ANSWER_TEXT:
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
    return getOuterStyle(question, TextField(
      onChanged: (text) {
        questionAnswers[question.id] = text;
      },
    ));
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
            questionAnswers[question.id] = rating;
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
          onChanged: (text) {
            questionAnswers[question.id] = text;
          },
        ));
  }

  text(question) {
    return getOuterStyle(question, new Container());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Practice"),
      ),
      body: FutureBuilder<List<Question>>(
        future: helper.getQuestionsBySkill(widget.skillType),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return showQuestionsAndSubmit(snapshot.data);
        },
      ),
    );
  }
}
