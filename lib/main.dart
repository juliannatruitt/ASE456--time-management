import 'package:flutter/material.dart';
import 'addRecord.dart';
import 'database_functions.dart';



void main() async {
  await initializeApp();
  var tags = await getTags();
  print(tags);
  //await addRecord('9', '5', 'studyihg', 'study');
  //var testing = await getCollection();
  //print(testing?[0].length);
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index){
                          if (snapshot.data![index].length == 4){
                            return Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('${snapshot.data![index]['from']} ${snapshot.data![index]['to']} ${snapshot.data![index]['description']} ${snapshot.data![index]['tag']}'),
                            );
                          }
                          return const Text("none");
                        },
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
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecord())
          );
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
