import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practice/database/question_answer.dart';
import 'package:practice/domain/enum/skill_type.dart';
import 'package:sqflite/sqflite.dart';

import 'form.dart';
import 'form_question_answer.dart';
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

    // Joke
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Write a joke", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Joke")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Rate this", "QuestionType.RATING", "SkillType.Joke")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(3, "Why is this funny?", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Joke")');

    // Gratitude
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Write something new you are grateful for in the last 24 hours", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Gratitude")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Why is it important?", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Gratitude")');

    // Story_Object
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Pick any random object, thing, person from the surrounding", "QuestionType.ANSWER_TEXT", "SkillType.Story_Object")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Write a story based on above selection", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Story_Object")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(3, "Rate this", "QuestionType.RATING", "SkillType.Story_Object")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(4, "Critique / Feedback / Improvements", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Story_Object")');

    // Story_DHV
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "DHV Spikes: \n 1. Being a leader of men \n 2. Being the protector of loved ones \n 3. Being pre-selected by other women \n 4. Having a willingness to emote \n 5. Being a successful risk taker \n 6. Willingness to walk away", "QuestionType.TEXT", "SkillType.Story_DHV")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Write a story demonstrating high value", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Story_DHV")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(3, "Rate this", "QuestionType.RATING", "SkillType.Story_DHV")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(4, "Critique / Feedback / Improvements", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Story_DHV")');

    // Blessings
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Bless a person or thing from the last 24 hours", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Blessings")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Why is it important?", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Blessings")');

    // Forgive
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Bring up a memory, thought that is arising often, and make a conscious acknowledgement and then let it go. It doesn\'t only have to be to a person, can be to a situation as well \n \nBring up any situation, thought, memory you are holding onto. Let it go. Forgive it", "QuestionType.TEXT", "SkillType.Forgive")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Forgive", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Forgive")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(3, "Why is it important?", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Forgive")');

    // CBT
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Feelings --> Thoughts --> Action --> Feeling --> ... \n\nCBT enters at Thoughts phase to change the cycle of negative emotions / memories / triggers", "QuestionType.TEXT", "SkillType.CBT")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "What is on your mind? (What is bothering you?)", "QuestionType.ANSWER_TEXT", "SkillType.CBT")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(3, "What belief/thoughts/action is causing this?", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.CBT")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(4, "Feeling?", "QuestionType.ANSWER_TEXT", "SkillType.CBT")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(5, "Positive intent of this belief?", "QuestionType.ANSWER_TEXT", "SkillType.CBT")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(6, "Reframe belief", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.CBT")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(7, "New Feeling?", "QuestionType.ANSWER_TEXT", "SkillType.CBT")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(8, "If new feeling is negative or neutral then reframe again. Use the reframe belief area.", "QuestionType.TEXT", "SkillType.CBT")');

    // What Went Well
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Write something new that went well in the last 24 hours", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.What_Went_Well")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Why is it important?", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.What_Went_Well")');

    // Learning - Cornell Note Taking System
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Topic", "QuestionType.ANSWER_TEXT", "SkillType.Learning_Cornell_Note_Taking_System")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Notes", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Learning_Cornell_Note_Taking_System")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(3, "Keywords / Questions", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Learning_Cornell_Note_Taking_System")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(4, "Summary", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Learning_Cornell_Note_Taking_System")');

    // Record Joke
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Record a joke or funny thing that you read / heard in the last 24 hours", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Record_Joke")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Rate this", "QuestionType.RATING", "SkillType.Record_Joke")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(3, "Why is this funny?", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Record_Joke")');

    // TODO: Self-Awareness Techniques (Why?, etc.), Face Reading, Palm Reading
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

  Future<PracticeForm> getFormById(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableForm,
        columns: [columnId, columnSkillType, columnCreatedAt],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return PracticeForm.fromMap(maps.first);
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

  Future<List<PracticeForm>> getForms() async {
    Database db = await database;
    List<Map> maps = await db.query(tableForm,
        columns: [columnId, columnSkillType, columnCreatedAt],
        where: null,
        whereArgs: null);
    if (maps.length > 0) {
      List<PracticeForm> forms = new List(maps.length);
      for (int i = 0; i < maps.length; i++) {
        forms[i] = PracticeForm.fromMap(maps[i]);
      }
      return forms;
    }
    return null;
  }

  Future<List<FormQuestionAnswer>> getFormQuestionAnswers() async {
    Database db = await database;
    var sql =
        'SELECT $columnFormId, $columnSkillType, $columnQuestionId, $columnAnswer FROM $tableForm INNER JOIN $tableQuestionAnswer ON $tableForm.$columnId = $tableQuestionAnswer.$columnFormId';
    List<Map> maps = await db.rawQuery(sql);
    if (maps.length > 0) {
      List<FormQuestionAnswer> questionAnswers = new List(maps.length);
      for (int i = 0; i < maps.length; i++) {
        questionAnswers[i] = FormQuestionAnswer.fromMap(maps[i]);
      }
      return questionAnswers;
    }
    return null;
  }

  emptyFormsQuestionAnswers() async {
    Database db = await database;
    var sql = 'DELETE FROM $tableForm';
    db.rawDelete(sql);
    var sql2 = 'DELETE FROM $tableQuestionAnswer';
    db.rawDelete(sql2);
  }
}
