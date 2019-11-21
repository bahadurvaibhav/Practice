import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:practice/database/database_helper.dart';
import 'package:practice/domain/enum/question_type.dart';
import 'package:practice/domain/enum/skill_type.dart';
import 'package:practice/util/utility.dart';

Future<dynamic> shareCsv(DatabaseHelper helper, BuildContext context,
    scaffoldKey, callbackRefreshList) async {
  List<List<dynamic>> rows = await getRows(helper, scaffoldKey);
  if (rows.length != 0) {
    await shareCsv2(rows);
    showDeleteAlert(context, callbackRefreshList);
  }
}

Future<dynamic> downloadCsv(DatabaseHelper helper, BuildContext context,
    scaffoldKey, callbackRefreshList) async {
  List<List<dynamic>> rows = await getRows(helper, scaffoldKey);
  if (rows.length != 0) {
    await checkPermissionAndDownloadCsv(rows, context, scaffoldKey);
    showDeleteAlert(context, callbackRefreshList);
  }
}

showDeleteAlert(BuildContext context, callbackRefreshList) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return new DeleteDataAlert(callbackRefreshList);
    },
  );
}

getRows(DatabaseHelper helper, scaffoldKey) async {
  var formQuestionAnswers = await helper.getFormQuestionAnswers();
  if (formQuestionAnswers == null) {
    print('No practice sessions recorded');
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Add a record first'),
    ));
    return List<List<dynamic>>();
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
  for (final skillType in SkillType.values) {
    List<List<dynamic>> skillRows =
        await getRowsForSkill(helper, skillType, skillTypeQuestionAnswersMap);
    rows.addAll(skillRows);
  }
  return rows;
}

getRowsForSkill(
    DatabaseHelper helper, skillType, skillTypeQuestionAnswersMap) async {
  List<List<dynamic>> rows = List<List<dynamic>>();
  var questions = await helper.getQuestionsBySkill(skillType);
  var formQuestionAnswers = skillTypeQuestionAnswersMap[skillType];
  if (formQuestionAnswers == null) {
    return List<List<dynamic>>();
  }

  List<dynamic> headingRow = List();
  headingRow.add(getSkillTypeDisplayValue(skillType));
  rows.add(headingRow);

  List<dynamic> questionsDescriptionRow = List();
  questions.forEach((question) {
    if (question.questionType != QuestionType.TEXT) {
      questionsDescriptionRow.add(question.description);
    }
  });
  rows.add(questionsDescriptionRow);

  var formIdQuestionAnswersMap = new Map();
  formQuestionAnswers.forEach((formQuestionAnswer) {
    if (formIdQuestionAnswersMap[formQuestionAnswer.formId] == null) {
      formIdQuestionAnswersMap[formQuestionAnswer.formId] = new List();
    }
    formIdQuestionAnswersMap[formQuestionAnswer.formId].add(formQuestionAnswer);
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

  return rows;
}

class DeleteDataAlert extends StatelessWidget {
  final DatabaseHelper helper = DatabaseHelper.instance;
  Function callbackRefreshList;

  DeleteDataAlert(this.callbackRefreshList);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Would you like to delete all saved data?"),
      actions: <Widget>[
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Yes"),
          onPressed: () {
            helper.emptyFormsQuestionAnswers();
            this.callbackRefreshList();
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

shareCsv2(List<List<dynamic>> rows) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  String date = getDateTimeNow2();
  String title = "practice_backup";
  String fileName = "${title}_$date.csv";
  String path = "$dir/$fileName";
  File file = new File(path);
  String csv = getCsvString(rows);
  await file.writeAsString(csv);
  Uint8List bytes = await file.readAsBytes();
  await Share.file(title, fileName, bytes, 'text/csv');
}

checkPermissionAndDownloadCsv(
    List<List<dynamic>> rows, BuildContext context, scaffoldKey) async {
  await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  PermissionStatus permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  bool checkPermission = permission == PermissionStatus.granted;
  if (checkPermission) {
    String dir = (await getExternalStorageDirectory()).path;
    var date = getDateTimeNow2();
    var filePath = "$dir/practice_backup_$date.csv";
    File f = new File(filePath);
    String csv = getCsvString(rows);
    f.writeAsString(csv);
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Backup saved in internal storage'),
    ));
  }
}

String getCsvString(List<List<dynamic>> rows) {
  return const ListToCsvConverter().convert(rows);
}
