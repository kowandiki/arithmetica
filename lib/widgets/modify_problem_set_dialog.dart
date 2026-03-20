

import 'package:arithmetica/settings/arithmetic_settings.dart';
import 'package:arithmetica/settings/problem_set_settings.dart';
import 'package:flutter/material.dart';

class ModifyProblemSetDialog extends StatefulWidget {

  final ProblemSetSettings? problemSetSettings;

  const ModifyProblemSetDialog({
    super.key,
    this.problemSetSettings,
  });

  @override
  State<ModifyProblemSetDialog> createState() => _ModifyProblemSetDialogState();

}

class _ModifyProblemSetDialogState extends State<ModifyProblemSetDialog> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _inputTermUpperBoundController = TextEditingController();
  final TextEditingController _inputTermLowerBoundController = TextEditingController();
  final TextEditingController _outputTermUpperBoundController = TextEditingController();
  final TextEditingController _outputTermLowerBoundController = TextEditingController();
  final TextEditingController _upperBoundIncrementController = TextEditingController();
  final TextEditingController _lowerBoundIncrementController = TextEditingController();
  final TextEditingController _upperBoundScaleFactorController = TextEditingController();
  final TextEditingController _lowerBoundScaleFactorController = TextEditingController();
  final TextEditingController _upperBoundCapController = TextEditingController();
  final TextEditingController _lowerBoundCapController = TextEditingController();
  final TextEditingController _startingValueController = TextEditingController();
  final TextEditingController _targetValueController = TextEditingController();

  int operators = 0;
  bool allowNegativeInputValues = false;
  bool allowNegativeOutputValues = false;

  ProblemSetSettings getSettingsFromFields() {
    int id = widget.problemSetSettings == null || widget.problemSetSettings!.id == null 
      ? -1 : widget.problemSetSettings!.id!;
    return ArithmeticSettings(
      id: id, 
      title: _titleController.text, 
      operators: operators,
      inputTermLowerBound: int.tryParse(_inputTermLowerBoundController.text),
      inputTermUpperBound: int.tryParse(_inputTermUpperBoundController.text),
      outputTermLowerBound: int.tryParse(_outputTermLowerBoundController.text),
      outputTermUpperBound: int.tryParse(_outputTermUpperBoundController.text),
      upperBoundIncrement: int.tryParse(_upperBoundIncrementController.text),
      lowerBoundIncrement: int.tryParse(_lowerBoundIncrementController.text),
      upperBoundScaleFactor: double.tryParse(_upperBoundScaleFactorController.text),
      lowerBoundScaleFactor: double.tryParse(_lowerBoundScaleFactorController.text),
      upperBoundCap: int.tryParse(_upperBoundCapController.text),
      lowerBoundCap: int.tryParse(_lowerBoundCapController.text),
      startingValue: int.tryParse(_startingValueController.text),
      targetValue: int.tryParse(_targetValueController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(controller: _titleController,
              decoration: InputDecoration(labelText: "Title")),
            Text("Add, Subtract, Multiply, Divide"),
            Row(
              children: [
                Checkbox( // addition
                  value: operators & 1 != 0,
                  onChanged: (value) {
                    value! ? operators += 1 : operators -= 1; 
                    setState((){});
                  }
                ),
                Checkbox( // subtraction
                  value: operators & 2 != 0,
                  onChanged: (value) {
                    value! ? operators += 2 : operators -= 2; 
                    setState((){});
                  }
                ),
                Checkbox( // multiplication
                  value: operators & 4 != 0,
                  onChanged: (value) {
                    value! ? operators += 4 : operators -= 4; 
                    setState((){});
                  }
                ),
                Checkbox( // division
                  value: operators & 8 != 0,
                  onChanged: (value) {
                    value! ? operators += 8 : operators -= 8; 
                    setState((){});
                  }
                )
              ]
            ),
            TextField(controller: _inputTermLowerBoundController,
              decoration: InputDecoration(labelText: "Input Term Lower Bound")),
            TextField(controller: _inputTermUpperBoundController,
              decoration: InputDecoration(labelText: "Input Term Upper Bound")),
            TextField(controller: _outputTermLowerBoundController,
              decoration: InputDecoration(labelText: "Output Term Lower Bound")),
            TextField(controller: _outputTermUpperBoundController,
              decoration: InputDecoration(labelText: "Output Term Upper Bound")),
            TextField(controller: _lowerBoundIncrementController,
              decoration: InputDecoration(labelText: "Lower Bound Increment")),
            TextField(controller: _upperBoundIncrementController,
              decoration: InputDecoration(labelText: "Upper Bound Increment")),
            TextField(controller: _lowerBoundScaleFactorController,
              decoration: InputDecoration(labelText: "Lower Bound Scale Factor")),
            TextField(controller: _upperBoundScaleFactorController,
              decoration: InputDecoration(labelText: "Upper Bound Scale Factor")),
            TextField(controller: _lowerBoundCapController,
              decoration: InputDecoration(labelText: "Lower Bound Cap")),
            TextField(controller: _upperBoundCapController,
              decoration: InputDecoration(labelText: "Upper Bound Cap")),
            TextField(controller: _startingValueController,
              decoration: InputDecoration(labelText: "Starting Value")),
            TextField(controller: _targetValueController,
              decoration: InputDecoration(labelText: "Target Value")),
            
            

            Text("Allow Negative Input values"),
            Checkbox(
              value: allowNegativeInputValues,
              onChanged: (value) {
                allowNegativeInputValues = !allowNegativeInputValues; 
                setState((){});
              }
            ),

            Text("Allow Negative Output Values"),
            Checkbox(
              value: allowNegativeOutputValues,
              onChanged: (value) {
                allowNegativeOutputValues = !allowNegativeOutputValues;
                setState((){});
              }
            ),

            Row(
              children: [
                ElevatedButton(onPressed: () => Navigator.pop(context, -1), child: Text("Delete")),
                Expanded(child: Container(),),
                widget.problemSetSettings == null || widget.problemSetSettings!.id == null ? 
                  ElevatedButton(onPressed: () => Navigator.pop(context, getSettingsFromFields()), child: Text("Create")) :
                  ElevatedButton(onPressed: () => Navigator.pop(context, getSettingsFromFields()), child: Text("Modify"))
              ]
            ),
            
          ]
        )
      )
    );
  }
  
}