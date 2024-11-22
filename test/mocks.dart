import 'package:mockito/annotations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@GenerateMocks([FirebaseFirestore, CollectionReference, QuerySnapshot, QueryDocumentSnapshot])
void main() {}