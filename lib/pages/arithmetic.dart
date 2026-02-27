
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

/// Page for generating and testing the user with basic arithmetic operations (addition, subtraction, multiplication, and division). <br>
/// This page will automatically exit if the [targetValue] is reached, or if the upper and lower bounds equal.
class ArithmeticPage extends StatefulWidget {

  /// A bit vector representing which operators should be used when generating problems. <br>
  /// Multiple operators can be used simultaneously by bitwise ORing the operator bytes as defined in [Operators]
  final int operators;
  /// lowerBound is used in determining the RHS value in addition and multiplication, and the LHS values in subtraction and division
  final int startingLowerBound;
  /// upperBound is used in determining the RHS value in addition and multiplication, and the LHS values in subtraction and division
  final int startingUpperBound;
  /// the amount the upper and lower bounds change by after each successful problem completion
  final int increment;
  /// must be greater than or equal to [lowerBoundScaleFactor], or [lowerBoundScaleFactor] must be null. <br>
  /// Will increase the upper bound by [increment] or [upperBoundScaleFactor], whichever has a greater magnitude. <br>
  /// if [null], [increment] is used for scaling the upper bound
  final double? upperBoundScaleFactor;
  /// this value must be less than or equal to the [upperBoundScaleFactor]<br>
  /// Will increase the lower bound by [increment] or [lowerBoundScaleFactor], whichever has a greater magnitude.<br>
  /// if null, [increment] is used for scaling the lower bound, regardless of if [upperBoundScaleFactor] is set
  final double? lowerBoundScaleFactor;
  /// Intended for use where the upperBound should stay within a fixed range
  final int? upperBoundCap;
  /// Intended for use where the lowerBound should stay within a fixed range
  final int? lowerBoundCap;

  /// Intended for use where the terms should stay within a fixed range
  final int? inputTermUpperBound;
  /// Intended for use where the terms should stay within a fixed range
  final int? inputTermLowerBound;
  /// When set, the LHS will always contain this value
  final int? startingValue;
  /// when the target value is reached as an RHS value, the page will pop
  /// This is primarily intended for countdowns to zero, or count ups to a specific value like for mimicing darts 
  final int? targetValue;

  final bool allowNegatives;

  const ArithmeticPage({
    super.key, 
    required this.operators,
    this.startingLowerBound = 1,
    this.startingUpperBound = 20,
    this.increment = 10,
    this.upperBoundScaleFactor, 
    this.lowerBoundScaleFactor, 
    this.upperBoundCap, 
    this.lowerBoundCap, 
    this.inputTermUpperBound, 
    this.inputTermLowerBound, 
    this.startingValue,
    this.targetValue,
    this.allowNegatives = false,
  });

  @override
  State<StatefulWidget> createState() => _ArithmeticPageState();
}

class _ArithmeticPageState extends State<ArithmeticPage> {

  int lowerBound = 0;
  int upperBound = 0;
  int? startingValue;
  int? targetValue;

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
      if (factors.length > 1) {
        rightSide = factors[random.nextInt(factors.length - 1) + 1];
      } else {
        rightSide = factors[0];
      }
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

    int lowerBoundDiff = widget.lowerBoundScaleFactor == null ? 0 : (lowerBound * widget.lowerBoundScaleFactor!).round();
    if (lowerBoundDiff < widget.increment) {
      lowerBoundDiff = widget.increment;
    }
    // make sure the lowerBound doesn't go over the lowerBoundCap if set
    if (widget.lowerBoundCap != null && lowerBound + lowerBoundDiff > widget.lowerBoundCap!) {
      lowerBound = widget.lowerBoundCap!;
    } else {
      lowerBound += lowerBoundDiff;
    }

    int upperBoundDiff = widget.upperBoundScaleFactor == null ? 0 : (upperBound * widget.upperBoundScaleFactor!).round();
    if (upperBoundDiff < widget.increment) {
      upperBoundDiff = widget.increment;
    }
    if (widget.upperBoundCap != null && upperBound + upperBoundDiff > widget.upperBoundCap!) {
      upperBound = widget.upperBoundCap!;
    } else {
      upperBound += upperBoundDiff;
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

      if (num == widget.targetValue) {
        Navigator.pop(context);
      }
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
            Expanded(child: Container(),),
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