import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';


Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> addRecord(var date, var from, var to, var description, var tag) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    await firestore.collection('records').add({
      'date': date,
      'from': from,
      'to': to,
      'description': description,
      'tag': tag
    });
    print("recorded task");
  }
  catch (e){
    print ('ERROR adding task');
  }
}

Future<List<dynamic>> getCollection() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference collection = firestore.collection('records');

  QuerySnapshot snapshot = await collection.get();
  List<dynamic> results =  snapshot.docs.map((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return data;
  }).toList();

  results.sort((a, b) {
    DateTime dateA = a['date'].toDate();
    DateTime dateB = b['date'].toDate();
    return dateB.compareTo(dateA);
  });

  for(int i=0; i< results.length; i++){
    DateTime date = results[i]['date'].toDate();
    results[i]['date'] = DateFormat('yyyy/MM/dd').format(date);
  }
  print(results);
  return results;
}

Future<Set<dynamic>> getTags() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference collection = firestore.collection('records');
  late Set uniqueTags ={};

  QuerySnapshot snapshot = await collection.get();
  List<dynamic> result =  snapshot.docs.map((doc) => doc.data()).toList();
  for (var i=0; i<result.length; i++){
    if (result[i].length == 5){
      uniqueTags.add(result[i]['tag']);
    }
  }
  return uniqueTags;
}

Future<List<dynamic>> getFromTheDatabase(String attribute, String searchingForValue) async{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference collection = firestore.collection('records');
  late List valuesFromDatabase = [];

  QuerySnapshot snapshot = await collection.get();
  List<dynamic> result =  snapshot.docs.map((doc) => doc.data()).toList();

  void queryDate(){
    for (var i = 0; i < result.length; i++) {
      if (result[i].length == 5) {
        String year='';
        String month='';
        String day='';
        List<String> splitDate;
        if (searchingForValue.toLowerCase() == "today"){
          DateTime today = DateTime.now();
          String formatTodayDate = DateFormat('yyyy/MM/dd').format(today);

          splitDate = formatTodayDate.split("/");
          year = splitDate[0];
          month = splitDate[1];
          day = splitDate[2];
        }
        else {
          splitDate = searchingForValue.split("/");
          if (splitDate.length == 3) {
            year = splitDate[0];
            month = splitDate[1];
            day = splitDate[2];
          }
        }

        DateTime date = result[i]['date'].toDate();
        String formatDate = DateFormat('yyyy/MM/dd').format(date);

        List<String> splitDateFromDatabase = formatDate.split("/");
        String yearDatabase = splitDateFromDatabase[0];
        String monthDatabse = splitDateFromDatabase[1];
        String dayDatabase = splitDateFromDatabase[2];

        if (year == yearDatabase && month == monthDatabse &&
            day == dayDatabase) {
          valuesFromDatabase.add(result[i]);
        }
      }
    }
  }
  void queryDescription(){
    for (var i = 0; i < result.length; i++) {
      if (result[i].length == 5) {
        if (result[i][attribute].contains(searchingForValue)) {
          valuesFromDatabase.add(result[i]);
        }
      }
    }
  }
  void queryTag(){
    for (var i = 0; i < result.length; i++) {
      if (result[i].length == 5) {
        if (result[i][attribute] == searchingForValue) {
          valuesFromDatabase.add(result[i]);
        }
      }
    }
  }
  if(attribute == "date") {
    queryDate();
  }
  else if (attribute == "description"){
    queryDescription();
  }
  else {
    queryTag();
  }
  return valuesFromDatabase;
}

Future<List<dynamic>> reportDates(DateTime startDate, DateTime endDate) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference collection = firestore.collection('records');


  QuerySnapshot snapshot = await collection.get();
  List<dynamic> resultsFromDatabase =  snapshot.docs.map((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return data;
  }).toList();
  List<dynamic> modifedResults=[];

  if (startDate.isAfter(endDate)){
    return [];
  }

  DateTime adjustedStartDate = startDate.subtract(const Duration(days: 1));
  DateTime adjustedEndDate = endDate.add(const Duration(days: 1));

  for(int i=0; i< resultsFromDatabase.length; i++){
    DateTime dateFromDatabase = resultsFromDatabase[i]['date'].toDate();
    if (dateFromDatabase.isAfter(adjustedStartDate) && dateFromDatabase.isBefore(adjustedEndDate)){
      modifedResults.add(resultsFromDatabase[i]);
    }
  }

  modifedResults.sort((a, b) {
    DateTime dateA = a['date'].toDate();
    DateTime dateB = b['date'].toDate();
    return dateB.compareTo(dateA);
  });

  for(int i=0; i< modifedResults.length; i++){
    DateTime date = modifedResults[i]['date'].toDate();
    modifedResults[i]['date'] = DateFormat('yyyy/MM/dd').format(date);
  }
  return modifedResults;
}

Future<List<dynamic>> priority() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference collection = firestore.collection('records');

  QuerySnapshot snapshot = await collection.get();
  List<dynamic> results =  snapshot.docs.map((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return data;
  }).toList();


  results.sort((a, b) {
    DateFormat format = DateFormat("h:mma");

    DateTime startTimeA = format.parse(a['from'].toUpperCase());
    DateTime endTimeA = format.parse(a['to'].toUpperCase());

    DateTime startTimeB = format.parse(b['from'].toUpperCase());
    DateTime endTimeB = format.parse(b['to'].toUpperCase());

    Duration differenceA = endTimeA.difference(startTimeA);
    Duration differenceB = endTimeB.difference(startTimeB);

    return differenceB.compareTo(differenceA);
  });

  for(int i=0; i< results.length; i++){
    DateTime date = results[i]['date'].toDate();
    results[i]['date'] = DateFormat('yyyy/MM/dd').format(date);
  }
  return results;
}

Future<void> deleteTask(String id) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference collection = firestore.collection('records');
  return collection
      .doc(id)
      .delete()
      .then((value) => print("User Deleted"))
      .catchError((error) => print("Failed to delete user: $error"));
}
