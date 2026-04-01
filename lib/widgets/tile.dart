
import 'package:arithmetica/settings/arithmetic_settings.dart';
import 'package:arithmetica/settings/problem_set_settings.dart';
import 'package:arithmetica/widgets/modify_problem_set_dialog.dart';
import 'package:flutter/material.dart';
import 'package:arithmetica/pages/arithmetic.dart';
import 'package:flutter/services.dart';

class Tile extends StatelessWidget {
  final ProblemSetSettings problemSetSettings;
  final Function(int?) deleteTile;
  final Function(Tile, ArithmeticSettings) replaceTile;

  const Tile({
    super.key, 
    required this.problemSetSettings,
    required this.deleteTile,
    required this.replaceTile,
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
      onLongPress: () async {
        HapticFeedback.heavyImpact();

        final result = await showDialog(
          context: context,
          builder: (BuildContext context) => ModifyProblemSetDialog(problemSetSettings: problemSetSettings),
        );
        
        if (result == -1) {
          deleteTile(problemSetSettings.id);
          return;
        }

        if (result is ArithmeticSettings) {
          replaceTile(this, result);
          return;
        }
      },
      child: Container(
        decoration: boxDecoration,
        padding: const EdgeInsets.all(10),
        child: Center(child: Text(problemSetSettings.title, textAlign: TextAlign.center,),)
      ),
    );
  }
  
}