import 'dart:math';
import 'package:flutter/material.dart';

class HoroscopeScreen extends StatefulWidget {
 @override
 _HoroscopeScreenState createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> zodiacSigns = [
      "Aries",
      "Tauro",
      "Géminis",
      "Cáncer",
      "Leo",
      "Virgo",
      "Libra",
      "Escorpio",
      "Sagitario",
      "Capricornio",
      "Acuario",
      "Piscis"
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Horóscopo de hoy', 
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,),
          ), 
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: zodiacSigns.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),  
                side: BorderSide(color: Colors.black),
              ),
              child: ListTile(
                leading: Icon(Icons.star),  
                title: Text(
                  zodiacSigns[index],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  getHoroscopeMessage(zodiacSigns[index], DateTime.now()),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(zodiacSigns[index]),
                        content: Text(getHoroscopeMessage(zodiacSigns[index], DateTime.now())),
                        actions: [
                          TextButton(
                            child: Text('Cerrar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

String getHoroscopeMessage(String zodiacSign, DateTime date) {
 Map<String, Map<int, List<String>>> horoscopeMessages = {

"Aries": {
    DateTime.monday: ["Aries, este lunes es un día para ser valiente y tomar la iniciativa.", "Aries, este lunes es un buen día para comenzar nuevos proyectos."],
    DateTime.tuesday: ["Aries, el martes es un día para ser audaz y enfrentar tus miedos.", "Aries, este martes es un buen día para desafiar tus límites."],
    DateTime.wednesday: ["Aries, este miércoles es un día para ser activo y energético.", "Aries, este miércoles es un buen día para ejercitarte y mantenerte en forma."],
    DateTime.thursday: ["Aries, este jueves es un día para ser directo y honesto.", "Aries, este jueves es un buen día para hablar de tus sentimientos."],
    DateTime.friday: ["Aries, este viernes es un día para ser aventurero y probar algo nuevo.", "Aries, este viernes es un buen día para explorar y viajar."],
    DateTime.saturday: ["Aries, este sábado es un día para ser competitivo y jugar para ganar.", "Aries, este sábado es un buen día para participar en juegos y competencias."],
    DateTime.sunday: ["Aries, este domingo es un día para ser enérgico y apasionado.", "Aries, este domingo es un buen día para expresar tu amor y pasión."],
  },
  "Tauro": {
    DateTime.monday: ["Tauro, este lunes es un día para ser paciente y persistente.", "Tauro, este lunes es un buen día para trabajar duro y ser productivo."],
    DateTime.tuesday: ["Tauro, el martes es un día para ser confiable y leal.", "Tauro, este martes es un buen día para mostrar tu lealtad a tus seres queridos."],
    DateTime.wednesday: ["Tauro, este miércoles es un día para ser práctico y realista.", "Tauro, este miércoles es un buen día para planificar y organizar tus tareas."],
    DateTime.thursday: ["Tauro, este jueves es un día para ser generoso y dar a los demás.", "Tauro, este jueves es un buen día para compartir tus recursos con quienes lo necesitan."],
    DateTime.friday: ["Tauro, este viernes es un día para ser estable y constante.", "Tauro, este viernes es un buen día para mantener la calma y evitar los cambios drásticos."],
    DateTime.saturday: ["Tauro, este sábado es un día para ser sensual y disfrutar de los placeres de la vida.", "Tauro, este sábado es un buen día para disfrutar de una buena comida o un masaje relajante."],
    DateTime.sunday: ["Tauro, este domingo es un día para ser terco y defender tus creencias.", "Tauro, este domingo es un buen día para demostrar tu fuerza y resistencia."],
  },
    "Capricornio": {
      DateTime.monday: ["Capricornio, este lunes es de progreso y logros.", "Capricornio, este lunes es un buen día para iniciar nuevos proyectos."],
      DateTime.tuesday: ["Capricornio, el martes es un día para concentrarte en tus relaciones.", "Capricornio, este martes es un buen día para resolver conflictos."],
      DateTime.wednesday: ["Capricornio, este miércoles es un día para descansar y recargar energías.", "Capricornio, este miércoles es un buen día para practicar la autocompasión."],
      DateTime.thursday: ["Capricornio, este jueves es un día para aprender algo nuevo.", "Capricornio, este jueves es un buen día para ampliar tus horizontes."],
      DateTime.friday: ["Capricornio, este viernes es un buen día para relajarte.", "Capricornio, este viernes es un buen día para disfrutar de la vida."],
      DateTime.saturday: ["Capricornio, este sábado puede ser un día desafiante.", "Capricornio, este sábado es un buen día para enfrentar tus miedos."],
      DateTime.sunday: ["Capricornio, este domingo es un día para pasar con la familia.", "Capricornio, este domingo es un buen día para reflexionar sobre la semana pasada."],
    },
      "Géminis": {
    DateTime.monday: ["Géminis, este lunes es un día para ser adaptable y flexible.", "Géminis, este lunes es un buen día para aprender algo nuevo."],
    DateTime.tuesday: ["Géminis, el martes es un día para ser comunicativo y social.", "Géminis, este martes es un buen día para hacer amigos y socializar."],
    DateTime.wednesday: ["Géminis, este miércoles es un día para ser curioso e inquisitivo.", "Géminis, este miércoles es un buen día para leer un libro o investigar un tema de interés."],
    DateTime.thursday: ["Géminis, este jueves es un día para ser ingenioso y creativo.", "Géminis, este jueves es un buen día para resolver problemas y encontrar soluciones innovadoras."],
    DateTime.friday: ["Géminis, este viernes es un día para ser alegre y divertido.", "Géminis, este viernes es un buen día para jugar y divertirse."],
    DateTime.saturday: ["Géminis, este sábado es un día para ser versátil y tratar con múltiples tareas.", "Géminis, este sábado es un buen día para hacer malabares con diferentes actividades y tareas."],
    DateTime.sunday: ["Géminis, este domingo es un día para ser independiente y autónomo.", "Géminis, este domingo es un buen día para disfrutar de tu propia compañía y descansar."],
  },
  "Cáncer": {
    DateTime.monday: ["Cáncer, este lunes es un día para ser intuitivo y emocional.", "Cáncer, este lunes es un buen día para conectar con tus sentimientos y emociones."],
    DateTime.tuesday: ["Cáncer, el martes es un día para ser cariñoso y cuidadoso.", "Cáncer, este martes es un buen día para cuidar de tus seres queridos y mostrarles tu amor."],
    DateTime.wednesday: ["Cáncer, este miércoles es un día para ser imaginativo y creativo.", "Cáncer, este miércoles es un buen día para explorar tus habilidades artísticas y creativas."],
    DateTime.thursday: ["Cáncer, este jueves es un día para ser sensible y compasivo.", "Cáncer, este jueves es un buen día para ayudar a los demás y mostrar tu empatía."],
    DateTime.friday: ["Cáncer, este viernes es un día para ser protector y proporcionar seguridad.", "Cáncer, este viernes es un buen día para crear un ambiente seguro y acogedor en tu hogar."],
    DateTime.saturday: ["Cáncer, este sábado es un día para ser emocionalmente profundo.", "Cáncer, este sábado es un buen día para explorar tus emociones más profundas y entenderlas mejor."],
    DateTime.sunday: ["Cáncer, este domingo es un día para ser hogareño y disfrutar del confort de tu hogar.", "Cáncer, este domingo es un buen día para relajarte en casa y disfrutar de tu espacio personal."],
  },
    "Leo": {
    DateTime.monday: ["Leo, este lunes es un día para ser valiente y tomar la iniciativa.", "Leo, este lunes es un buen día para enfrentar tus miedos y desafíos."],
    DateTime.tuesday: ["Leo, el martes es un día para ser generoso y dar a los demás.", "Leo, este martes es un buen día para compartir tus recursos con quienes lo necesitan."],
    DateTime.wednesday: ["Leo, este miércoles es un día para ser creativo y expresivo.", "Leo, este miércoles es un buen día para expresar tus ideas y sentimientos de manera creativa."],
    DateTime.thursday: ["Leo, este jueves es un día para ser apasionado y enérgico.", "Leo, este jueves es un buen día para seguir tus pasiones y hacer lo que amas."],
    DateTime.friday: ["Leo, este viernes es un día para ser orgulloso y confiado.", "Leo, este viernes es un buen día para mostrar tu confianza en ti mismo y tus habilidades."],
    DateTime.saturday: ["Leo, este sábado es un día para ser leal y devoto.", "Leo, este sábado es un buen día para mostrar tu lealtad a tus seres queridos y tus ideales."],
    DateTime.sunday: ["Leo, este domingo es un día para ser alegre y generoso.", "Leo, este domingo es un buen día para compartir tu felicidad y generosidad con los demás."],
  },
  "Virgo": {
    DateTime.monday: ["Virgo, este lunes es un día para ser práctico y organizado.", "Virgo, este lunes es un buen día para planificar y organizar tus tareas."],
    DateTime.tuesday: ["Virgo, el martes es un día para ser detallista y perfeccionista.", "Virgo, este martes es un buen día para prestar atención a los detalles y mejorar tus habilidades."],
    DateTime.wednesday: ["Virgo, este miércoles es un día para ser útil y servicial.", "Virgo, este miércoles es un buen día para ayudar a los demás y hacer un servicio comunitario."],
    DateTime.thursday: ["Virgo, este jueves es un día para ser modesto y humilde.", "Virgo, este jueves es un buen día para ser humilde y apreciar las cosas simples de la vida."],
    DateTime.friday: ["Virgo, este viernes es un día para ser trabajador y diligente.", "Virgo, este viernes es un buen día para trabajar duro y ser productivo."],
    DateTime.saturday: ["Virgo, este sábado es un día para ser analítico y lógico.", "Virgo, este sábado es un buen día para analizar problemas y encontrar soluciones lógicas."],
    DateTime.sunday: ["Virgo, este domingo es un día para ser puro y inocente.", "Virgo, este domingo es un buen día para mantener la pureza de tus intenciones y acciones."],
  },
    "Libra": {
    DateTime.monday: ["Libra, este lunes es un día para buscar equilibrio y armonía.", "Libra, este lunes es un buen día para resolver conflictos y restaurar la paz."],
    DateTime.tuesday: ["Libra, el martes es un día para ser diplomático y justo.", "Libra, este martes es un buen día para tomar decisiones equilibradas y justas."],
    DateTime.wednesday: ["Libra, este miércoles es un día para apreciar la belleza y la estética.", "Libra, este miércoles es un buen día para disfrutar de las artes y la música."],
    DateTime.thursday: ["Libra, este jueves es un día para ser sociable y amigable.", "Libra, este jueves es un buen día para hacer conexiones y socializar."],
    DateTime.friday: ["Libra, este viernes es un día para buscar la paz y evitar el conflicto.", "Libra, este viernes es un buen día para relajarse y disfrutar de la compañía de los demás."],
    DateTime.saturday: ["Libra, este sábado es un día para ser romántico y cariñoso.", "Libra, este sábado es un buen día para expresar tu amor y afecto a alguien especial."],
    DateTime.sunday: ["Libra, este domingo es un día para ser equilibrado y centrado.", "Libra, este domingo es un buen día para meditar y restaurar tu equilibrio interno."],
  },
  "Escorpio": {
    DateTime.monday: ["Escorpio, este lunes es un día para ser apasionado y intenso.", "Escorpio, este lunes es un buen día para enfrentar tus miedos y superar los desafíos."],
    DateTime.tuesday: ["Escorpio, el martes es un día para ser misterioso y profundo.", "Escorpio, este martes es un buen día para explorar los misterios y los secretos."],
    DateTime.wednesday: ["Escorpio, este miércoles es un día para ser poderoso y transformador.", "Escorpio, este miércoles es un buen día para hacer cambios y transformaciones en tu vida."],
    DateTime.thursday: ["Escorpio, este jueves es un día para ser leal y apasionado.", "Escorpio, este jueves es un buen día para demostrar tu lealtad y pasión."],
    DateTime.friday: ["Escorpio, este viernes es un día para ser valiente y decidido.", "Escorpio, este viernes es un buen día para tomar decisiones firmes y valientes."],
    DateTime.saturday: ["Escorpio, este sábado es un día para ser emocional y sensible.", "Escorpio, este sábado es un buen día para conectarte con tus emociones y sentimientos más profundos."],
    DateTime.sunday: ["Escorpio, este domingo es un día para ser intenso y apasionado.", "Escorpio, este domingo es un buen día para vivir la vida con intensidad y pasión."],
  },
"Sagitario": {
    DateTime.monday: ["Sagitario, este lunes es un día para ser aventurero y libre.", "Sagitario, este lunes es un buen día para explorar y buscar aventuras. Pero cuidado con tomar riesgos innecesarios."],
    DateTime.tuesday: ["Sagitario, el martes es un día para ser optimista y positivo.", "Sagitario, este martes es un buen día para difundir la positividad y el optimismo. Pero no ignores las posibles dificultades en tu camino."],
    DateTime.wednesday: ["Sagitario, este miércoles es un día para ser honesto y directo.", "Sagitario, este miércoles es un buen día para hablar con honestidad y franqueza. Sin embargo, ten cuidado de no ser demasiado franco y herir los sentimientos de los demás."],
    DateTime.thursday: ["Sagitario, este jueves es un día para ser filosófico y espiritual.", "Sagitario, este jueves es un buen día para buscar la sabiduría y el conocimiento espiritual. Pero no te pierdas en pensamientos abstractos y mantén los pies en la tierra."],
    DateTime.friday: ["Sagitario, este viernes es un día para ser independiente y libre.", "Sagitario, este viernes es un buen día para afirmar tu independencia y libertad. Pero recuerda que cada acción tiene sus consecuencias."],
    DateTime.saturday: ["Sagitario, este sábado es un día para ser generoso y amable.", "Sagitario, este sábado es un buen día para compartir tu felicidad y generosidad con los demás. Pero no te olvides de tus propias necesidades."],
    DateTime.sunday: ["Sagitario, este domingo es un día para ser valiente y decidido.", "Sagitario, este domingo es un buen día para tomar decisiones firmes y valientes. Pero ten cuidado de no tomar decisiones precipitadas sin pensar en las posibles consecuencias."],
  },
  "Acuario": {
    DateTime.monday: ["Acuario, este lunes es un día para ser innovador y original.", "Acuario, este lunes es un buen día para pensar fuera de la caja y ser creativo. Pero no pierdas de vista la realidad y asegúrate de que tus ideas sean prácticas."],
    DateTime.tuesday: ["Acuario, el martes es un día para ser humanitario y altruista.", "Acuario, este martes es un buen día para ayudar a los demás y hacer un servicio comunitario. Pero no te olvides de cuidar de ti mismo."],
    DateTime.wednesday: ["Acuario, este miércoles es un día para ser racional y lógico.", "Acuario, este miércoles es un buen día para resolver problemas de manera lógica y racional. Pero no ignores tus emociones e intuiciones."],
    DateTime.thursday: ["Acuario, este jueves es un día para ser independiente y único.", "Acuario, este jueves es un buen día para afirmar tu individualidad y singularidad. Pero recuerda que también es importante cooperar y trabajar en equipo."],
    DateTime.friday: ["Acuario, este viernes es un día para ser progresista y visionario.", "Acuario, este viernes es un buen día para soñar en grande y planificar el futuro. Pero asegúrate de que tus planes sean realistas y alcanzables."],
    DateTime.saturday: ["Acuario, este sábado es un día para ser amigable y sociable.", "Acuario, este sábado es un buen día para socializar y hacer nuevas conexiones. Pero ten cuidado con las personas que pueden tener malas intenciones."],
    DateTime.sunday: ["Acuario, este domingo es un día para ser rebelde y libre.", "Acuario, este domingo es un buen día para romper las reglas y ser libre. Pero recuerda, cada acción tiene sus consecuencias."],
  },
  "Piscis": {
  DateTime.monday: ["Piscis, este lunes es un buen día para explorar tus emociones profundas.", "Piscis, este lunes puede ser un día de desafíos, pero también de oportunidades para crecer."],
  DateTime.tuesday: ["Piscis, el martes es un día para ser intuitivo y conectarte con tus sueños.", "Piscis, este martes es un buen día para prestar atención a tus intuiciones y seguir tu instinto."],
  DateTime.wednesday: ["Piscis, este miércoles es un día para ser compasivo y ayudar a los demás.", "Piscis, este miércoles es un buen día para practicar la empatía y entender las emociones de los demás."],
  DateTime.thursday: ["Piscis, este jueves es un día para ser creativo y explorar tus talentos artísticos.", "Piscis, este jueves es un buen día para sumergirte en tu imaginación y crear algo nuevo."],
  DateTime.friday: ["Piscis, este viernes es un día para ser romántico y expresar tus sentimientos.", "Piscis, este viernes es un buen día para disfrutar de la compañía de tus seres queridos y compartir tu amor con ellos."],
  DateTime.saturday: ["Piscis, este sábado es un día para ser soñador y fantasear sobre tus metas y deseos.", "Piscis, este sábado es un buen día para soñar despierto y visualizar lo que quieres en la vida."],
  DateTime.sunday: ["Piscis, este domingo es un día para relajarte y recargarte.", "Piscis, este domingo es un buen día para cuidarte a ti mismo y disfrutar de la tranquilidad."],
},
 };

 List<String>? messages = horoscopeMessages[zodiacSign]?[date.weekday];
 if (messages != null && messages.isNotEmpty) {
   int randomIndex = Random().nextInt(messages.length);
   return messages[randomIndex];
 } else {
   return "No hay horóscopo disponible para $zodiacSign el día ${date.weekday}.";
 }
}