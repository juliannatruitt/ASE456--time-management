import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

import 'database_functions.dart';


class AddRecord extends StatefulWidget {

  @override
  State<AddRecord> createState(){
    return _AddRecordState();
  }
}

class _AddRecordState extends State<AddRecord> {
  late String _selectedValue;
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
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child:
                    DatePicker(
                      currentDate: DateTime.now(),
                      minDate: DateTime(2021, 1, 1),
                      maxDate: DateTime(2028, 12, 31),
                      onDateSelected: (value) {
                        currentTime = value;
                        },
                      ),
                ),
                const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),   // bordered outline
                        labelText: 'TO',
                      ),
                    )
                ),
                const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),   // bordered outline
                        labelText: 'FROM',
                      ),
                    )
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
                           _selectedValue = tagsToList.first;
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
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() async{
          //ADD DATA to DATABASE!!!
          //MAKE sure there are NO NULL Values!!
          //Redirect to home page when it is done (with values displayed)
          //Start to work on Query option!
          //await addRecord(, var to, var description, var tag)
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}