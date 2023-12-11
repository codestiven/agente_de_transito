import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerMultas extends StatefulWidget {
  @override
  _VerMultasState createState() => _VerMultasState();
}

class _VerMultasState extends State<VerMultas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multas Registradas'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('multas').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              Map<String, dynamic> multaData = document.data() as Map<String, dynamic>;

              return ListTile(
                title: Text('Nombre: ${multaData['name']}'),
                subtitle: Text('Motivo: ${multaData['motivo']}'),
                onTap: () {
                  
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
