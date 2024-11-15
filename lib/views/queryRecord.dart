import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../util/database_functions.dart';

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
        title: const Text('Query Task'),
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
                  const SizedBox(width: 20),
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
                      DateTime date = results[index]['date'].toDate();
                      results[index]['date'] = DateFormat('yyyy/MM/dd').format(date);
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 30,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                          radius: 40,
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: FittedBox(
                              child: Text('${results[index]['tag']}', style:Theme.of(context).textTheme.titleSmall,),
                            ),
                          ),
                          ),
                          title: Text(
                            "${results[index]['date']}\n${results[index]['from']}-${results[index]['to']}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            "${results[index]['description']}",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      );
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
        heroTag: "queryTaskButton",
        child: const Text("Find"),
      ),
    );
  }
}
