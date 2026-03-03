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

  @override
  Widget build(BuildContext context) {

    ArithmeticSettings test = ArithmeticSettings(operators: 1);
    test.inputTermLowerBound;

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
          children: <Widget>[
            
            Tile(
              title: "addition",
              problemSetSettings: ArithmeticSettings(
                operators: Operators.addition,
                outputTermLowerBound: 1,
                outputTermUpperBound: 5,
                inputTermLowerBound: 1,
                inputTermUpperBound: 20,
                lowerBoundIncrement: 5,
                upperBoundIncrement: 5,
                lowerBoundScaleFactor: 1.05,
                upperBoundScaleFactor: 1.05
              ),
            ),
            Tile(
              title: "addition input numbers 1-100",
              problemSetSettings: ArithmeticSettings(
                operators: Operators.addition,
                inputTermLowerBound: 1,
                inputTermUpperBound: 100,
                lowerBoundIncrement: 0,
                upperBoundIncrement: 0,
              ),
            ),
            Tile(
              title: "addition output numbers 100-1000",
              problemSetSettings: ArithmeticSettings(
                operators: Operators.addition,
                outputTermLowerBound: 100,
                outputTermUpperBound: 1000,
              ),
            ),
            Tile(
              title: "subtraction",
              problemSetSettings: ArithmeticSettings(
                operators: Operators.subtraction,
                outputTermLowerBound: 1,
                outputTermUpperBound: 20,
                lowerBoundIncrement: 5,
                upperBoundIncrement: 5,
                lowerBoundScaleFactor: 1.05,
                upperBoundScaleFactor: 1.05,
              ),
            ),
            Tile(
              title: "multiplication",
              problemSetSettings: ArithmeticSettings(
                operators: Operators.multiplication,
                outputTermLowerBound: 1,
                outputTermUpperBound: 20,
                lowerBoundIncrement: 5,
                upperBoundIncrement: 5,
                lowerBoundScaleFactor: 1.05,
                upperBoundScaleFactor: 1.05,
              ),
            ),
            Tile(
              title: "division",
              problemSetSettings: ArithmeticSettings(
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
              title: "addition, subtraction\n5increment",
              problemSetSettings: ArithmeticSettings(
                operators: Operators.addition | Operators.subtraction,
                outputTermLowerBound: 1,
                outputTermUpperBound: 20,
                lowerBoundIncrement: 5,
                upperBoundIncrement: 5,
                lowerBoundScaleFactor: 1.05,
                upperBoundScaleFactor: 1.05,
              ),
            ),
            Tile(
              title: "multiplication, division\n5 increment", 
              problemSetSettings: ArithmeticSettings(
                operators: Operators.multiplication | Operators.division,
                outputTermLowerBound: 1,
                outputTermUpperBound: 20,
                lowerBoundIncrement: 5,
                upperBoundIncrement: 5,
                lowerBoundScaleFactor: 1.05,
                upperBoundScaleFactor: 1.05,
              ),
            ),

            

            Tile(
              title: "all 4",
              problemSetSettings: ArithmeticSettings(
                operators: Operators.addition | Operators.subtraction | Operators.multiplication | Operators.division,
                outputTermLowerBound: 1,
                outputTermUpperBound: 20,
                lowerBoundIncrement: 5,
                upperBoundIncrement: 5,
                lowerBoundScaleFactor: 1.05,
                upperBoundScaleFactor: 1.05,
              ),
            ),

            Tile(
              title: "12x12 times table",
              problemSetSettings: ArithmeticSettings(
                operators: Operators.multiplication,
                inputTermLowerBound: 2,
                inputTermUpperBound: 12,
                outputTermLowerBound: 1,
                outputTermUpperBound: 200,
              ),
            ),

            Tile(
              title: "15x15 times table",
              problemSetSettings: ArithmeticSettings(
                operators: Operators.multiplication,
                inputTermLowerBound: 2,
                inputTermUpperBound: 15,
                outputTermLowerBound: 1,
                outputTermUpperBound: 200,
              ),
            ),
            
          ]
        )
      ),
    );
  }
}
