import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:agente_de_transito/firebase_options.dart';
import 'package:agente_de_transito/pages/tiposmultas.dart';
import 'horoscopo.dart';

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
        primaryColor: Colors.green[700],
        hintColor: Colors.green[300],
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Colors.green[900]),
        ),
      ),
      home: const MyHomePage(),
      routes: {
        '/multas': (context) => TiposMultas(),
        '/horoscopo': (context) => HoroscopeScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text(
          'App de Transito',
          style: TextStyle(
            color: const Color.fromARGB(255, 41, 41, 41),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 10.0,  
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(10), 
        mainAxisSpacing: 10,  
        crossAxisSpacing: 10,  
        children: <Widget>[
          Card(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/horoscopo');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),  
                    child: Icon(Icons.star, size: 50.0),
                  ),
                  const Text('Ver Horoscopo'),
                ],
              ),
            ),
          ),
          Card(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/multas');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),  
                    child: Icon(Icons.money_off, size: 50.0),
                  ),
                  const Text('Ver Multas'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
