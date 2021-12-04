import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycalculator/calc_colors.dart';
import 'package:mycalculator/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const CalcApp());
}

class CalcApp extends StatelessWidget {
  const CalcApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: CalcColors.background1,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: buildResult(),
            ),
            Expanded(flex: 2, child: buildButtons())
          ],
        ),
      ),
    );
  }

  buildResult() => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Text(
              '0',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 36),
            ),
            SizedBox(height: 24),
            Text(
              '0',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ],
        ),
      );

  //create buildButtons method
  buildButtons() => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            color: CalcColors.background2,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: Column(
          children: [
            buildButtonsRow('AC', '<', '', '÷'),
            buildButtonsRow('7', '8', '9', '⨯'),
            buildButtonsRow('4', '5', '6', '-'),
            buildButtonsRow('1', '2', '3', '+'),
            buildButtonsRow('0', '.', '', '='),
          ],
        ),
      );

  //now create buildButtonsRow method
  Widget buildButtonsRow(
    String first,
    String second,
    String third,
    String fourth,
  ) {
    final row = [first, second, third, fourth];
    return Expanded(
      child: Row(
        children: row
            .map((text) => ButtonWidget(
                  text: text,
                  onClicked: () {},
                ))
            .toList(),
      ),
    );
  }
}

//single button stateless widget
class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);
  final String text;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    final color = getTextColor(text);
    final double fontSize = Utils.isOperator(text) ? 30 : 24;
    final style = TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );

    return Expanded(
      child: Container(
        height: double.infinity,
        margin: const EdgeInsets.all(6),
        child: ElevatedButton(
          onPressed: onClicked,
          style: ElevatedButton.styleFrom(
              primary: CalcColors.background3,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
          child: text == '<'
              ? Icon(Icons.backspace_outlined, color: color)
              : Text(
                  text,
                  style: style,
                ),
        ),
      ),
    );
  }

  Color getTextColor(String buttonText) {
    switch (buttonText) {
      case '+':
      case '-':
      case '⨯':
      case '÷':
      case '=':
        return CalcColors.operators;
      case 'AC':
      case '<':
        return CalcColors.delete;
      default:
        return CalcColors.numbers;
    }
  }
}
