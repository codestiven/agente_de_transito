import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Mapa(),
    );
  }
}

class Mapa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicacion de multas'),
          automaticallyImplyLeading: false,
          centerTitle: true,
      ),
      body: FutureBuilder<List<Marker>>(
        // Obtener datos de Firebase
        future: obtenerMarcadores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return FlutterMap(
              options: MapOptions(
                center: LatLng(0, 0), // Ajusta según tus necesidades
                zoom: 2.0, // Ajusta según tus necesidades
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: snapshot.data ?? []),
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<Marker>> obtenerMarcadores() async {
    var multas = await FirebaseFirestore.instance.collection('multas').get();

    return multas.docs.map((documento) {
      var datos = documento.data();
      double latitud = (datos['latitud'] as num).toDouble();
      double longitud = (datos['longitud'] as num).toDouble();

      return Marker(
        width: 90.0,
        height: 90.0,
        point: LatLng(latitud, longitud),
        child: Column(
          children: [
            Icon(
              Icons.location_on,
              size: 40.0,
              color: Colors.red,
            ),
            Text('${datos['name']} \n${datos['placa']}'),
          ],
        ),
      );
    }).toList();
  }
}
