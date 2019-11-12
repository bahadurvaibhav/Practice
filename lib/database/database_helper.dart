import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practice/database/question_answer.dart';
import 'package:practice/module/enum/skill_type.dart';
import 'package:sqflite/sqflite.dart';

import 'form.dart';
import 'question.dart';

// Question table
final String tableQuestion = 'question';
final String columnId = '_id';
final String columnOrder = 'questionOrder';
final String columnDescription = 'description';
final String columnQuestionType = 'question_type';
final String columnSkillType = 'skill_type';

// Form table
final String tableForm = 'form';
final String columnCreatedAt = 'created_at';

// QuestionAnswer table
final String tableQuestionAnswer = 'question_answer';
final String columnQuestionId = 'question_id';
final String columnAnswer = 'answer';
final String columnFormId = 'form_id';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableQuestion (
              $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
              $columnOrder INTEGER NOT NULL, 
              $columnDescription TEXT NOT NULL, 
              $columnQuestionType TEXT NOT NULL, 
              $columnSkillType TEXT NOT NULL)
              ''');

    await db.execute('''
              CREATE TABLE $tableForm (
              $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
              $columnSkillType TEXT NOT NULL, 
              $columnCreatedAt TEXT NOT NULL)
              ''');

    await db.execute('''
              CREATE TABLE $tableQuestionAnswer (
              $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
              $columnQuestionId INTEGER NOT NULL, 
              $columnAnswer TEXT NOT NULL, 
              $columnFormId INTEGER NOT NULL)
              ''');

    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Write a joke", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Joke")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Rate this", "QuestionType.RATING", "SkillType.Joke")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(3, "Why is this funny?", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Joke")');
  }

  // Database helper methods:

  Future<int> insertQuestion(Question question) async {
    Database db = await database;
    int id = await db.insert(tableQuestion, question.toMap());
    return id;
  }

  Future<int> insertForm(PracticeForm form) async {
    Database db = await database;
    int id = await db.insert(tableForm, form.toMap());
    return id;
  }

  Future<int> insertQuestionAnswer(QuestionAnswer questionAnswer) async {
    Database db = await database;
    int id = await db.insert(tableQuestionAnswer, questionAnswer.toMap());
    return id;
  }

  Future<Question> getQuestionById(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableQuestion,
        columns: [
          columnId,
          columnOrder,
          columnDescription,
          columnQuestionType,
          columnSkillType
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Question.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Question>> getQuestionsBySkill(SkillType skillType) async {
    String skillTypeString = skillType.toString();
    Database db = await database;
    List<Map> maps = await db.query(tableQuestion,
        columns: [
          columnId,
          columnOrder,
          columnDescription,
          columnQuestionType,
          columnSkillType
        ],
        where: '$columnSkillType = ?',
        whereArgs: [skillTypeString]);
    if (maps.length > 0) {
      List<Question> questions = new List(maps.length);
      for (int i = 0; i < maps.length; i++) {
        questions[i] = Question.fromMap(maps[i]);
      }
      return questions;
    }
    return null;
  }

  Future<List<QuestionAnswer>> getQuestionAnswersByFormId(int formId) async {
    Database db = await database;
    List<Map> maps = await db.query(tableQuestionAnswer,
        columns: [columnId, columnQuestionId, columnAnswer, columnFormId],
        where: '$columnFormId = ?',
        whereArgs: [formId]);
    if (maps.length > 0) {
      List<QuestionAnswer> questionAnswers = new List(maps.length);
      for (int i = 0; i < maps.length; i++) {
        questionAnswers[i] = QuestionAnswer.fromMap(maps[i]);
      }
      return questionAnswers;
    }
    return null;
  }
}