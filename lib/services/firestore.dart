import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  //get collection from tiposmultas
  final CollectionReference notes = FirebaseFirestore.instance.collection('tiposmultas');

  //read tiposmultas
  Stream<QuerySnapshot> getMultasStream() {
    final multasStream = notes.snapshots();
    return multasStream;
  }
}