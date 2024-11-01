import 'package:flutter/material.dart';
import 'queryRecord.dart';
import 'addRecord.dart';
import 'database_functions.dart';



void main() async {
  await initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  late Future<List<dynamic>> allRecords;

  @override
  void initState(){
    super.initState();
    allRecords = getCollection();
  }

  List<TableRow> addToTable(List<dynamic>? data){
    List<TableRow> tableRow = [ const TableRow(children: [
      Padding(padding: EdgeInsets.all(10.0), child:Text('DATE')),
      Padding(padding: EdgeInsets.all(10.0), child:Text('TO')),
      Padding(padding: EdgeInsets.all(10.0), child:Text('FROM')),
      Padding(padding: EdgeInsets.all(10.0), child:Text('DESCRIPTION')),
      Padding(padding: EdgeInsets.all(10.0), child:Text('TAG')),
    ])];

    for (int i=0; i< data!.length; i++){
     tableRow.add(TableRow(children: [
      Padding(padding: EdgeInsets.all(10.0), child:Text('${data[i]["date"]}')),
      Padding(padding: EdgeInsets.all(10.0), child:Text('${data[i]["to"]}')),
      Padding(padding: EdgeInsets.all(10.0), child:Text('${data[i]["from"]}')),
      Padding(padding: EdgeInsets.all(10.0), child:Text('${data[i]["description"]}')),
      Padding(padding: EdgeInsets.all(10.0), child:Text('${data[i]["tag"]}')),
      ]));
    }
    return tableRow;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FutureBuilder<List<dynamic>?>(
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
                    print(snapshot.data);
                    return Expanded(
                      child: Table(
                        children: addToTable(snapshot.data),
                      )
                    );
                  }

                }
                return const Text("no data available");
              }
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          Padding(
          padding: const EdgeInsets.only(left: 20, right:100),
          child:
            FloatingActionButton(
              onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRecord())
                );
              },
              child: const Icon(Icons.add),
              heroTag: "homePageButton",
            ),
          ),
          FloatingActionButton(
              onPressed:(){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QueryRecord())
                );
              },
              child: const Icon(Icons.search)
          )
        ]
      ),
    );
  }
}
