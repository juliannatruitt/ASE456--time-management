import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

import 'database_functions.dart';
import 'main.dart';


class AddRecord extends StatefulWidget {

  @override
  State<AddRecord> createState(){
    return _AddRecordState();
  }
}

class _AddRecordState extends State<AddRecord> {
  late String _selectedValue;
  late String _timeInHoursFrom='12';
  late String _timeInMinutesFrom='00';
  late String _amOrPmFrom='PM';
  late String _timeInHoursTo='1';
  late String _timeInMinutesTo='00';
  late String _amOrPmTo='PM';
  late var currentTime;
  late Future<Set<dynamic>> allTags;
  List<dynamic> tagsToList =[];
  String? _timeFrom;
  String? _timeTo;
  String? _description;
  late String _newTag;

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
            child: SingleChildScrollView(
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
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(children: [
                        DropdownButton(
                        value: _timeInHoursFrom,
                        items: ['1','2','3','4','5','6','7','8','9','10','11','12'].map(
                                (value){
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }
                        ).toList(),
                        onChanged: (value) {
                          setState(() {
                            _timeInHoursFrom = value as String;
                          });
                        },
                      ),
                        DropdownButton(
                          value: _timeInMinutesFrom,
                          items: ['00','05','10','15','20','25','30','35','40','45','50','55'].map(
                                  (value){
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              _timeInMinutesFrom = value as String;
                            });
                          },
                        ),
                        DropdownButton(
                          value: _amOrPmFrom,
                          items: ['AM','PM'].map(
                                  (value){
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              _amOrPmFrom = value as String;
                            });
                          },
                        ),
                      ],
                      ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(children: [
                        DropdownButton(
                          value: _timeInHoursTo,
                          items: ['1','2','3','4','5','6','7','8','9','10','11','12'].map(
                                  (value){
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              _timeInHoursTo = value as String;
                            });
                          },
                        ),
                        DropdownButton(
                          value: _timeInMinutesTo,
                          items: ['00','05','10','15','20','25','30','35','40','45','50','55'].map(
                                  (value){
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              _timeInMinutesTo = value as String;
                            });
                          },
                        ),
                        DropdownButton(
                          value: _amOrPmTo,
                          items: ['AM','PM'].map(
                                  (value){
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              _amOrPmTo = value as String;
                            });
                          },
                        ),
                      ],
                      ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),   // bordered outline
                          labelText: 'Task Description',
                        ),
                          onChanged: (text) {_description=text;}
                      ),
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
                              if (tagsToList.isEmpty) {
                                tagsToList = snapshot.data!.toList();
                                _selectedValue = tagsToList.first;
                              }
                              return Row(
                                children: [
                                DropdownButton(
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
                              ),
                                FloatingActionButton(
                                    onPressed: (){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              content: TextField(
                                                onChanged: (text){
                                                  _newTag = text;
                                                },
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("ADD"),
                                                  onPressed: () {
                                                    if (_newTag.isNotEmpty){
                                                      setState(() {
                                                        tagsToList.add(_newTag);
                                                        _selectedValue = _newTag;
                                                      });
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ]
                                            );
                                          }
                                      );
                                    },
                                  child: const Text("ADD"),
                                  heroTag: "addNewTagButton",
                                ),
                              ]);
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
      ),
      floatingActionButton: FloatingActionButton(
        //VALIDATE:
        //date -> in correct format
        //time -> valid (with or without am/pm)
        //tag -> one word
        onPressed:() async{
          if (currentTime != null && _description != null && _selectedValue != null){
            _timeFrom = "$_timeInHoursFrom:$_timeInMinutesFrom$_amOrPmFrom";
            _timeTo = "$_timeInHoursTo:$_timeInMinutesTo$_amOrPmTo";
            await addRecord(currentTime, _timeFrom, _timeTo, _description, _selectedValue);
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp())
            );
          }
        },
        child: Text("submit"),
        heroTag: "addTaskButton",
      ),
    );
  }
}
