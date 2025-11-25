import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts flutterTts = FlutterTts();

  bool isListening = false;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController localiteController = TextEditingController();
  final TextEditingController numeroTelController = TextEditingController();
  final TextEditingController motCleController = TextEditingController();

  late List<Map<String, dynamic>> fields;
  int currentFieldIndex = 0;

  @override
  void initState() {
    super.initState();
    _initTts();
    fields = [
      {"controller": nomController, "label": "Nom"},
      {"controller": prenomController, "label": "Prénom"},
      {"controller": localiteController, "label": "Localité"},
      {"controller": numeroTelController, "label": "Numéro de téléphone"},
      {"controller": motCleController, "label": "Mot de passe", "obscure": true},
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nextField();
    });
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("fr-ML");
    await flutterTts.setPitch(1.1);
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setVolume(1.0);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  void _startListening() async {
    final field = fields[currentFieldIndex];
    final controller = field["controller"];

    bool available = await _speech.initialize();
    if (available) {
      setState(() => isListening = true);
      _speech.listen(
        localeId: "fr-ML",
        onResult: (result) {
          controller.text = result.recognizedWords;
        },
      );

      // Arrêter après 8 secondes pour passer au suivant
      Future.delayed(Duration(seconds: 8), () {
        stopListening();
        _checkField();
      });
    }
  }

  void stopListening() {
    setState(() => isListening = false);
    _speech.stop();
  }

  void _checkField() {
    final field = fields[currentFieldIndex];
    final controller = field["controller"];

    if (controller.text.isEmpty) {
      _speak("Champ vide, veuillez répéter").then((_) => _startListening());
    } else {
      currentFieldIndex++;
      if (currentFieldIndex < fields.length) {
        _nextField();
      } else {
        _submitForm();
      }
    }
  }

  void _nextField() async {
    final field = fields[currentFieldIndex];
    await _speak("Veuillez remplir le champ ${field['label']}");
    _startListening();
  }

  Future<void> _submitForm() async {
    await _speak("Tous les champs sont remplis, création du compte en cours");

    final url = Uri.parse("http://localhost:8080/api/auth/register"); // endpoint
    final body = {
      "nom": nomController.text,
      "prenom": prenomController.text,
      "localite": localiteController.text,
      "numeroTel": numeroTelController.text,
      "motCle": motCleController.text,
      "role": "UTILISATEUR",
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      await _speak("Compte créé avec succès !");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Compte créé avec succès !")));
    } else {
      await _speak("Erreur lors de la création du compte");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${response.body}")));
    }
  }

  @override
  void dispose() {
    _speech.stop();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un Compte")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: fields.map((field) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: field["controller"],
                obscureText: field["obscure"] ?? false,
                decoration: InputDecoration(
                  labelText: field["label"],
                  border: OutlineInputBorder(),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
