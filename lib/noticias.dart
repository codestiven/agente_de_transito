import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(Noticia());
}

class Noticia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remolacha',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Noticias'),
        ),
        body: WebView(
          initialUrl: 'https://remolacha.net/tag/digesett/',
        ),
      ),
    );
  }
}
