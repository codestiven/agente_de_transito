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
    } catch (e) {
      print("Error al agregar multa a Firestore: $e");
      print("Error details: ${e.toString()}");
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
    }
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
        title: Text('Flutter + Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo electrónico'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Edad'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _cedulaController,
                decoration: InputDecoration(labelText: 'Cédula del infractor'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _placaController,
                decoration:
                    InputDecoration(labelText: 'Placa del vehículo (opcional)'),
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
                decoration: InputDecoration(labelText: 'Motivo de la multa'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _takePicture,
                child: Text('Tomar Foto'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _recordAudio,
                child: Text('Grabar Audio'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _comentarioController,
                maxLines: null,
                decoration:
                    InputDecoration(labelText: 'Comentario sobre la multa'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _stopRecording,
                child: Text('Detener Grabación'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _latitudController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Latitud'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _longitudController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Longitud'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadMediaAndAddUserToFirestore,
                child: Text('Subir a Firestore'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
