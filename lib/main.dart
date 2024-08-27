import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  ThemeMode _themeMode = ThemeMode.system;
  String _result = '0';
  String _expression = '';

  void _handleButtonPress(String value) {
    setState(() {
      if (value == 'C') {
        _result = '0';
        _expression = '';
      } else if (value == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression);
          ContextModel cm = ContextModel();
          double result = exp.evaluate(EvaluationType.REAL, cm);
          _result = result.toStringAsFixed(2);
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _expression += value;
        if (_expression == '0') {
          _expression = value;
        }
        _result = _expression;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isPortrait = constraints.maxWidth < constraints.maxHeight;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    _result,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isPortrait ? 4 : 6,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: _buttons.length,
                    itemBuilder: (context, index) {
                      return _buildButton(_buttons[index]);
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                FilledButton.icon(
                  onPressed: () {
                    setState(() {
                      _themeMode = _themeMode == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    });
                  },
                  icon: Icon(
                    _themeMode == ThemeMode.light
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  label: Text('Toggle Theme'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildButton(CalculatorButton button) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: button.isOperator
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceVariant,
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: () => _handleButtonPress(button.value),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Center(
            child: Text(
              button.value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: button.isOperator
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class CalculatorButton {
  final String value;
  final bool isOperator;

  CalculatorButton({
    required this.value,
    this.isOperator = false,
  });
}

final List<CalculatorButton> _buttons = [
  CalculatorButton(value: 'C'),
  CalculatorButton(value: '+/-'),
  CalculatorButton(value: '%', isOperator: true),
  CalculatorButton(value: '/', isOperator: true),
  CalculatorButton(value: '7'),
  CalculatorButton(value: '8'),
  CalculatorButton(value: '9'),
  CalculatorButton(value: '*', isOperator: true),
  CalculatorButton(value: '4'),
  CalculatorButton(value: '5'),
  CalculatorButton(value: '6'),
  CalculatorButton(value: '-', isOperator: true),
  CalculatorButton(value: '1'),
  CalculatorButton(value: '2'),
  CalculatorButton(value: '3'),
  CalculatorButton(value: '+', isOperator: true),
  CalculatorButton(value: '0'),
  CalculatorButton(value: '.'),
  CalculatorButton(value: 'X'),
  CalculatorButton(value: '=', isOperator: true),
];