import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:agente_de_transito/firebase_options.dart';
import 'package:agente_de_transito/pages/tiposmultas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green[700], // Usar un tono más oscuro de verde
        hintColor: Colors.green[300], // Usar un tono más claro de verde
        textTheme: TextTheme(
          bodyMedium: TextStyle(
              color: Colors.green[900]), // Usar un color de texto oscuro
        ),
        // Agregar cualquier otra configuración de tema que desees
      ),
      home: const TiposMultas(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text('Prueba'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}