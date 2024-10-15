import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database_functions.dart';


class AddRecord extends StatefulWidget {

  @override
  State<AddRecord> createState(){
    return _AddRecordState();
  }
}

class _AddRecordState extends State<AddRecord> {
  //final _valueList = ['First', 'Second', 'Third'];
  late String _selectedValue;
  final _initialDateTime = DateTime(1969, 1, 1);
  late var currentTime;
  late Future<Set<dynamic>> allTags;

  @override
  void initState() {
    super.initState();
    allTags = getTags();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _initialDateTime,
                    onDateTimeChanged: (DateTime newDateTime) {
                      currentTime = newDateTime;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),   // bordered outline
                      labelText: 'Task Description',
                    ),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FutureBuilder(
                      future: allTags,
                      builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.done){
                          if (snapshot.hasError) {
                            return Text('${snapshot.error} occurred');
                          }
                          else if (snapshot.hasData && snapshot.data!.isNotEmpty){
                           var tagsToList = snapshot.data!.toList();
                           _selectedValue = tagsToList[0];
                            return DropdownButton(
                              value: _selectedValue,
                              items: tagsToList.map(
                                  (value){
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedValue = value as String;
                                });
                              },
                            );
                          }
                        }
                        return const Center(child: CircularProgressIndicator());
                      }),

                  //DropdownButton(
                  //  value: _selectedValue,
                  //  items: _valueList.map(
                  //        (value) {
                  //      return DropdownMenuItem(
                  //        value: value,
                  //        child: Text(value),
                  //      );
                  //    },
                  //  ).toList(),
                  //  onChanged: (value) {
                  //    setState(() {
                  //      _selectedValue = value as String;
                  //    });
                  //  },
                  //),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}