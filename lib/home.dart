// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables

import 'package:agente_de_transito/aplicar_multa.dart';
import 'package:agente_de_transito/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green[700],
        hintColor: Color(0xFFFF8C00),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Colors.green[900],
          ),
        ),
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return Inicio();
      case 1:
        return ConsultaVehiculo();
      case 2:
        return TarifarioMultas();
      case 3:
        return ConsultaLicencia();
      case 4:
        return Aplicar_multa();
      case 5:
        return MultasRegistradas();
      case 6:
        return Mapamultas();
      case 7:
        return Noticias();
      case 8:
        return Estadoclima();
      case 9:
        return Horoscopo();
      default:
        return Inicio();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agente del Orden",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Datos aun no agregados"),
              accountEmail: Text("cositas@appmaking.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://i.ytimg.com/vi/2UpHsfoOZYc/maxresdefault.jpg",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Inicio"),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.time_to_leave),
              title: Text("Consulta de vehículo por placa"),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.document_scanner),
              title: Text("Tarifario de multas"),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text("Consulta de conductor por licencia"),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save),
              title: Text("Aplicar Multa"),
              onTap: () {
                _onItemTapped(4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.download),
              title: Text("Multas registradas"),
              onTap: () {
                _onItemTapped(5);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text("Mapa de multas"),
              onTap: () {
                _onItemTapped(6);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.newspaper),
              title: Text("Noticias"),
              onTap: () {
                _onItemTapped(7);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.cloud),
              title: Text("Estado del clima"),
              onTap: () {
                _onItemTapped(8);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("horoscopo"),
              onTap: () {
                _onItemTapped(9);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: ClipRect(
          child: _getScreenForIndex(_selectedIndex),
        ),
      ),
    );
  }
}

class Inicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1541945503710-82ad4425a126?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZWRpZmljaW8lMjBkZSUyMGxhJTIwY2l1ZGFkJTIwNGslMjBmb25kbyUyMGRlJTIwcGFudGFsbGF8ZW58MHx8MHx8fDA%3D",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withOpacity(0.4),
              borderRadius: BorderRadius.zero,
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Logo-DIGESETT .png',
                  width: 150,
                ),
                SizedBox(height: 20),
                Text(
                  "Dirección Nacional de Tránsito y Transporte Terrestre",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class ConsultaVehiculo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Contenido de la página 'Acerca de'"),
      ),
    );
  }
}

class ConsultaLicencia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
      ),
      body: Center(
        child: Text("Contenido de la página de productos"),
      ),
    );
  }
}

class AplicarMulta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Contenido de la página de contacto"),
      ),
    );
  }
}

class MultasRegistradas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Contenido de la opción 5"),
      ),
    );
  }
}

class Mapamultas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Contenido de la opción 6"),
      ),
    );
  }
}

class Noticias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Contenido de la opción 7"),
      ),
    );
  }
}

class Estadoclima extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Contenido de la opción 8"),
      ),
    );
  }
}

class Horoscopo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Contenido de la opción 9"),
      ),
    );
  }
}

class TarifarioMultas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Contenido de la opción 10"),
      ),
    );
  }
}
