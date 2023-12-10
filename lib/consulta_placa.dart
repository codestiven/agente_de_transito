import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Consulta de Vehículo por Placa'),
          backgroundColor: Colors.green[700],
        ),
        body: VehicleDetailsScreen(),
      ),
    );
  }
}

class VehicleDetailsScreen extends StatefulWidget {
  @override
  _VehicleDetailsScreenState createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final TextEditingController _placaController = TextEditingController();
  String _marca = '';
  String _color = '';
  String _tipo = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _placaController,
            decoration: InputDecoration(
              labelText: 'Ingrese la placa del vehículo',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 1.0),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              String placa = _placaController.text.trim();
              if (placa.isNotEmpty) {
                await consultarVehiculo(placa);
              } else {
                mostrarMensajeError(
                    'Por favor, ingrese la placa del vehículo.');
              }
            },
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 74, 161, 79),
            ),
            child: Text('Consultar'),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.green[100],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Marca: $_marca',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Color: $_color',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tipo: $_tipo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> consultarVehiculo(String placa) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('vehiculos')
          .where('placa', isEqualTo: placa)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var vehicleDetails = querySnapshot.docs.first.data();
        setState(() {
          _marca = vehicleDetails['marca'];
          _color = vehicleDetails['color'];
          _tipo = vehicleDetails['tipo'];
        });
      } else {
        mostrarMensajeError(
            'No se encontraron detalles para la placa ingresada.');
        limpiarDatosPantalla(); // Limpia los datos en caso de error
      }
    } catch (e) {
      mostrarMensajeError('Error al consultar el vehículo: $e');
    }
  }

  void mostrarMensajeError(String mensaje) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                limpiarDatosPantalla(); // Limpia los datos cuando se cierra el diálogo de error
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void limpiarDatosPantalla() {
    setState(() {
      _marca = '';
      _color = '';
      _tipo = '';
    });
  }
}
