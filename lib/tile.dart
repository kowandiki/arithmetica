
import 'package:flutter/material.dart';
import 'package:arithmetica/pages/arithmetic.dart';

class Tile extends StatelessWidget {
  final String title;
  final int increment;
  final int rounds;
  final int operators;
  final int startingUpperBound;
  final int startingLowerBound;
  final int? inputTermLowerBound;
  final int? inputTermUpperBound;

  final double? upperBoundScaleFactor; // how much faster the upper bound should scale than the lower bound
  const Tile({
    super.key, 
    required this.title, 
    required this.increment, 
    required this.rounds, 
    required this.operators, 
    this.startingUpperBound = 20,
    this.startingLowerBound = 1,
    this.upperBoundScaleFactor, 
    this.inputTermLowerBound, 
    this.inputTermUpperBound,
  });


  @override
  Widget build(BuildContext context) {

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

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => ArithmeticPage(
              operators: operators,
              inputTermLowerBound: inputTermLowerBound,
              inputTermUpperBound: inputTermUpperBound,
            )
          )

        );
      },
      child: Container(
        decoration: boxDecoration,
        padding: const EdgeInsets.all(10),
        child: Center(child: Text("$title\n$increment increment", textAlign: TextAlign.center,),)
      ),
    );
  }
  
}