import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practice/database/database_helper.dart';
import 'package:practice/domain/enum/skill_type.dart';
//import 'package:simple_permissions/simple_permissions.dart';

getCsv(DatabaseHelper helper) async {
  helper.getFormQuestionAnswers().then((formQuestionAnswers) {
    if (formQuestionAnswers == null) {
      print('No practice sessions recorded');
      // TODO: Show alert
      return;
    }
    var skillTypeQuestionAnswersMap = new Map();
    formQuestionAnswers.forEach((formQuestionAnswer) {
      if (skillTypeQuestionAnswersMap[formQuestionAnswer.skillType] == null) {
        skillTypeQuestionAnswersMap[formQuestionAnswer.skillType] = new List();
      }
      skillTypeQuestionAnswersMap[formQuestionAnswer.skillType]
          .add(formQuestionAnswer);
    });

    List<List<dynamic>> rows = List<List<dynamic>>();
    SkillType.values.forEach((skillType) {
      helper.getQuestionsBySkill(skillType).then((questions) {
        print('SkillType: $skillType');

        List<dynamic> headingRow = List();
        headingRow.add(getSkillTypeDisplayValue(skillType));
        rows.add(headingRow);

        List<dynamic> questionsDescriptionRow = List();
        questions.forEach((question) {
          questionsDescriptionRow.add(question.description);
        });
        rows.add(questionsDescriptionRow);

        var formQuestionAnswers = skillTypeQuestionAnswersMap[skillType];
        if (formQuestionAnswers == null) {
          return;
        }

        var formIdQuestionAnswersMap = new Map();
        formQuestionAnswers.forEach((formQuestionAnswer) {
          if (formIdQuestionAnswersMap[formQuestionAnswer.formId] == null) {
            formIdQuestionAnswersMap[formQuestionAnswer.formId] = new List();
          }
          formIdQuestionAnswersMap[formQuestionAnswer.formId]
              .add(formQuestionAnswer);
        });
        formIdQuestionAnswersMap.forEach((formId, formQuestionAnswers) {
          List<dynamic> answerRow = new List();
          formQuestionAnswers.forEach((formQuestionAnswer) {
            answerRow.add(formQuestionAnswer.answer);
          });
          rows.add(answerRow);
        });

        List<dynamic> emptyRow = List();
        emptyRow.add("");
        rows.add(emptyRow);
      });
    });
    downloadCsv(rows);
  });
}

downloadCsv(List<List<dynamic>> rows) async {
  print('Received permission');
//  await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
//  bool checkPermission =
//      await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
//  if (checkPermission) {
  String dir =
      (await getExternalStorageDirectory()).absolute.path + "/documents";
  var file = "$dir";
  print("FILE: $file");
  File f = new File(file + "filename.csv");
  String csv = const ListToCsvConverter().convert(rows);
  f.writeAsString(csv);
//  }
}
