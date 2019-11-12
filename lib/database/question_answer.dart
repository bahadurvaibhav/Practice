import 'database_helper.dart';

class QuestionAnswer {
  int id;
  int questionId;
  String answer;
  int formId;

  QuestionAnswer(int columnQuestionId, String columnAnswer, int columnFormId) {
    questionId = columnQuestionId;
    answer = columnAnswer;
    formId = columnFormId;
  }

  // convenience constructor to create a Word object
  QuestionAnswer.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    questionId = map[columnQuestionId];
    answer = map[columnAnswer];
    formId = map[columnFormId];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
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
