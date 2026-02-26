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
              increment: 10,
              rounds: -1,
              operators: Operators.addition,
            ),
            Tile(
              title: "addition",
              increment: 5,
              rounds: -1,
              operators: Operators.addition,
            ),
            Tile(
              title: "subtraction",
              increment: 10,
              rounds: -1,
              operators: Operators.subtraction,
            ),
            Tile(
              title: "subtraction",
              increment: 5,
              rounds: -1,
              operators: Operators.subtraction,
            ),
            Tile(
              title: "multiplication",
              increment: 10,
              rounds: -1,
              operators: Operators.multiplication,
            ),
            Tile(
              title: "division",
              increment: 10,
              rounds: -1,
              operators: Operators.division,
            ),

            Tile(
              title: "addition, subtraction",
              increment: 10,
              rounds: -1,
              operators: Operators.addition | Operators.subtraction,
            ),
            Tile(
              title: "multiplication, division",
              increment: 10,
              rounds: -1,
              operators: Operators.multiplication | Operators.division,
            ),

            Tile(
              title: "all 4",
              increment: 10,
              rounds: -1,
              operators: Operators.addition | Operators.subtraction | Operators.multiplication | Operators.division,
            ),
            
          ]
        )
      ),
    );
  }
}
