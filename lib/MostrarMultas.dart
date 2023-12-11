import 'package:agente_de_transito/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VerMultas(),
    );
  }
}

class VerMultas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('multas'),
          centerTitle: true,
          automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('multas').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            var multas = snapshot.data?.docs;

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: multas?.length,
              itemBuilder: (context, index) {
                var multa = multas?[index].data() as Map<String, dynamic>;
                return MyExpansionTile(multa);
              },
            );
          },
        ),
      ),
    );
  }
}

class MyExpansionTile extends StatefulWidget {
  final Map<String, dynamic> data;

  MyExpansionTile(this.data);

  @override
  _MyExpansionTileState createState() => _MyExpansionTileState();
}

class _MyExpansionTileState extends State<MyExpansionTile> {
  bool _isExpanded = false;
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green, // Color de fondo verde para el Card
      margin: EdgeInsets.all(8.0),
      child: ExpansionTile(
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        title: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          leading: _buildImageWidget(widget.data['imageUrl']),
          title: Text(widget.data['name'],
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        children: <Widget>[
          ListTile(
            title: Text('Age: ${widget.data['age']}',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          ListTile(
            title: Text('Cedula: ${widget.data['cedula']}',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          ListTile(
            title: Text('Comentario: ${widget.data['comentario']}',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          ListTile(
            title: Text('Email: ${widget.data['email']}',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          ListTile(
            title: Text('Fecha: ${widget.data['fecha'].toDate()}',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          ListTile(
            title: Text('Hora: ${widget.data['hora']}',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          ListTile(
            title: Text('Latitud: ${widget.data['latitud']}',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          ListTile(
            title: Text('Longitud: ${widget.data['longitud']}',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          ListTile(
            title: Text('Motivo: ${widget.data['motivo']}',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          // Puedes agregar más ListTile con otros campos aquí

          // Reproducción de audio
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _playAudio(widget.data['audioUrl']);
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Reproducir Audio',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    try {
      if (imageUrl.isNotEmpty) {
        return CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) {
            print('Error loading image: $error');
            return Image.asset(
              'assets/no.png', // Imagen predeterminada en caso de error
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            );
          },
          width: 50.0,
          height: 50.0,
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          'assets/no.png', // Imagen predeterminada cuando la URL está vacía
          width: 50.0,
          height: 50.0,
          fit: BoxFit.cover,
        );
      }
    } catch (e) {
      print('Error loading image: $e');
      return Image.asset(
        'assets/no.png', // Imagen predeterminada en caso de error
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      );
    }
  }

  Future<void> _playAudio(String audioUrl) async {
    await _audioPlayer.setUrl(audioUrl);
    await _audioPlayer.play();
  }
}
