import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agente_de_transito/services/firestore.dart';

class TiposMultas extends StatefulWidget {
  const TiposMultas({super.key});

  @override
  State<TiposMultas> createState() => _TiposMultasState();
}

class _TiposMultasState extends State<TiposMultas> {
 final FirestoreService firestoreService = FirestoreService();

 void _showDetailsDialog(Map<String, dynamic> data) {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: const Text('Detalles de la multa'),
         content: SingleChildScrollView(
           child: ListBody(
             children: <Widget>[
               Text('Nombre: ${data['nombre']}'),
               Text('Articulo: ${data['articulo']}'),
               Text('Multa: ${data['multa']}'),
             ],
           ),
         ),
         actions: <Widget>[
           FilledButton(
             onPressed: () {
               Navigator.of(context).pop();
             },
             child: const Text('Cerrar'),
           ),
         ],
       );
     },
   );
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
           title: Text('Multas', 
        style: TextStyle(
          fontWeight: FontWeight.bold,)
          ), 
        backgroundColor: Colors.green,
     ),
     body: StreamBuilder<QuerySnapshot>(
       stream: firestoreService.getMultasStream(),
       builder: (context, snapshot) {
         if (snapshot.hasData) {
           List multasList = snapshot.data!.docs;

           return ListView.builder(
             padding: const EdgeInsets.all(8),
             itemCount: multasList.length,
             itemBuilder: (context, index) {
               DocumentSnapshot document = multasList[index];

               Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
               String multasText = data['nombre'];

               return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), 
                  side: BorderSide(color: Colors.black),
                ),
                child: ListTile(
                  title: Text(multasText),
                  onTap: () {
                    _showDetailsDialog(data);
                  },
                ),
               );
             },
           );
         } else {
           return const Center(child: Text('No hay multas'));
         }
       },
     ),
   );
 }
}