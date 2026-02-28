
import 'package:arithmetica/settings/arithmetic_settings.dart';
import 'package:arithmetica/settings/problem_set_settings.dart';
import 'package:flutter/material.dart';
import 'package:arithmetica/pages/arithmetic.dart';

class Tile extends StatelessWidget {
  final String title;
  final ProblemSetSettings problemSetSettings;

  const Tile({
    super.key, 
    required this.title, 
    required this.problemSetSettings
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
              arithmeticSettings: problemSetSettings as ArithmeticSettings
            )
          )

        );
      },
      child: Container(
        decoration: boxDecoration,
        padding: const EdgeInsets.all(10),
        child: Center(child: Text(title, textAlign: TextAlign.center,),)
      ),
    );
  }
  
}