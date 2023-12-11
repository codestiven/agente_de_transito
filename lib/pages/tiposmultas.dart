import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agente_de_transito/services/firestore.dart';

class TiposMultas extends StatefulWidget {
  const TiposMultas({Key? key}) : super(key: key);

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
          title: Center(
            child: Text(
              'Detalles de la multa',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildDetailRow('Nombre', data['nombre']),
              _buildDetailRow('Articulo', data['articulo']),
              _buildDetailRow('Multa', data['multa']),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cerrar',
                style: TextStyle(
                  color: Theme.of(context)
                      .primaryColor, 
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Multas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Image.network(
            'https://img.lovepik.com/background/20211101/medium/lovepik-warnings-are-in-line-with-cell-phone-wallpaper-background-image_400663865.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              image: DecorationImage(
                image: NetworkImage(
                  'https://img.lovepik.com/background/20211101/medium/lovepik-warnings-are-in-line-with-cell-phone-wallpaper-background-image_400663865.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor.withOpacity(0.9),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
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
                      ),
                      color: Theme.of(context).primaryColor, 
                      child: ListTile(
                        title: Text(
                          multasText,
                          style: TextStyle(
                            color: Colors.white, 
                          ),
                        ),
                        trailing: Icon(
                           Icons
                              .warning, 
                          color: Colors.white, 
                        ),
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
        ],
      ),
    );
  }
}
