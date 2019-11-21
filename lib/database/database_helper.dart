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

    // Face Reading
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Image URL of a Face", "QuestionType.IMAGE_URL", "SkillType.Face_Reading")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Deduce personality of above person", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Face_Reading")');

    // Palmistry
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Image URL of a person\'s hand", "QuestionType.IMAGE_URL", "SkillType.Palmistry")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Deduce personality of above person", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Palmistry")');

    // Handwriting_Analysis
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Image URL of a person\'s handwriting", "QuestionType.IMAGE_URL", "SkillType.Handwriting_Analysis")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Deduce personality of above person", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Handwriting_Analysis")');

    // Story_Journal
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Write a story from last 24 hours", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Story_Journal")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Rate this", "QuestionType.RATING", "SkillType.Story_Journal")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(3, "What did you like about this?", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Story_Journal")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(4, "What can be improved?", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Story_Journal")');

    // Cold_Read_Video
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(1, "Video URL of people interacting", "QuestionType.VIDEO_URL", "SkillType.Cold_Read_Video")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(2, "Deduce the expressions. Why?", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Cold_Read_Video")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(3, "What are they talking about? Why?", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Cold_Read_Video")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(4, "Unmute video", "QuestionType.TEXT", "SkillType.Cold_Read_Video")');
    await db.rawInsert(
        'INSERT INTO $tableQuestion ($columnOrder, $columnDescription, $columnQuestionType, $columnSkillType) VALUES(5, "How is your deduction different from the actual words spoken? Why?", "QuestionType.EXPANDABLE_ANSWER_TEXT", "SkillType.Cold_Read_Video")');

    // TODO: Self-Awareness Techniques (Why?, etc.)

    // TODO: Handwriting analysis (same questions as palmistry)

    // TODO: Record an audio of you telling a 1 minute story.
    // Record same story in flat, monotone. Listen to it. Comment on the non-verbals
    // Record audio as sports commentator. Record audio as journalist
    // Record in wild voice
    // Pull out your phone and play all three of the recordings you created from the practice exercises in this chapter. Compare your “normal” recording with the subsequent recordings. What did you notice? Did the wild version sound as wild as you felt it was when you recorded it? Was the monotone version painful to listen to? Did you hear any poor habits like mumbling? Is your pitch too high? Do you lose energy at the end of your comments?
    // Let’s do one more recording. This time tell the same childhood story or choose another story. Remember, it’s important to tell a story for this exercise because during the process of recalling events, you may notice some poor conversation habits creep in. During this recording, see if you can improve upon your “normal” vocal habits and create something even more interesting. Then listen to your new recording, how did you do?

    // ** TODO: Find a YouTube clip of a popular talk show host or news reporter. Watch them four or five times. After repeatedly watching the same clip, it will become easier to listen to their vocal mannerisms because you won’t be distracted by the content of their message anymore. What did you notice?

    // TODO: Record a video of yourself telling a 1 min story. Comment on the non-verbals
    // Record a video of yourself telling a story. Any story will do. Then record the same story again but deliberately add more movement, energy, facial expressions, and gestures. Go out of your comfort zone!
    // Watch both versions and compare the new behaviors with your existing behaviors. What did you notice? Is one more entertaining than the other? Does the more demonstrative version look as silly as it felt while you were recording it?

    // TODO: TAPP Exercise. TAPP Topics. Pick a TAPP topic. Share an interesting fact about it
    // THINGS: Technology, Books, Clothes, Cars, Movies, TV Shows, Food, Drink, and Weather
    // ACTIVITIES: Hobbies, Volunteering, Sports, Fitness, Diets, Entertainment, Gaming, Education, Dating, Vacations, Shopping, and Careers
    // PEOPLE: Kids/Parenting, Family, Pets, Gossip, Relationships, Opposite Sex, You, Them, Culture, Common friends/Co-workers, Local/Global News, Appearance, and Human Behavior
    // PLACES: Surroundings, Cities, Landmarks, States, Restaurants, Festivals, Houses, and Stores

    // TODO: C6 #2 (within 3 seconds) and #3 (personal take)

    // TODO: C6 #4 Opinion inventory worksheet

    // TODO: Sprint Retrospective (every 2 weeks)

    // TODO: Power of Full Engagement Value worksheet

    // TODO: C6 #5 Tell me about a time worksheet

    // TODO: Remember the "Writing Funny .." stuff book. Get the techniques from there and put them as questions here

    // TODO: 1: Write openers (Cocky n Funny, Situational, etc.) (follow Style's guidline - time constraint, root your opener, etc.), Write negs, 2: Write Roleplay, 3: Write Push and Pull

    // TODO: 1. Exaggerate something more than you normally would. 2.Try labeling something. 3.Use a superlative. 4.Play with a cliché.
    // TODO: 1: Initiate conversation with a feeler (you, environment, them, problem, time) with a friend/stranger; 2: Write a story you would talk about with a friend. 3a. Now transition it to another story, using something for above story
    // TODO: C10 #1 (Yes, and). Choose topic. Start talking about and do "yes, and" ... continue with another topic.
    // TODO: Pick a TAPP topic, and see if you can offer a comment from each of the seven FOOFAAE categories. Try it in live conversation also!

    // *** TODO: Creating Stages for what you are learning. e.g. TMI has 10 stages. Style's PUA has 4 stages and each stage has further 4 sub-stages. Multi-orgasmic has stages. Convict Conditioning has 10 stages.
    // Define "skill" on app
    // Write down your plan for next 6 months, 1 year, 3 yrs, 5 yrs, 10 yrs.
    // Plan hobbies/skills for next month, 6 months, 1 year, and so on ...
    // Within each hobby, assign practice "techniques"
    // Assign practice "techniques" to a stage of a hobby

    // TODO: Act your emotions (fear, anger, happiness, greed, guilt, etc.). Act the out facially. Attach video.

    // *** TODO: 1: Export/Share excel in iOS. 2: In case of one of the video players, click on more sound mutes, and clicking on mute icon gives sound.
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
