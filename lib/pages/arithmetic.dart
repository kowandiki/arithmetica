
import 'dart:math';

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
      result = leftSide + rightSide;
      return;
    }

    if (widget.operators & Operators.subtraction == 0) {
      operator <<= 1; // not valid operator
    } else if (operator == Operators.subtraction) {
      result = leftSide - rightSide;
      return;
    }

    if (widget.operators & Operators.multiplication == 0) {
      operator <<= 1; // not valid operator
    } else if (operator == Operators.multiplication) {
      result = leftSide * rightSide;
      return;
    }

    if (operator == Operators.division) {
      
      int divisor = random.nextInt(upperBound);
      int maxQuotient = upperBound ~/ divisor;
      int quotient = random.nextInt(maxQuotient);
      int dividend = divisor * quotient;

      rightSide = divisor;
      leftSide = dividend;
      result = quotient;
      
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
    // lowerBound += widget.increment;
    upperBound += widget.increment;
  }

  void wrongAnswerVibrate() async {

    await HapticFeedback.vibrate();

    for (int i = 0; i < 2; i++) {
      await Future.delayed(Duration(milliseconds: 250));
      await HapticFeedback.vibrate();
    }
    
  }

  void evaluateAnswer() {

    int? num = int.tryParse(_controller.text);
    
    if (num == null || num != result) {
      wrongAnswerVibrate();
    }

    if (num == result) {
      updateBounds();
      createNewProblem();
      _controller.clear();
      setState((){});
      HapticFeedback.heavyImpact();
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
            ElevatedButton(
              onPressed: evaluateAnswer, 
              child: SizedBox(
                width: double.infinity,
                child: Center(child:Text("Submit"))
              )
            )
          ]
        )
      )
    );
  }

}