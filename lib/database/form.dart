import 'package:practice/domain/enum/skill_type.dart';

import 'database_helper.dart';

class PracticeForm {
  int id;
  SkillType skillType;
  String createdAt;

  PracticeForm(SkillType columnSkillType, String columnCreatedAt) {
    skillType = columnSkillType;
    createdAt = columnCreatedAt;
  }

  // convenience constructor to create a Word object
  PracticeForm.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    String skillTypeString = map[columnSkillType];
    skillType =
        SkillType.values.firstWhere((e) => e.toString() == skillTypeString);
    createdAt = map[columnCreatedAt];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnSkillType: skillType.toString(),
      columnCreatedAt: createdAt,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
