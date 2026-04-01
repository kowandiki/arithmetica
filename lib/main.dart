import 'package:arithmetica/db/database_helper.dart';
import 'package:arithmetica/settings/arithmetic_settings.dart';
import 'package:arithmetica/widgets/modify_problem_set_dialog.dart';
import 'package:flutter/material.dart';
import 'package:arithmetica/widgets/tile.dart';

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
        deleteTile: deleteTile,
        replaceTile: replaceTile,
      )
    );

    setState((){});

    debugPrint("New problem set added to the problemsets list");

    await DatabaseHelper.insertProblemSet(newSettings);

    debugPrint("new problem set added to the db");
  }

  void deleteTile(int? id) {
    // find tile with matching id and remove it from the list
    // remove problem set from db
    if (id == null) {
      return;
    }

    for (int i = 0; i < problemSets.length; i++) {
      if (problemSets[i].problemSetSettings.id != null && problemSets[i].problemSetSettings.id! == id) {
        problemSets.removeAt(i);
        break;
      }
    }
    DatabaseHelper.removeProblemSet(id);

    setState((){});
  }

  List<Tile> problemSets = [];
  

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
      onTap: () async {
        debugPrint("$problemSets");
        final result = await showDialog(
          context: context,
          builder: (BuildContext context) => ModifyProblemSetDialog()
        );

        if (result != null) {
          createNewProblemSet(result!);
        }
      },
      child: Container(
        decoration: boxDecoration,
        padding: const EdgeInsets.all(10),
        child: LayoutBuilder(builder: (context, constraint) {
          return Icon(Icons.add, size: constraint.biggest.height);
        })
      ),
    );

    problemSets = [
      // 
    ];

    loadProblemSetsFromDB();

    
  }

  void loadProblemSetsFromDB() async {
    problemSets += (await DatabaseHelper.getAllProblemSets()).map((e) => Tile(problemSetSettings: e, deleteTile: deleteTile, replaceTile: replaceTile,)).toList();

    setState((){});
  }

  Future<bool> replaceTile(Tile oldTile, ArithmeticSettings newTile) async {
    
    for (int i = 0; i < problemSets.length; i++) {

      if (problemSets[i] == oldTile) {
        problemSets[i] = Tile(
          problemSetSettings: newTile,
          deleteTile: deleteTile,
          replaceTile: replaceTile
        );

        await DatabaseHelper.updateProblemSet(newTile);

        setState((){});
        return true;
      }
    }

    return false;
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
