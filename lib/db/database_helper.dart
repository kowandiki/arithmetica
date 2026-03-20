

import 'package:arithmetica/settings/arithmetic_settings.dart';
import 'package:arithmetica/settings/problem_set_settings.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  static final String problemSetsTable = "problem_sets";
  static final String flagTable = "flags";
  static final String databaseName = "arithmetica.db";
  static String? databasePath;
  static Database? db;

  static Future<void> init() async {
    DatabaseHelper.databasePath = await getDatabasesPath();
    DatabaseHelper.db = await openDatabase("$databasePath/$databaseName");

    await createTables();

    if (await DatabaseHelper.getMaxProblemSetId() == 0) {
      await DatabaseHelper.insertInitialProblemSets();
    }
  }

  static Future<void> createTables() async {

    if (db == null) {
      await DatabaseHelper.init();
    }

    await db!.execute('''
      CREATE TABLE IF NOT EXISTS $problemSetsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,

        title TEXT NOT NULL,

        operators INTEGER,

        outputTermLowerBound INTEGER,
        outputTermUpperBound INTEGER,

        lowerBoundIncrement INTEGER,
        upperBoundIncrement INTEGER,

        lowerBoundScaleFactor REAL,
        upperBoundScaleFactor REAL,

        upperBoundCap INTEGER,
        lowerBoundCap INTEGER,

        inputTermUpperBound INTEGER,
        inputTermLowerBound INTEGER,

        startingValue INTEGER,
        targetValue INTEGER,

        allowNegativeInputValues INTEGER NOT NULL,
        allowNegativeOutputValues INTEGER NOT NULL
      )
    ''');
  }

  static Future<void> clearTables() async {

    if (db == null) {
      await DatabaseHelper.init();
    }

    await db!.execute('DROP TABLE IF EXISTS $problemSetsTable');
    await createTables();
  }

  static Future<void> insertInitialProblemSets() async {
    if (db == null) {
      await DatabaseHelper.init();
    }
    insertProblemSet(ArithmeticSettings(
      id: 0,
      title: "addition",
      operators: Operators.addition,
      outputTermLowerBound: 1,
      outputTermUpperBound: 20,
      inputTermLowerBound: 1,
      inputTermUpperBound: 20,
      lowerBoundIncrement: 5,
      upperBoundIncrement: 5,
      lowerBoundScaleFactor: 1.05,
      upperBoundScaleFactor: 1.05
    ));

    insertProblemSet(ArithmeticSettings(
      id: 1,
      title: "addition input numbers 1-100",
      operators: Operators.addition,
      inputTermLowerBound: 1,
      inputTermUpperBound: 100,
      lowerBoundIncrement: 0,
      upperBoundIncrement: 0,
    ));

    insertProblemSet(ArithmeticSettings(
      id: 2,
      title: "subtraction",
      operators: Operators.subtraction,
      outputTermLowerBound: 1,
      outputTermUpperBound: 20,
      inputTermLowerBound: 1,
      inputTermUpperBound: 20,
      lowerBoundIncrement: 5,
      upperBoundIncrement: 5,
      lowerBoundScaleFactor: 1.05,
      upperBoundScaleFactor: 1.05
    ));

    insertProblemSet(ArithmeticSettings(
      id: 3,
      title: "multiplication",
      operators: Operators.multiplication,
      outputTermLowerBound: 5,
      outputTermUpperBound: 20,
      lowerBoundIncrement: 0,
      upperBoundIncrement: 5,
      lowerBoundScaleFactor: 1.04,
      upperBoundScaleFactor: 1.05,
    ));

    insertProblemSet(ArithmeticSettings(
      id: 4,
      title: "division",
      operators: Operators.division,
      outputTermLowerBound: 1,
      outputTermUpperBound: 20,
      lowerBoundIncrement: 5,
      upperBoundIncrement: 5,
      lowerBoundScaleFactor: 1.05,
      upperBoundScaleFactor: 1.05,
    ));

    insertProblemSet(ArithmeticSettings(
      id: 5,
      title: "12x12 times table",
      operators: Operators.multiplication,
      inputTermLowerBound: 2,
      inputTermUpperBound: 12,
      outputTermLowerBound: 1,
      outputTermUpperBound: 200,
    ));

    insertProblemSet(ArithmeticSettings(
      id: 6,
      title: "15x15 times table",
      operators: Operators.multiplication,
      inputTermLowerBound: 2,
      inputTermUpperBound: 15,
      outputTermLowerBound: 1,
      outputTermUpperBound: 200,
    ));

  }

  static Future<void> insertProblemSet(ProblemSetSettings settings) async {

    if (db == null) {
      await DatabaseHelper.init();
    }

    db!.insert(
      problemSetsTable,
      settings.toMap()
    );
  }

  static Future<List<ProblemSetSettings>> getAllProblemSets() async {

    if (db == null) {
      await DatabaseHelper.init();
    }

    final results = await db!.query(problemSetsTable);

    return results.map((e) => ArithmeticSettings.fromMap(e)).toList();
  }

  static Future<void> updateProblemSet(ProblemSetSettings settings) async {

    if (db == null) {
      await DatabaseHelper.init();
    }

  }

  static Future<int> getMaxProblemSetId() async {

    if (db == null) {
      await DatabaseHelper.init();
    }
    final result = await db!.rawQuery('SELECT MAX(id) as max_id FROM $problemSetsTable');

    if (result.isEmpty) {
      return 0;
    }

    // db is empty
    if (result.first['max_id'] == null) {
      return 0;
    }

    return result.first['max_id'] as int;
  }

  static Future<void> removeProblemSet(int id) async {
    if (db == null) {
      await DatabaseHelper.init();
    }

    if (id < 0) {
      return;
    }

    await db!.delete(
      problemSetsTable,
      where: 'id = ?',
      whereArgs: [id]
    );
  }
}

