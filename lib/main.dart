import 'package:arithmetica/db/database_helper.dart';
import 'package:arithmetica/settings/arithmetic_settings.dart';
import 'package:flutter/material.dart';
import 'package:arithmetica/pages/arithmetic.dart';
import 'package:arithmetica/tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arithmetica',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          )
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Arithmetica'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _operatorsController = TextEditingController();
  final TextEditingController _inputTermUpperBoundController = TextEditingController();
  final TextEditingController _inputTermLowerBoundController = TextEditingController();
  final TextEditingController _outputTermUpperBoundController = TextEditingController();
  final TextEditingController _outputTermLowerBoundController = TextEditingController();

  void createNewProblemSet(ArithmeticSettings settings) async {

    debugPrint("${await DatabaseHelper.getAllProblemSets()}");

    int id = await DatabaseHelper.getMaxProblemSetId() + 1;
    ArithmeticSettings newSettings = ArithmeticSettings(id: id, 
      title: settings.title, 
      operators: settings.operators,
      inputTermLowerBound: settings.inputTermLowerBound,
      inputTermUpperBound: settings.inputTermUpperBound,
      outputTermUpperBound: settings.outputTermUpperBound, 
      outputTermLowerBound: settings.outputTermLowerBound, 
      upperBoundIncrement: settings.upperBoundIncrement, 
      lowerBoundIncrement: settings.lowerBoundIncrement,
      upperBoundScaleFactor: settings.upperBoundScaleFactor, 
      lowerBoundScaleFactor: settings.lowerBoundScaleFactor, 
      upperBoundCap: settings.upperBoundCap, 
      lowerBoundCap: settings.lowerBoundCap, 
      startingValue: settings.startingValue, 
      targetValue: settings.targetValue, 
      allowNegativeInputValues: settings.allowNegativeInputValues,
      allowNegativeOutputValues: settings.allowNegativeOutputValues,
    );

    problemSets.add(
      Tile(
        problemSetSettings: newSettings,
      )
    );

    setState((){});

    debugPrint("New problem set added to the problemsets list");

    await DatabaseHelper.insertProblemSet(newSettings);

    debugPrint("new problem set added to the db");
  }

  Dialog createNewProblemDialog() {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleController, 
              decoration: InputDecoration(hintText: "Title"),),
            TextField(controller: _operatorsController, 
              decoration: InputDecoration(hintText: "Operators num, 1=+,2=-,4=*,8=/"), 
              keyboardType: TextInputType.numberWithOptions(decimal: false),),
            TextField(controller: _inputTermUpperBoundController, 
              decoration: InputDecoration(hintText: "input term upper bound"),
              keyboardType: TextInputType.numberWithOptions(decimal: false),),
            TextField(controller: _inputTermLowerBoundController, 
            decoration: InputDecoration(hintText: "input term lower bound"),
            keyboardType: TextInputType.numberWithOptions(decimal: false),),
            TextField(controller: _outputTermUpperBoundController, 
            decoration: InputDecoration(hintText: "output term upper bound"),
            keyboardType: TextInputType.numberWithOptions(decimal: false),),
            TextField(controller: _outputTermLowerBoundController, 
            decoration: InputDecoration(hintText: "output term lower bound"),
            keyboardType: TextInputType.numberWithOptions(decimal: false),),
            ElevatedButton(
              child: Text("Create Problem Set"),
              onPressed: () {

                ArithmeticSettings settings = ArithmeticSettings(
                  id: -1,
                  title: _titleController.text.isEmpty ? "New Problem Set" : _titleController.text,
                  operators: int.tryParse(_operatorsController.text) ?? 0,
                  inputTermLowerBound: int.tryParse(_inputTermLowerBoundController.text),
                  inputTermUpperBound: int.tryParse(_inputTermUpperBoundController.text),
                  outputTermLowerBound: int.tryParse(_outputTermLowerBoundController.text),
                  outputTermUpperBound: int.tryParse(_outputTermUpperBoundController.text),
                );

                createNewProblemSet(settings);
                
                Navigator.pop(context);
              },
            )
          ]
        )
      )
    );
  }

  List<Tile> problemSets = 
  [
    Tile(
      problemSetSettings: ArithmeticSettings(
        id: -1,
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
      ),
    ),
    Tile(
      problemSetSettings: ArithmeticSettings(
        id: 1,
        title: "addition input numbers 1-100",
        operators: Operators.addition,
        inputTermLowerBound: 1,
        inputTermUpperBound: 100,
        lowerBoundIncrement: 0,
        upperBoundIncrement: 0,
      ),
    ),
    Tile(
      problemSetSettings: ArithmeticSettings(
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
      ),
    ),
    Tile(
      problemSetSettings: ArithmeticSettings(
        id: 3,
        title: "multiplication",
        operators: Operators.multiplication,
        outputTermLowerBound: 5,
        outputTermUpperBound: 20,
        lowerBoundIncrement: 0,
        upperBoundIncrement: 5,
        lowerBoundScaleFactor: 1.04,
        upperBoundScaleFactor: 1.05,
      ),
    ),
    Tile(
      problemSetSettings: ArithmeticSettings(
        id: 4,
        title: "division",
        operators: Operators.division,
        outputTermLowerBound: 1,
        outputTermUpperBound: 20,
        lowerBoundIncrement: 5,
        upperBoundIncrement: 5,
        lowerBoundScaleFactor: 1.05,
        upperBoundScaleFactor: 1.05,
      ),
    ),
    Tile(
      problemSetSettings: ArithmeticSettings(
        id: 5,
        title: "12x12 times table",
        operators: Operators.multiplication,
        inputTermLowerBound: 2,
        inputTermUpperBound: 12,
        outputTermLowerBound: 1,
        outputTermUpperBound: 200,
      ),
    ),

    Tile(
      problemSetSettings: ArithmeticSettings(
        id: 6,
        title: "15x15 times table",
        operators: Operators.multiplication,
        inputTermLowerBound: 2,
        inputTermUpperBound: 15,
        outputTermLowerBound: 1,
        outputTermUpperBound: 200,
      ),
    ),
  ];

  final BoxDecoration boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 10,
        offset: Offset(0, 4)
      )
    ]
  );

  late GestureDetector addNewProblemSet;

  @override
  void initState() {
    super.initState();
  
    addNewProblemSet = GestureDetector(
      onTap: () {
        debugPrint("$problemSets");
        showDialog(
          context: context,
          builder: (BuildContext context) => createNewProblemDialog()
        );
      },
      child: Container(
        decoration: boxDecoration,
        padding: const EdgeInsets.all(10),
        child: LayoutBuilder(builder: (context, constraint) {
          return Icon(Icons.add, size: constraint.biggest.height);
        })
      ),
    );

    loadProblemSetsFromDB();
  }

  void loadProblemSetsFromDB() async {
    problemSets += (await DatabaseHelper.getAllProblemSets()).map((e) => Tile(problemSetSettings: e)).toList();

    setState((){});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.count(
          primary: true,
          padding: EdgeInsets.all(10),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[] + problemSets + [addNewProblemSet]
        )
      ),
    );
  }
}
