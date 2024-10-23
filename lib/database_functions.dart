import 'dart:collection';

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
  List<dynamic> results =  snapshot.docs.map((doc) => doc.data()).toList();

  for(int i=0; i< results.length; i++){
    DateTime date = results[i]['date'].toDate();
    results[i]['date'] = DateFormat('MM-dd-yyyy').format(date);
  }
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

//needs to handle when a description is put in, to not match it exactly but match for words.
//need conversion for the dates
Future<List<dynamic>> getFromTheDatabase(String attribute, String searchingForValue) async{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference collection = firestore.collection('records');
  late List valuesFromDatabase = [];

  QuerySnapshot snapshot = await collection.get();
  List<dynamic> result =  snapshot.docs.map((doc) => doc.data()).toList();

  for (var i=0; i<result.length; i++){
    if (result[i].length == 5){
      if (result[i][attribute] == searchingForValue){
        valuesFromDatabase.add(result[i]);
      }
    }
  }
  return valuesFromDatabase;
}
