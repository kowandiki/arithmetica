
import 'dart:math';

import 'package:arithmetica/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// bitwise OR these operators together to get more types of operands on the Arithmetic Page
class Operators {
  static const addition = 0x1;
  static const subtraction = 0x2;
  static const multiplication = 0x4;
  static const division = 0x8;
}

class ArithmeticPage extends StatefulWidget {

  final int operators;
  final int startingLowerBound;
  final int startingUpperBound;
  final int increment;
  /// If this value is not null, [increment] is ignored
  final double? upperBoundScaleFactor;

  const ArithmeticPage({
    super.key, 
    required this.operators,
    this.startingLowerBound = 1,
    this.startingUpperBound = 20,
    this.increment = 10,
    this.upperBoundScaleFactor,
  });

  @override
  State<StatefulWidget> createState() => _ArithmeticPageState();
}

class _ArithmeticPageState extends State<ArithmeticPage> {

  int lowerBound = 0;
  int upperBound = 0;
  int leftSide = 0;
  int rightSide = 0;
  int result = 0;
  int operator = 0;
  Random random = Random();

  @override
  void initState() {
    super.initState();
  
    lowerBound = widget.startingLowerBound;
    upperBound = widget.startingUpperBound;
    createNewProblem();
  }

  int popcount(int i) {
    return (i & 1) + 
    ((i >> 1) & 1) + 
    ((i >> 2) & 1) + 
    ((i >> 3) & 1);
  }

  void createNewProblem() {
    operator = 1 << random.nextInt(popcount(widget.operators));

    leftSide = random.nextInt(upperBound - lowerBound) + lowerBound + 1;
    rightSide = random.nextInt(upperBound - lowerBound) + lowerBound + 1;

    if (widget.operators & Operators.addition == 0) {
      operator <<= 1; // not valid operator
    } else if (operator == Operators.addition) {
      // generate random number to be the result
      result = random.nextInt(upperBound - lowerBound) + lowerBound + 1;

      // generate one of the factors following a gaussian to be more heavily biased towards the center
      leftSide = (Util.nextGaussian(random, mean: 0, sigma: result * 1.0)).floor();

      // get the right side number
      rightSide = result - leftSide;
      return;
    }

    if (widget.operators & Operators.subtraction == 0) {
      operator <<= 1; // not valid operator
    } else if (operator == Operators.subtraction) {
      // generate random number to be the left side
      leftSide = random.nextInt(upperBound - lowerBound) + lowerBound + 1;
      
      // generate a random number to be the right side
      rightSide = random.nextInt(upperBound - lowerBound) + lowerBound + 1;

      // if right > left, swap sides
      if (rightSide > leftSide) {
        final temp = rightSide;
        rightSide = leftSide;
        leftSide = temp;
      }

      result = leftSide - rightSide;
      return;
    }

    if (widget.operators & Operators.multiplication == 0) {
      operator <<= 1; // not valid operator
    } else if (operator == Operators.multiplication) {

      // generate random number to be the result
      result = random.nextInt(upperBound - lowerBound) + lowerBound + 1;
      // get its factors
      List<int> factors = Util.getFactors(result);
      // pick a random factor
      if (factors.length > 1) {
        leftSide = factors[random.nextInt(factors.length - 1) + 1];
      } else {
        leftSide = factors[0];
      }
      
      rightSide = result ~/ leftSide;
      return;
    }

    if (operator == Operators.division) {

      // generate numerator in range
      leftSide = random.nextInt(upperBound - lowerBound) + lowerBound + 1;
      // get its factors
      List<int> factors = Util.getFactors(leftSide);
      // pick one factor at random
      rightSide = factors[random.nextInt(factors.length)];
      result = leftSide ~/ rightSide;
      return;
    }

  }

  String getStringFromOperator() {
    if (operator == Operators.addition) {
      return "+";
    }
    if (operator == Operators.subtraction) {
      return "-";
    }
    if (operator == Operators.multiplication) {
      return "*";
    }
    if (operator == Operators.division) {
      return "/";
    }
    return "?";
  }

  void updateBounds() {
    lowerBound += widget.increment;
    final diff = (upperBound * 1.5).round();
    if (diff > widget.increment) {
      upperBound = (upperBound * 1.5).round();
    } else {
      upperBound += widget.increment;

    }
  }

  void wrongAnswerVibrate() async {

    await HapticFeedback.heavyImpact();

    for (int i = 0; i < 2; i++) {
      await Future.delayed(Duration(milliseconds: 250));
      await HapticFeedback.heavyImpact();
    }
    
  }

  bool evaluateAnswer() {

    int? num = int.tryParse(_controller.text);

    
    if (num == null || num != result) {
      return false;
    }

    if (num == result) {
      return true;
    }

    return false;
  }

  void processSubmission() {

    if (evaluateAnswer()) {
      _controller.clear();
      updateBounds();
      createNewProblem();
      setState((){});
      HapticFeedback.heavyImpact();
    } else {
      wrongAnswerVibrate();
    }
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$leftSide ${getStringFromOperator()} $rightSide"),
              ]
            ),
            TextField(
              autofocus: true,
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.numberWithOptions(
                decimal: false,
                signed: true,
              ),
            ),
            ConstrainedBox(constraints: BoxConstraints(maxHeight: 50), child: Container(height: double.infinity)),
            ElevatedButton(
              onPressed: processSubmission,
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.pressed)) {
                    if (evaluateAnswer()) {
                      return Colors.green.withValues(alpha: 0.6);
                    }
                    return Colors.red.withValues(alpha: 0.6);
                  }
                  return Colors.grey;
                })
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(child:Text("Submit"))
              )
            ),
          ]
        )
      )
    );
  }

}