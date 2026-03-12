

import 'package:arithmetica/settings/problem_set_settings.dart';

class ArithmeticSettings extends ProblemSetSettings {
  /// A bit vector representing which operators should be used when generating problems. <br>
  /// Multiple operators can be used simultaneously by bitwise ORing the operator bytes as defined in [Operators]
  final int operators;

  ArithmeticSettings({
    required super.id,
    required super.title,
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

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'operators': operators
    };
  }
  
  static ProblemSetSettings fromMap(Map<String, dynamic> map) {
    return ArithmeticSettings(
      id: map['id'],
      title: map['title'],
      operators: map['operators'] ?? 0,
      inputTermUpperBound:  map['inputTermUpperBound'],
      inputTermLowerBound:  map['inputTermLowerBound'],
      outputTermLowerBound: map['outputTermLowerBound'],
      outputTermUpperBound: map['outputTermUpperBound'],
      lowerBoundIncrement:  map['lowerBoundIncrement'],
      upperBoundIncrement:  map['upperBoundIncrement'],
      upperBoundScaleFactor: map['upperBoundScaleFactor'],
      lowerBoundScaleFactor: map['lowerBoundScaleFactor'],
      lowerBoundCap: map['lowerBoundCap'],
      upperBoundCap: map['upperBoundCap'],
      startingValue: map['startingValue'],
      targetValue: map['targetValue'],
      allowNegativeInputValues: map['allowNegativeInputValues'] == 1,
      allowNegativeOutputValues: map['allowNegativeOutputValues'] == 1, 
    );
  }
}