import 'package:flutter/material.dart';
import 'package:practice/database/database_helper.dart';
import 'package:practice/database/question.dart';
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

  @override
  void initState() {
    super.initState();
    _getQuestions(widget.skillType);
  }

  _getQuestions(SkillType skillType) async {
    List<Question> dbQuestions = await helper.getBySkill(skillType);
    this.setState(() {
      questions = dbQuestions;
    });
    if (questions == null) {
      print('No questions found');
    } else {
      print('# of questions: ${questions.length}');
    }
  }

  _read() async {
    int rowId = 1;
    List<Question> questions = await helper.getBySkill(SkillType.Joke);
    if (questions == null) {
      print('read row $rowId: empty');
    } else {
      print('no. of questions: ${questions.length}');
      print(
          'read row $rowId: ${questions[0].order} ${questions[0].description} ${questions[0].questionType} ${questions[0].skillType}');
    }
  }

  _save() async {
//    Question question =
//        Question(1, 'Write a joke', QuestionType.ANSWER_TEXT, SkillType.Joke);
//    int id = await helper.insert(question);
//    print('inserted row: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Practice"),
      ),
      body: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Read'),
              onPressed: () {
                _read();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Save'),
              onPressed: () {
                _save();
              },
            ),
          ),
        ],
      ),
    );
  }
}
