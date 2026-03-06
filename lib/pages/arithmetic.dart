
import 'dart:math';

import 'package:arithmetica/feistel_generator.dart';
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

  void createProblemGeneric(Function(int, int) operator, Function(int, int) inverse) {

    if (inputTermUpperBound != null) {
      

      FeistelGenerator fg = FeistelGenerator(inputTermUpperBound! - inputTermLowerBound! + 1);
      
      // allocate list for the numbers
      // then as each number is generated, add it to the list
      // and just add num-1 and num, see if its valid

      // do this until all numbers have been generated. If still no valid combos, double for loop like before
      // should give a question fairly quickly in most cases
      List<int> numbers = [];

      int counter = 0;

      for (int i in fg.next()) {
        counter++;
        int n = i + outputTermLowerBound!;

        numbers.add(n);

        if (numbers.length < 2) {
          continue;
        }

        leftSide = numbers[numbers.length - 2];
        rightSide = numbers[numbers.length - 1];
        dynamic tempResult = operator(leftSide, rightSide);

        // want to skip if operator is division and the left and right side are not factors
        if (tempResult.floor() != tempResult.ceil()) {
          debugPrint("Skipping $leftSide OP $rightSide because the result is not an integer");
          continue;
        }
        result = tempResult.toInt();

        if (result < 0) {
          int temp = leftSide;
          leftSide = rightSide;
          rightSide = temp;
          result = operator(leftSide, rightSide);
        }

        // check if valid
        if (result > outputTermLowerBound! && (outputTermUpperBound == null || result < outputTermUpperBound!)) {
          debugPrint("Found a result in $counter iterations");
          debugPrint("$leftSide OP $rightSide = $result");
          return;
        }
      }

      // go through the list and check all possible combinations
      debugPrint("Checking all possible combinations");
      for (int i = 0; i < numbers.length; i++) {
        for (int j = numbers.length - 1; j > 0; j--) {
          leftSide = numbers[i];
          rightSide = numbers[j];
          result = operator(leftSide, rightSide);
          if (result < 0) {
            int temp = leftSide;
            leftSide = rightSide;
            rightSide = temp;
            result = operator(leftSide, rightSide);
          }
          if (result > outputTermLowerBound! && (outputTermUpperBound == null || result < outputTermUpperBound!)) {
            return;
          }
        }
      }
      return;
    }

    // go through all numbers in the output term bounds
    // outputTermUpperBound is not null, since inputTermUpperBound is null
    FeistelGenerator fg = FeistelGenerator(outputTermUpperBound! - outputTermLowerBound! + 1);
    int counter = 0;
    for (result in fg.next()) {
      result += outputTermLowerBound!; // make it range from [outputTermLowerBound -> outputTermUpperBound]
      // generate an input number between inputTermLowerBound and result

      // this check makes it possible for no problem to ever be generated as it is
      // will only happen in the case of bad bounds, and will show the previous question, or 0 OP 0
      if (result < inputTermLowerBound!) {
        continue;
      }

      // have the rightSide be biased more towards the left side of the distribution
      // makes multiplication and division results more challenging while having a minimal impact on addition/subtraction
      rightSide = Util.nextGaussian(random, sigma: (result - inputTermLowerBound!).toDouble(), skew: -2.0).floor() + inputTermLowerBound! + 1;

      // rightSide = random.nextInt(result - inputTermLowerBound!) + inputTermLowerBound! + 1;
      // get the other input number from the inverse of operator on result
      leftSide = inverse(result, rightSide).round();
      counter++;
      // if the left side is still a valid input number, use it
      if (leftSide > inputTermLowerBound!) {
        // need to update result since leftSide got rounded
        // technically can cause the result to go outside of the range, but relatively unlikely
        // worth it for the reduced complexity
        result = operator(leftSide, rightSide);
        debugPrint("Found result after $counter/${outputTermUpperBound! - outputTermLowerBound! + 1} || $leftSide OP $rightSide = $result");
        debugPrint("input term lower bound^ $inputTermLowerBound");
        return;
      }
    }
    result = operator(leftSide, rightSide);
    debugPrint("did not find a valid result; using $leftSide OP $rightSide = $result");
  }

  void createNewProblem() {
    debugPrint("output: $outputTermLowerBound-$outputTermUpperBound input: $inputTermLowerBound-$inputTermUpperBound");
    operator = 1 << random.nextInt(popcount(widget.arithmeticSettings.operators));
    
    if (widget.arithmeticSettings.operators & Operators.addition == 0) {
      operator <<= 1; // not valid operator
    } else if (operator == Operators.addition) {
      createProblemGeneric((x,y) => x+y, (x,y) => x-y);
      return;
    }

    if (widget.arithmeticSettings.operators & Operators.subtraction == 0) {
      operator <<= 1; // not valid operator
    } else if (operator == Operators.subtraction) {
      createProblemGeneric((x,y) => x-y, (x,y) => x+y);
      return;
    }

    if (widget.arithmeticSettings.operators & Operators.multiplication == 0) {
      operator <<= 1; // not valid operator
    } else if (operator == Operators.multiplication) {
      createProblemGeneric((x,y) => x*y, (x,y) => x/y);
      return;
    }

    if (operator == Operators.division) {
      createProblemGeneric((x,y) => x/y, (x,y) => x*y);
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

    lowerBoundDiff = widget.arithmeticSettings.lowerBoundScaleFactor == null ? 0 : (inputTermLowerBound! * widget.arithmeticSettings.lowerBoundScaleFactor!).round();
    if (widget.arithmeticSettings.lowerBoundIncrement != null && lowerBoundDiff < widget.arithmeticSettings.lowerBoundIncrement!) {
      lowerBoundDiff = widget.arithmeticSettings.lowerBoundIncrement!;
    }
    // make sure the lowerBound doesn't go over the lowerBoundCap if set
    if (widget.arithmeticSettings.lowerBoundCap != null && inputTermLowerBound! + lowerBoundDiff > widget.arithmeticSettings.lowerBoundCap!) {
      inputTermLowerBound = widget.arithmeticSettings.lowerBoundCap!;
    } else {
      inputTermLowerBound = inputTermLowerBound! + lowerBoundDiff;
    }

    int upperBoundDiff;
    if (outputTermUpperBound != null) {
      int upperBoundDiff = widget.arithmeticSettings.upperBoundScaleFactor == null ? 0 : (outputTermUpperBound! * widget.arithmeticSettings.upperBoundScaleFactor!).round();
      if (widget.arithmeticSettings.upperBoundIncrement != null && upperBoundDiff < widget.arithmeticSettings.upperBoundIncrement!) {
        upperBoundDiff = widget.arithmeticSettings.upperBoundIncrement!;
      }
      if (widget.arithmeticSettings.upperBoundCap != null && outputTermUpperBound! + upperBoundDiff > widget.arithmeticSettings.upperBoundCap!) {
        outputTermUpperBound = widget.arithmeticSettings.upperBoundCap!;
      } else {
        outputTermUpperBound = outputTermUpperBound! + upperBoundDiff;
      }
    }

    if (inputTermUpperBound != null) {
      upperBoundDiff = widget.arithmeticSettings.upperBoundScaleFactor == null ? 0 : (inputTermUpperBound! * widget.arithmeticSettings.upperBoundScaleFactor!).round();
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