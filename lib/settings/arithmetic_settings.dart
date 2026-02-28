

import 'package:arithmetica/settings/problem_set_settings.dart';

class ArithmeticSettings extends ProblemSetSettings {
  /// A bit vector representing which operators should be used when generating problems. <br>
  /// Multiple operators can be used simultaneously by bitwise ORing the operator bytes as defined in [Operators]
  final int operators;

  ArithmeticSettings({
    required this.operators,
    super.inputTermUpperBound, 
    super.inputTermLowerBound, 
    super.outputTermUpperBound, 
    super.outputTermLowerBound, 
    super.upperBoundIncrement, 
    super.lowerBoundIncrement,
    super.upperBoundScaleFactor, 
    super.lowerBoundScaleFactor, 
    super.upperBoundCap, 
    super.lowerBoundCap, 
    super.startingValue, 
    super.targetValue, 
    super.allowNegativeInputValues = false,
    super.allowNegativeOutputValues = false,
  }) : super();
}