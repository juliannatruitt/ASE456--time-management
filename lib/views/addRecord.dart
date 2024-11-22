import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/database_functions.dart';
import '../main.dart';


class AddRecord extends StatefulWidget {

  @override
  State<AddRecord> createState(){
    return _AddRecordState();
  }
}

class _AddRecordState extends State<AddRecord> {
  late String _selectedValue;
  String _timeInHoursFrom='12';
  String _timeInMinutesFrom='00';
  String _amOrPmFrom='PM';
  String _timeInHoursTo='1';
  String _timeInMinutesTo='00';
  String _amOrPmTo='PM';
  DateTime? _selectedDate;
  late Future<Set<dynamic>> allTags;
  List<dynamic> tagsToList =[];
  String? _timeFrom;
  String? _timeTo;
  String? _description;
  late String _newTag;

  @override
  void initState() {
    super.initState();
    allTags = getAllTags();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2029),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor),
                      onPressed: _presentDatePicker,
                      child:_selectedDate == null ? const Text(
                          'Choose Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                        ),
                      ) : Text(
                        _selectedDate.toString().substring(0,10),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Start Time:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Padding(padding: EdgeInsets.only(right:10)),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'End Time:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Padding(padding: EdgeInsets.only(right:10)),
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
                      padding: const EdgeInsets.only(top:8.0,bottom:8.0, left:50.0, right:50.0),
                      child: TextField(
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),   // bordered outline
                          labelText: 'Task Description',
                        ),
                          onChanged: (text) {_description=text;}
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Tag:',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                const Padding(padding: EdgeInsets.only(right:10)),
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
                                Padding(
                                  padding: const EdgeInsets.only(left:10),
                                  child:SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: FloatingActionButton(
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
                                                      child: const Text("Cancel"),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text("Add Tag"),
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
                                      heroTag: "addNewTagButton",
                                      child: const Icon(Icons.add),
                                    ),
                                  )
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
      floatingActionButton: FloatingActionButton(
        onPressed:() async{
          if (_selectedDate != null && _description != null && _selectedValue != null){
            _timeFrom = "$_timeInHoursFrom:$_timeInMinutesFrom$_amOrPmFrom";
            _timeTo = "$_timeInHoursTo:$_timeInMinutesTo$_amOrPmTo";
            await addRecord({'date':_selectedDate, 'from':_timeFrom, 'to':_timeTo, 'description':_description, 'tag':_selectedValue});
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp())
            );
          }
          else{
            showDialog(
              context: context,
              builder: (BuildContext context){
              return AlertDialog(
                title:  const Text('Error'),
                content:  const Text('Please Fill Out All Fields'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              );
            }
            );
          }
        },
        heroTag: "addTaskButton",
        child: const Text("submit"),
      ),
    );
  }
}
