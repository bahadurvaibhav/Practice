import 'package:practice/domain/enum/skill_type.dart';

import 'database_helper.dart';

class FormQuestionAnswer {
  int id;
  int questionId;
  String answer;
  int formId;
  SkillType skillType;

  FormQuestionAnswer(SkillType columnSkillType, int columnQuestionId,
      String columnAnswer, int columnFormId) {
    skillType = columnSkillType;
    questionId = columnQuestionId;
    answer = columnAnswer;
    formId = columnFormId;
  }

  // convenience constructor to create a Word object
  FormQuestionAnswer.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    questionId = map[columnQuestionId];
    answer = map[columnAnswer];
    formId = map[columnFormId];
    String skillTypeString = map[columnSkillType];
    skillType =
        SkillType.values.firstWhere((e) => e.toString() == skillTypeString);
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnSkillType: skillType.toString(),
      columnQuestionId: questionId,
      columnAnswer: answer,
      columnFormId: formId,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
