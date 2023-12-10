import 'package:agente_de_transito/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home.dart';

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
      title: 'Agente de tránsito',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green[700],
        hintColor: Colors.green[300],
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Colors.green[900],
          ),
        ),
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controladorCorreo = TextEditingController();
  TextEditingController controladorContrasena = TextEditingController();
  bool recordarUsuario = false;
  late Size tamanoPantalla;

  @override
  Widget build(BuildContext context) {
    tamanoPantalla = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
          image: const AssetImage("assets/bg.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Theme.of(context).primaryColor.withOpacity(0.2),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(top: 80, child: _construirEncabezado()),
            Positioned(bottom: 0, child: _construirCuerpo()),
          ],
        ),
      ),
    );
  }

  Widget _construirEncabezado() {
    return SizedBox(
      width: tamanoPantalla.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/Logo-DIGESETT .png',
            height: 140,
          ),
          Text(
            "Agente de tránsito",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirCuerpo() {
    return SizedBox(
      width: tamanoPantalla.width,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _construirFormulario(),
        ),
      ),
    );
  }

  Widget _construirFormulario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bienvenido",
          style: TextStyle(
            color: Colors.green[700],
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        _construirTextoGris("Favor inicia sesión con sus datos de Agente"),
        const SizedBox(height: 60),
        _construirTextoGris("Dirección de correo electrónico"),
        _construirCampoEntrada(controladorCorreo),
        const SizedBox(height: 40),
        _construirTextoGris("Contraseña"),
        _construirCampoEntrada(controladorContrasena, esContrasena: true),
        const SizedBox(height: 20),
        _construirRecordarOlvidar(),
        const SizedBox(height: 20),
        _construirBotonIniciarSesion(),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _construirTextoGris(String texto) {
    return Text(
      texto,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _construirCampoEntrada(TextEditingController controlador,
      {esContrasena = false}) {
    return TextField(
      controller: controlador,
      decoration: InputDecoration(
        suffixIcon: esContrasena ? Icon(Icons.key) : Icon(Icons.email),
      ),
      obscureText: esContrasena,
    );
  }

  Widget _construirRecordarOlvidar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: recordarUsuario,
              onChanged: (valor) {
                setState(() {
                  recordarUsuario = valor!;
                });
              },
            ),
            _construirTextoGris("Recordarme"),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: _construirTextoGris("Olvidé mi contraseña"),
        ),
      ],
    );
  }

  Widget _construirBotonIniciarSesion() {
    return ElevatedButton(
      onPressed: () {
        if (controladorCorreo.text == 'amadis' &&
            controladorContrasena.text == '123') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else {
          _mostrarAlertaCredencialesIncorrectas();
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: Colors.green[700],
        minimumSize: const Size.fromHeight(60),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      child: const Text("INICIAR SESIÓN"),
    );
  }

  void _mostrarAlertaCredencialesIncorrectas() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Credenciales incorrectas'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'El correo o la contraseña ingresados no son los correctos'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
