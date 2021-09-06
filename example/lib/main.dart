import 'package:flutter/material.dart';
import 'package:shamsi_date_picker/shamsi_date_picker.dart';
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
      forwardYear: true,
      border: BorderRadius.only(
          topRight: Radius.circular(15), topLeft: Radius.circular(15)),
      validate: (ctx, date) {
        return date.year < 1402;
      },
      submitButtonStyle: defaultButtonsStyle.copyWith(
        text: 'انتخاب',
        backgroundColor: Colors.blueAccent,
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
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 15),
            Text(
              '${format(_selectedDate)}',
              style: Theme.of(context).textTheme.headline6,
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
