
import 'dart:math';

import 'package:arithmetica/settings/arithmetic_settings.dart';
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

  final ArithmeticSettings arithmeticSettings;

  const ArithmeticPage({
    super.key, 
    required this.arithmeticSettings,
  });

  @override
  State<StatefulWidget> createState() => _ArithmeticPageState();
}

class _ArithmeticPageState extends State<ArithmeticPage> {
  
  int? inputTermLowerBound;
  int? inputTermUpperBound;

  int? outputTermLowerBound;
  int? outputTermUpperBound;
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

    // Do basic checks to make sure the settings for the problem are valid
    // make sure there is an upper bound for either the output or input terms
    if (widget.arithmeticSettings.outputTermUpperBound == null && widget.arithmeticSettings.inputTermUpperBound == null) {
      debugPrint("both upper bounds are null; unable to generate problems");
      Navigator.pop(context);
    }
    if (widget.arithmeticSettings.operators == 0) {
      debugPrint("No operators given; exiting");
      Navigator.pop(context);
    }
  
    // set the lower bounds to 0 if its null
    outputTermLowerBound = widget.arithmeticSettings.outputTermLowerBound == null ? 0 : widget.arithmeticSettings.outputTermLowerBound!;
    outputTermUpperBound = widget.arithmeticSettings.outputTermUpperBound;

    inputTermLowerBound = widget.arithmeticSettings.inputTermLowerBound == null ? 0 : widget.arithmeticSettings.inputTermLowerBound!;
    inputTermUpperBound = widget.arithmeticSettings.inputTermUpperBound;

    createNewProblem();
  }

  int popcount(int i) {
    return (i & 1) + 
    ((i >> 1) & 1) + 
    ((i >> 2) & 1) + 
    ((i >> 3) & 1);
  }

  void createMultiplicationProblem() {

    // prioritize that the LHS be within range instead of the RHS if there are no combinations possible to get into the RHS
    // to do this, create a list of all numbers within the RHS range, randomize the order
    // then go through that list until you find a result with a pair of factors within the LHS range

    List<int> numbers = List.generate(outputTermUpperBound! - outputTermLowerBound! + 1, (i) => outputTermLowerBound! + i);
    numbers.sort((a, b) => Comparable.compare(a,b));
    numbers.shuffle(random);

    bool exitLoop = false;
    for (int i in numbers) {
      List<int> factors = Util.getFactors(i, excludeOnes: true);
      factors.shuffle(random);

      for (int factor in factors) {
        if (inputTermLowerBound != null && factor < inputTermLowerBound!) {
          break;
        }
        if (inputTermUpperBound != null && factor > inputTermUpperBound!) {
          break;
        }

        int pair = i ~/ factor;
        if (inputTermLowerBound != null && pair < inputTermLowerBound!) {
          break;
        }
        if (inputTermUpperBound != null && pair > inputTermUpperBound!) {
          break;
        }

        leftSide = factor;
        rightSide = pair;
        result = i;
        exitLoop = true;
      }
      if (exitLoop) {
        break;
      }
    }
  }

  void createNewProblem() {
    debugPrint("output: $outputTermLowerBound-$outputTermUpperBound input: $inputTermLowerBound-$inputTermUpperBound");
    operator = 1 << random.nextInt(popcount(widget.arithmeticSettings.operators));
    
    if (widget.arithmeticSettings.operators & Operators.addition == 0) {
      operator <<= 1; // not valid operator
    } else if (operator == Operators.addition) {

      // need to find two numbers that add to be within the output term range (if possible)
      // prioritize input term range
      // maybe generate a list of all terms within the input term range, randomize the order
      // then go through it from both ends adding the numbers until a result is in the output term range

      // if input term upper bound is not set, need to generate the result first and generate input terms
      if (inputTermUpperBound != null) {
        List<int> numbers = List.generate(inputTermUpperBound! - inputTermLowerBound! + 1, (i) => outputTermLowerBound! + i);
        numbers.sort((a, b) => Comparable.compare(a,b));
        numbers.shuffle(random);

        // go through the list
        for (int i = 0; i < numbers.length; i++) {
          for (int j = numbers.length - 1; j > 0; j--) {
            leftSide = numbers[i];
            rightSide = numbers[j];
            result = leftSide + rightSide;
            if (result > outputTermLowerBound! && (outputTermUpperBound == null || result < outputTermUpperBound!)) {
              return;
            }
          }
        }
        return;
      }
      // input term upper bound is null, so generate the result first then the terms
      // since the input term upper bound is null, the output term upper bound must not be null
      // generate random number to be the result
      result = random.nextInt(outputTermUpperBound! - outputTermLowerBound!) + outputTermLowerBound! + 1;

      // generate one of the factors following a gaussian to be more heavily biased towards the center
      leftSide = (Util.nextGaussian(random, mean: 0, sigma: result.toDouble())).floor() + inputTermLowerBound!;

      // get the right side number
      rightSide = result - leftSide;

      if (rightSide < inputTermLowerBound!) {
        // balance out as much as possible
        rightSide = inputTermLowerBound!;
        leftSide -= rightSide;
        result = leftSide + rightSide;
      }
      return;
    }

    if (widget.arithmeticSettings.operators & Operators.subtraction == 0) {
      operator <<= 1; // not valid operator
    } else if (operator == Operators.subtraction) {
      // generate random number to be the left side
      leftSide = random.nextInt(outputTermUpperBound! - outputTermLowerBound!) + outputTermLowerBound! + 1;
      
      // generate a random number to be the right side
      rightSide = random.nextInt(outputTermUpperBound! - outputTermLowerBound!) + outputTermLowerBound! + 1;

      // if right > left, swap sides
      if (rightSide > leftSide) {
        final temp = rightSide;
        rightSide = leftSide;
        leftSide = temp;
      }

      result = leftSide - rightSide;
      return;
    }

    if (widget.arithmeticSettings.operators & Operators.multiplication == 0) {
      operator <<= 1; // not valid operator
    } else if (operator == Operators.multiplication) {

      createMultiplicationProblem();
      return;
    }

    if (operator == Operators.division) {

      // generate numerator in range
      leftSide = random.nextInt(outputTermUpperBound! - outputTermLowerBound!) + outputTermLowerBound! + 1;
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

    int lowerBoundDiff = widget.arithmeticSettings.lowerBoundScaleFactor == null ? 0 : (outputTermLowerBound! * widget.arithmeticSettings.lowerBoundScaleFactor!).round();
    if (widget.arithmeticSettings.lowerBoundIncrement != null && lowerBoundDiff < widget.arithmeticSettings.lowerBoundIncrement!) {
      lowerBoundDiff = widget.arithmeticSettings.lowerBoundIncrement!;
    }
    // make sure the lowerBound doesn't go over the lowerBoundCap if set
    if (widget.arithmeticSettings.lowerBoundCap != null && outputTermLowerBound! + lowerBoundDiff > widget.arithmeticSettings.lowerBoundCap!) {
      outputTermLowerBound = widget.arithmeticSettings.lowerBoundCap!;
    } else {
      outputTermLowerBound = outputTermLowerBound! + lowerBoundDiff;
    }

    int upperBoundDiff = widget.arithmeticSettings.upperBoundScaleFactor == null ? 0 : (outputTermUpperBound! * widget.arithmeticSettings.upperBoundScaleFactor!).round();
    if (outputTermUpperBound != null) {
      if (widget.arithmeticSettings.upperBoundIncrement != null && upperBoundDiff < widget.arithmeticSettings.upperBoundIncrement!) {
        upperBoundDiff = widget.arithmeticSettings.upperBoundIncrement!;
      }
      if (widget.arithmeticSettings.upperBoundCap != null && outputTermUpperBound! + upperBoundDiff > widget.arithmeticSettings.upperBoundCap!) {
        outputTermUpperBound = widget.arithmeticSettings.upperBoundCap!;
      } else {
        outputTermUpperBound = outputTermUpperBound! + upperBoundDiff;
      }
    }

    upperBoundDiff = widget.arithmeticSettings.upperBoundScaleFactor == null ? 0 : (inputTermUpperBound! * widget.arithmeticSettings.upperBoundScaleFactor!).round();
    if (inputTermUpperBound != null) {
      if (widget.arithmeticSettings.upperBoundIncrement != null && upperBoundDiff < widget.arithmeticSettings.upperBoundIncrement!) {
        upperBoundDiff = widget.arithmeticSettings.upperBoundIncrement!;
      }
      if (widget.arithmeticSettings.upperBoundCap != null && inputTermUpperBound! + upperBoundDiff > widget.arithmeticSettings.upperBoundCap!) {
        inputTermUpperBound = widget.arithmeticSettings.upperBoundCap!;
      } else {
        inputTermUpperBound = inputTermUpperBound! + upperBoundDiff;
      }
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

      if (num == widget.arithmeticSettings.targetValue) {
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
            Expanded(child: Container(),),

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