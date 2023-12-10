import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green[700],
        hintColor: Colors.green[300],
        appBarTheme: AppBarTheme(
          color: Colors.green[900],
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Consulta de Conductor por Licencia'),
        ),
        body: DriverDetailsScreen(),
      ),
    );
  }
}

class DriverDetailsScreen extends StatefulWidget {
  @override
  _DriverDetailsScreenState createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  final TextEditingController _licenciaController = TextEditingController();
  String _nombre = '';
  String _apellido = '';
  String _fechaNacimiento = '';
  String _direccion = '';
  String _telefono = '';
  String _fotoAssetPath = 'perfil.jpg';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _licenciaController,
              decoration: InputDecoration(
                labelText: 'Ingrese la licencia del conductor',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String licencia = _licenciaController.text.trim();
                if (licencia.isNotEmpty) {
                  await consultarConductor(licencia);
                } else {
                  mostrarMensajeError(
                    'Por favor, ingrese la licencia del conductor.',
                  );
                }
              },
              child: Text('Consultar'),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          _fotoAssetPath,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nombre: $_nombre $_apellido'),
                          Text('Fecha de Nacimiento: $_fechaNacimiento'),
                          Text('Dirección: $_direccion'),
                          Text('Teléfono: $_telefono'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> consultarConductor(String licencia) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('conductores')
          .where('licencia', isEqualTo: licencia)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var conductorDetails = querySnapshot.docs.first.data();
        setState(() {
          _nombre = conductorDetails['nombre'];
          _apellido = conductorDetails['apellido'];
          _fechaNacimiento = conductorDetails['fecha de nacimiento'];
          _direccion = conductorDetails['direccion'];
          _telefono = conductorDetails['telefono'];
          _fotoAssetPath = conductorDetails['foto'] ?? 'assets/jack.jpg';
        });
      } else {
        mostrarMensajeError(
          'No se encontraron detalles para la licencia ingresada.',
        );
        limpiarDatosPantalla();
      }
    } catch (e) {
      mostrarMensajeError('Error al consultar el conductor: $e');
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
                limpiarDatosPantalla();
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
      _nombre = '';
      _apellido = '';
      _fechaNacimiento = '';
      _direccion = '';
      _telefono = '';
      _fotoAssetPath = 'perfil.jpg';
    });
  }
}
