import 'package:flutter/material.dart';
import 'package:persian_modal_date_picker/persian_date_picker.dart';
import 'package:persian_modal_date_picker/button_style.dart';
import 'package:shamsi_date/shamsi_date.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Date? _selectedDate;

  String format(Date? d) {
    if (d == null) return '';
    final formatter = d.formatter;
    return '${formatter.wN} ${formatter.d} ${formatter.mN} ${formatter.yyyy}';
  }

  void showDatePicker() async {
    await showPersianDatePicker(
      context,
      (context, Date date) async {
        setState(() {
          _selectedDate = date;
        });
        Navigator.of(context).pop();
      },
      yearDirection: YearDirection.both,
      border: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
      validate: (ctx, date) {
        return date.year < 1402;
      },
      cancelButtonStyle: ButtonsStyle(
        text: 'انصراف',
        radius: 10,
      ),
      submitButtonStyle: ButtonsStyle(
        text: 'انتخاب',
        // backgroundColor: Colors.blueAccent,
        radius: 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Selected Date is:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 15),
            Text(
              '${format(_selectedDate)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showDatePicker,
        tooltip: 'show',
        label: Text('Pick Date'),
      ),
    );
  }
}
