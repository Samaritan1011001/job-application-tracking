import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Management',
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
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: 'Application Management'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
  int _counter = 0;
  List<ApplicationModel> applications = [];
  ApplicationModel newApplication = ApplicationModel(
    appliedOn: DateTime.now()
  );
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 60.0),
            child: IconButton(
              icon: Icon(Icons.insert_chart),
              iconSize: 50,
              color: Colors.white,
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context)=>ChartScreen()
                ));
              },
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[200],
                    elevation: 3,
                    child: ListTile(
                      title: Text(applications[index].companyName),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(applications[index].companyType),
                          Text(DateFormat('yyyy-MM-dd').format(applications[index].appliedOn)),
                          Text(basename(applications[index].resumeSubmitted.absolute.path))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            color: Colors.grey,
            width: 2,
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: 200,
                              child: Text(
                                "Company Name:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                  width: 400,
                                  child: TextFormField(
                                    initialValue: newApplication.companyName,
                                    onSaved: (cn) {
                                      newApplication.companyName = cn;
                                    },
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: 200,
                              child: Text(
                                "Company Type:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                width: 400,
                                child: TextFormField(
                                  onSaved: (cn) {
                                    newApplication.companyType = cn;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: 200,
                              child: Text(
                                "Resume:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                width: 400,
                                height: 30,
//                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.all(Radius.circular(5)),
//                                  border: Border.all(
//                                    color: Colors.grey[400]
//                                  ),
//                                ),
                                child: RaisedButton(
                                  elevation: 4,
                                  onPressed: () async {
                                    final file = OpenFilePicker()
                                      ..filterSpecification = {'PDF (*.pdf)': '*.pdf', 'All Files': '*.*'}
                                      ..defaultFilterIndex = 0
                                      ..defaultExtension = 'doc'
                                      ..title = 'Select a document';

                                    final result = file.getFile();
                                    if (result != null) {
                                      print(result.path);
                                      newApplication.resumeSubmitted = result;
                                      setState(() {});
                                    }
                                  },
                                  child: Text(newApplication.resumeSubmitted == null ? "Pick a file" : basename(newApplication.resumeSubmitted.path)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 200,
                              child: Text(
                                "Applied on: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(child: SfDateRangePicker(
                            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                              if (args.value is DateTime) {
                                newApplication.appliedOn = args.value;
                              }
                            },
                            initialSelectedDate: DateTime.now(),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: Text("Add"),
                        onPressed: () {
                          _formKey.currentState.save();
                          if(newApplication.companyName!="" &&newApplication.companyType!="" && newApplication.resumeSubmitted!=null && newApplication.appliedOn!=null ) {
                            setState(() {
                              applications.add(newApplication);
                              newApplication = ApplicationModel(
                                  appliedOn: DateTime.now()
                              );
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ApplicationModel {
  String companyName = "";
  String companyType = "";
  DateTime appliedOn;
  File resumeSubmitted;
  ApplicationModel({this.appliedOn});
}

class ChartScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Charts"),
        centerTitle: true,
      ),
      body: Center(
          child: Container(
              child: SfCartesianChart(
                // Initialize category axis
                  primaryXAxis: CategoryAxis(),

                  series: <LineSeries<SalesData, String>>[
                    LineSeries<SalesData, String>(
                      // Bind data source
                        dataSource:  <SalesData>[
                          SalesData('Jan', 35),
                          SalesData('Feb', 28),
                          SalesData('Mar', 34),
                          SalesData('Apr', 32),
                          SalesData('May', 40)
                        ],
                        xValueMapper: (SalesData sales, _) => sales.year,
                        yValueMapper: (SalesData sales, _) => sales.sales
                    )
                  ]
              )
          )
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
