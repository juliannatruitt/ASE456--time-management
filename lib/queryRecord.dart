import 'package:flutter/material.dart';

import 'database_functions.dart';

class QueryRecord extends StatefulWidget {

  @override
  State<QueryRecord> createState(){
    return _QueryRecordState();
  }
}

class _QueryRecordState extends State<QueryRecord> {
  final List<String> queryOption = ['date', 'description', 'tag'];
  late String _selectedValue;
  late String? _valueToFindInDatabase;
  late List<dynamic> results = [];

  @override
  void initState() {
    _selectedValue = queryOption.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Query Task'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
            Row(
                children: [
                  DropdownButton(
                    value: _selectedValue,
                    items: queryOption.map(
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
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Value to find',
                        ),
                        onChanged: (text) {_valueToFindInDatabase=text;}
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: results.isNotEmpty ? ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index){
                      return Text('${results[index]['date']} ${results[index]['from']} ${results[index]['to']} ${results[index]['description']} ${results[index]['tag']}');
                    }
                  ) : const Text("no results found"),
              ),
              ],
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_valueToFindInDatabase != null && _selectedValue != null){
            List<dynamic> resultsReturned = await getFromTheDatabase(_selectedValue, _valueToFindInDatabase!);
            setState(() {
              results = resultsReturned;
            });
            //print(results);
            }
          },
        child: Text("Find"),
        heroTag: "queryTaskButton",
      ),
    );
  }
}
