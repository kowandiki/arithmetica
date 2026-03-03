
abstract class ProblemSetSettings {
  /// lowerBound is used in determining the RHS value. Particularly important for addition and multiplication
  final int? outputTermLowerBound;
  /// upperBound is used in determining the RHS value. Particularly important for addition and multiplication
  final int? outputTermUpperBound;
  /// the amount the lower bound changes by after each successful problem completion. If null, the upper bound is not changed
  final int? lowerBoundIncrement;
  /// the amount the lower bound changes by after each successful problem completion. If null, the upper bound is not changed
  final int? upperBoundIncrement;
  /// must be greater than or equal to [lowerBoundScaleFactor], or [lowerBoundScaleFactor] must be null. <br>
  /// Will increase the upper bound by [upperBoundIncrement] or [upperBoundScaleFactor], whichever has a greater magnitude. <br>
  /// if [null], [upperBoundIncrement] is used for increasing the upper bound
  final double? upperBoundScaleFactor;
  /// this value must be less than or equal to the [upperBoundScaleFactor]<br>
  /// Will increase the lower bound by [lowerBoundIncrement] or [lowerBoundScaleFactor], whichever has a greater magnitude.<br>
  /// if null, [lowerBoundIncrement] is used for scaling the lower bound, regardless of if [upperBoundScaleFactor] is set
  final double? lowerBoundScaleFactor;
  /// Intended for use where the upperBound should stay within a fixed range
  final int? upperBoundCap;
  /// Intended for use where the lowerBound should stay within a fixed range
  final int? lowerBoundCap;
  /// Intended for use where the terms should stay within a fixed range
  final int? inputTermUpperBound;
  /// Intended for use where the terms should stay within a fixed range
  final int? inputTermLowerBound;
  /// When set, this is the starting point for reaching the [targetValue]. If [targetValue] is not set, the LHS will always contain this term
  final int? startingValue;
  /// when the target value is reached as an RHS value, the page will pop
  /// This is primarily intended for countdowns to zero, or count ups to a specific value like for mimicing darts 
  final int? targetValue;

  final bool allowNegativeInputValues;
  final bool allowNegativeOutputValues;

  ProblemSetSettings({
    this.inputTermUpperBound, 
    this.inputTermLowerBound, 
    this.outputTermUpperBound, 
    this.outputTermLowerBound, 
    this.upperBoundIncrement, 
    this.lowerBoundIncrement,
    this.upperBoundScaleFactor, 
    this.lowerBoundScaleFactor, 
    this.upperBoundCap, 
    this.lowerBoundCap, 
    this.startingValue, 
    this.targetValue, 
    this.allowNegativeInputValues = false,
    this.allowNegativeOutputValues = false,
  });
}