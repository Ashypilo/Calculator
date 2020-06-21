import 'package:flutter/material.dart';
import 'package:helloflutter/Calculator.dart';

void main() => runApp(new MaterialApp(
  home: new MainActivity(),
));

class MainActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new Calculator();
}

class Data {
  String numOne = '';
  String numTwo = '';
}





