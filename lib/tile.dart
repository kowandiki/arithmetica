
import 'package:arithmetica/db/database_helper.dart';
import 'package:arithmetica/settings/arithmetic_settings.dart';
import 'package:arithmetica/settings/problem_set_settings.dart';
import 'package:flutter/material.dart';
import 'package:arithmetica/pages/arithmetic.dart';
import 'package:flutter/services.dart';

class Tile extends StatelessWidget {
  final ProblemSetSettings problemSetSettings;

  const Tile({
    super.key, 
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
      onLongPress: () {
        // this should ideally open a dialog to edit or delete the tile. For now, just delete
        DatabaseHelper.removeProblemSet(problemSetSettings.id);
        HapticFeedback.heavyImpact();
        // need a function callback to delete the widget and update state. For now, this is fine.
      },
      child: Container(
        decoration: boxDecoration,
        padding: const EdgeInsets.all(10),
        child: Center(child: Text(problemSetSettings.title, textAlign: TextAlign.center,),)
      ),
    );
  }
  
}