import 'package:flutter/material.dart';
import 'package:time_management_ase456/views/tasks_list.dart';
import 'views/queryRecord.dart';
import 'views/addRecord.dart';
import 'util/database_functions.dart';
import 'package:intl/intl.dart';

void main() async {
  await initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Time Management'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  late Future<List<dynamic>?>? allRecords;
  DateTime? _selectedDateStart;
  DateTime? _selectedDateEnd;
  bool _prioritySelected = false;
  String heading="All Tasks";

  @override
  void initState(){
    super.initState();
    allRecords = getRecordsCollection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [TextButton(onPressed:_whenReportPressed, child: const Text("REPORT")),
                  TextButton(onPressed:_whenPriorityPressed,style: _prioritySelected == true ? ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red),) : null,
                      child: const Text("PRIORITY")),],
      ),
      body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                heading,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
            child: FutureBuilder<List<dynamic>?>(
              future: allRecords,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                else if (snapshot.connectionState == ConnectionState.done){
                  if (snapshot.hasError){
                    return Text('${snapshot.error} occurred');
                  }
                  else if (snapshot.hasData){
                    return
                        TasksList(snapshot.data);
                  }
                }
                return const Text("no data available");
              }
            ),
            ),
          ],
        ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(bottom: 20, right: 20),
        child: Stack (
          alignment: Alignment.bottomRight,
          children: [
            Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              onPressed:(){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddRecord())
                );
              },
              heroTag: "homePageButton",
              child: const Icon(Icons.add),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 70,
              child: FloatingActionButton(
                  onPressed:(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QueryRecord())
                    );
                  },
                  child: const Icon(Icons.search)
              )
            ),
        ]),
      )
    );
  }

  String _convertDateToFormattedString(DateTime date){
    return DateFormat('yyyy/MM/dd').format(date);
  }

  void _whenPriorityPressed(){
    if(!_prioritySelected){
      setState(() {
        allRecords = priority();
        _prioritySelected = !_prioritySelected;
        heading="Priority";
      });
    }
    else{
      setState(() {
        allRecords = getRecordsCollection();
        _prioritySelected = !_prioritySelected;
        heading="All Tasks";
      });
    }
  }

  void _whenReportPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return AlertDialog(
              content: Text("REPORT DATES"),
              actions: [
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: _selectedDateStart ?? DateTime.now(),
                          firstDate: DateTime(2019),
                          lastDate: DateTime(2029),
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            dialogSetState(() {
                              _selectedDateStart = pickedDate;
                            });
                          }
                        });
                      },
                      child: _selectedDateStart == null
                          ? const Text(
                        'Choose Start Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                          : Text(
                        DateFormat('yyyy/MM/dd').format(_selectedDateStart!),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: _selectedDateEnd ?? DateTime.now(),
                          firstDate: DateTime(2019),
                          lastDate: DateTime(2029),
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            dialogSetState(() {
                              _selectedDateEnd = pickedDate;
                            });
                          }
                        });
                      },
                      child: _selectedDateEnd == null
                          ? const Text(
                        'Choose End Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                          : Text(
                        DateFormat('yyyy/MM/dd').format(_selectedDateEnd!),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (_selectedDateStart != null && _selectedDateEnd != null && _selectedDateStart!.isBefore(_selectedDateEnd!)) {
                      Navigator.of(context).pop();
                      setState(() {
                        allRecords = reportDates(_selectedDateStart!, _selectedDateEnd!);
                        heading='Tasks from ${_convertDateToFormattedString(_selectedDateStart!)} to ${_convertDateToFormattedString(_selectedDateEnd!)}';
                        if (_prioritySelected){_prioritySelected=!_prioritySelected;}
                      });
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Show Tasks"),
                ),
                ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
