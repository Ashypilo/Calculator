import 'package:flutter/material.dart';
import 'package:helloflutter/main.dart';
import 'package:helloflutter/Database.dart';
import 'package:sqflite/sqflite.dart';

class Calculator extends State<MainActivity> {

  Data _data = new Data();
  String dataSave;
  double operation;
  void _validate(int operation) {
    if (!isNumeric(_data.numOne) || !isNumeric(_data.numTwo)) {
      AlertDialog alert = AlertDialog(
        title: Text("ERROR"),
        content: Text("Number is wrong.\nExemple: 5 or 5.5",
        ),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    else {
      if (operation == 1)
        plus();
      else if (operation == 2)
        minus();
      else if (operation == 3)
        multiplication();
      else
        division();
    }
  }

  void plus() {
    operation = (double.tryParse(_data.numOne) + double.tryParse(_data.numTwo));
    dataSave = operation.toString();
    saveData("+");
    AlertDialog alert = AlertDialog(
      title: Text("Result"),
      backgroundColor: Colors.red,
      content: Text(
          dataSave),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void minus() {
    operation = (double.tryParse(_data.numOne) - double.tryParse(_data.numTwo));
    dataSave = operation.toString();
    saveData("-");
    AlertDialog alert = AlertDialog(
      title: Text("Result"),
      backgroundColor: Colors.blue,
      content: Text(dataSave)
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void division() {
    operation = (double.tryParse(_data.numOne) / double.tryParse(_data.numTwo));
    dataSave = operation.toString();
    saveData("/");
    AlertDialog alert = AlertDialog(
      title: Text("Result"),
      backgroundColor: Colors.green,
      content: Text(dataSave)
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void multiplication() {
    operation = (double.tryParse(_data.numOne) * double.tryParse(_data.numTwo));
    dataSave = operation.toString();
    saveData("*");
    AlertDialog alert = AlertDialog(
      title: Text("Result"),
      backgroundColor: Colors.yellow,
      content: Text(dataSave)
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool isNumeric(String line) {
    if (line == null)
      return false;
    return double.tryParse(line) != null;
  }

  void saveData(String operation) async {
    Database db = await DatabaseHelper.instance.database;
    String data = _data.numOne + operation + _data.numTwo + "=" + dataSave;
    String dataLine = "INSERT INTO saveDataResult (operation) VALUES(\"" + data + "\")";
    print(dataLine);
    db.rawInsert(dataLine);
  }
  _query() async {
    Database db = await DatabaseHelper.instance.database;
    var result = await db.rawQuery('SELECT operation FROM saveDataResult');
    StringBuffer buffer = new StringBuffer();
    result.forEach((row) => lineBuffer(row, buffer));
    outDataBase(buffer);
  }

void lineBuffer(Map line, StringBuffer buffer) {
    int i = line.toString().length - 1;
    String out = line.toString().substring(1, i);
    buffer.write(out);
    buffer.write("\n");
}

void outDataBase(StringBuffer line) {
  AlertDialog alert = AlertDialog(
      title: Text("Save results"),
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text (line.toString(),)
            ],
          ),
        ),
      )
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery
        .of(context)
        .size;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
            child: ListView(
              children: <Widget>[
                TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'number',
                        labelText: 'First number'
                    ),
                    onChanged: (String value) {
                      this._data.numOne = value;
                    }
                ),
                TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'number',
                        labelText: 'Second number'
                    ),
                    onChanged: (String value) {
                      this._data.numTwo = value;
                    }
                ),
                Container(
                  width: screenSize.width,
                  child: RaisedButton(
                    child: Text('+', style: TextStyle(color: Colors.white),),
                    onPressed: () => _validate(1),
                    color: Colors.blue,),
                  margin: EdgeInsets.only(top: 20.0),
                ),
                Container(
                  width: screenSize.width,
                  child: RaisedButton(
                    child: Text('-', style: TextStyle(color: Colors.white),),
                    onPressed: () => _validate(2),
                    color: Colors.blue,),
                  margin: EdgeInsets.only(top: 20.0),),
                Container(
                  width: screenSize.width,
                  child: RaisedButton(
                    child: Text('*', style: TextStyle(color: Colors.white),),
                    onPressed: () => _validate(3),
                    color: Colors.blue,),
                  margin: EdgeInsets.only(top: 20.0),),
                Container(
                  width: screenSize.width,
                  child: RaisedButton(
                    child: Text('\\', style: TextStyle(color: Colors.white),),
                    onPressed: () => _validate(4),
                    color: Colors.blue,),
                  margin: EdgeInsets.only(top: 20.0),
                ),
                Container(
                  width: screenSize.width,
                  child: RaisedButton(
                    child: Text('Data SQLite', style: TextStyle(color: Colors.white),),
                    onPressed: () => _query(),
                    color: Colors.blue,),
                  margin: EdgeInsets.only(top: 20.0),
                ),
              ],
            ),
          )
      ),
    );
  }
}