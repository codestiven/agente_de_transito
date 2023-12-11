import 'dart:io';
import 'package:agente_de_transito/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:another_flushbar/flushbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class AudioRecorder {
  bool isRecording = false;
  late String audioPath;

  Future<String?> start() async {
    Record _record = Record();

    if (await _record.hasPermission()) {
      final Directory appDocDirectory =
          await getApplicationDocumentsDirectory();
      audioPath = '${appDocDirectory.path}/audio_file.aac';

      await _record.start(
        path: audioPath,
        encoder: AudioEncoder.aacHe,
      );

      isRecording = true;
      return audioPath;
    } else {
      return null;
    }
  }

  Future<void> stop() async {
    Record _record = Record();
    await _record.stop();
    isRecording = false;
  }

  String getRecordedAudioPath() {
    return audioPath;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Aplicar_multa(),
    );
  }
}

class Aplicar_multa extends StatefulWidget {
  @override
  _Aplicar_multaState createState() => _Aplicar_multaState();
}

class _Aplicar_multaState extends State<Aplicar_multa> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _motivoController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _latitudController = TextEditingController();
  final TextEditingController _longitudController = TextEditingController();

  File? _image;
  String? _audioPath;
  AudioRecorder _audioRecorder = AudioRecorder();
  String? _placa;
  String? _motivoSeleccionado;
  late DateTime _fechaActual;
  late TimeOfDay _horaActual;
  double? _latitud;
  double? _longitud;

  Future<void> addUserAndMediaToFirestore(
      String imageUrl, String audioUrl) async {
    try {
      CollectionReference multas =
          FirebaseFirestore.instance.collection('multas');
      int horaEnMinutos = _horaActual.hour * 60 + _horaActual.minute;
      await multas.add({
        'name': _nameController.text,
        'email': _emailController.text,
        'age': _ageController.text,
        'cedula': _cedulaController.text,
        'placa': _placaController.text ?? '',
        'motivo': _motivoSeleccionado ?? '',
        'comentario': _comentarioController.text,
        'latitud': double.tryParse(_latitudController.text) ?? 0.0,
        'longitud': double.tryParse(_longitudController.text) ?? 0.0,
        'fecha': _fechaActual,
        'hora': horaEnMinutos,
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
      });

      print('Multa agregada con éxito.');
      showSuccessAlert();
    } catch (e) {
      print("Error al agregar multa a Firestore: $e");
      print("Error details: ${e.toString()}");
      showErrorAlert();
    }
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _recordAudio() async {
    if (!_audioRecorder.isRecording) {
      final audioPath = await _audioRecorder.start();
      print('Grabando...');
      await Future.delayed(Duration(seconds: 5));
      print('Grabación completada.');
      setState(() {
        _audioPath = audioPath;
      });
    }
  }

  Future<void> _stopRecording() async {
    if (_audioRecorder.isRecording) {
      await _audioRecorder.stop();
      print('Grabación detenida.');
      setState(() {
        _audioPath = _audioRecorder.getRecordedAudioPath();
      });
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      UploadTask uploadTask = storageRef.putFile(imageFile);

      await uploadTask.whenComplete(() => print('Imagen subida con éxito.'));

      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error al subir la imagen: $e");
      return '';
    }
  }

  Future<String> _uploadAudio(String audioPath) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref('audio/${DateTime.now().millisecondsSinceEpoch}.aac');

      List<int> audioBytes = await File(audioPath).readAsBytes();
      Uint8List uint8List = Uint8List.fromList(audioBytes);

      UploadTask uploadTask = storageRef.putData(uint8List);

      await uploadTask.whenComplete(() => print('Audio subido con éxito.'));

      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error al subir el audio: $e");
      return '';
    }
  }

  Future<void> _uploadMediaAndAddUserToFirestore() async {
    try {
      String imageUrl = '';
      String audioUrl = '';

      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
      }

      if (_audioPath != null && _audioPath!.isNotEmpty) {
        audioUrl = await _uploadAudio(_audioPath!);
      }

      await addUserAndMediaToFirestore(imageUrl, audioUrl);
    } catch (e) {
      print("Error al subir medios y agregar usuario a Firestore: $e");
      showErrorAlert();
    }
  }

  void showSuccessAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Éxito"),
          content: Text("Multa subida con éxito."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  late Flushbar
      _flushbar;

void _showRecordingSnackBar() {
    _flushbar = Flushbar(
      message: 'Grabando',
      duration: Duration(days: 1),
      icon: Icon(
        Icons.mic,
        size: 36, 
        color: Colors.white,
      ),
      backgroundColor: Colors.blue, 
 
      margin: EdgeInsets.all(0), // Sin márgenes
      padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16), 
      flushbarPosition:
          FlushbarPosition.TOP, 
      flushbarStyle: FlushbarStyle.FLOATING, 
      forwardAnimationCurve:
          Curves.easeInOutBack, 
      reverseAnimationCurve:
          Curves.easeInOutBack, 
    )..show(context);
  }


  void _hideRecordingSnackBar() {
    if (_flushbar != null) {
      _flushbar.dismiss();
    }
  }

  // void _showRecordingSnackBar() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Grabando'),
  //       duration: Duration(
  //           days: 1), // Duración larga para que no desaparezca automáticamente
  //     ),
  //   );
  // }

  // void _hideRecordingSnackBar() {
  //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
  // }

  void showErrorAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Hubo un error al subir la multa."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fechaActual = DateTime.now();
    _horaActual = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingrese datos de multa'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          image: DecorationImage(
            image: const AssetImage("assets/a.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Theme.of(context).primaryColor.withOpacity(0.2),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _ageController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Edad',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _cedulaController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Cédula del infractor',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _placaController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Placa del vehículo (opcional)',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _motivoSeleccionado,
                  items: [
                    DropdownMenuItem(
                      child: Text('Exceso de velocidad'),
                      value: 'Exceso de velocidad',
                    ),
                    DropdownMenuItem(
                      child: Text('Estacionamiento indebido'),
                      value: 'Estacionamiento indebido',
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _motivoSeleccionado = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Motivo de la multa',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: _takePicture,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.blue, // Color del fondo del botón
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white, // Color del icono
                        ),
                        SizedBox(
                            width: 8.0), // Espacio entre el icono y el texto
                        Text(
                          'Tomar Foto',
                          style: TextStyle(
                            color: Colors.white, // Color del texto
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
             Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _recordAudio();
                          _showRecordingSnackBar();
                        },
                        style: ElevatedButton.styleFrom(

                            ),
                        child: Text(
                          'Grabar Audio',
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _stopRecording();
                          _hideRecordingSnackBar();
                        },
                        style: ElevatedButton.styleFrom(

                            ),
                        child: Text(
                          'Detener Grabación',
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _comentarioController,
                  style: TextStyle(color: Colors.black),
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Comentario sobre la multa',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _latitudController,
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Latitud',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _longitudController,
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Longitud',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: _uploadMediaAndAddUserToFirestore,
                  child: Container(
                    width: double
                        .infinity, // Hace que el botón ocupe todo el ancho disponible
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .primaryColor, // Color del fondo del botón
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload,
                          color: Colors.white, // Color del icono
                        ),
                        SizedBox(
                            width: 8.0), // Espacio entre el icono y el texto
                        Text(
                          'Subir a Firestore',
                          style: TextStyle(
                            color: Colors.white, // Color del texto
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
