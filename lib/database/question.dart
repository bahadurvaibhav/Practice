import 'package:practice/module/enum/question_type.dart';
import 'package:practice/module/enum/skill_type.dart';
import 'database_helper.dart';

class Question {
  int id;
  int order;
  String description;
  QuestionType questionType;
  SkillType skillType;
  String answer;

  Question(int columnOrder, String columnDescription,
      QuestionType columnQuestionType, SkillType columnSkillType) {
    order = columnOrder;
    description = columnDescription;
    questionType = columnQuestionType;
    skillType = columnSkillType;
  }

  // convenience constructor to create a Word object
  Question.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    order = map[columnOrder];
    description = map[columnDescription];
    String questionTypeString = map[columnQuestionType];
    questionType = QuestionType.values
        .firstWhere((e) => e.toString() == questionTypeString);
    String skillTypeString = map[columnSkillType];
    skillType =
        SkillType.values.firstWhere((e) => e.toString() == skillTypeString);
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnOrder: order,
      columnDescription: description,
      columnQuestionType: questionType.toString(),
      columnSkillType: skillType.toString(),
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
