import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class VoskService {
  static SpeechService? speechService;
  static Model? model;

  static Future<void> init() async {
    model = await Model.fromAsset('assets/models/vosk-model-small-african-0.22');
    speechService = SpeechService(model!);
  }

  static Future<void> start(Function(String) onText) async {
    await speechService!.start();

    speechService!.onResult().listen((event) {
      if (event.text != null && event.text!.isNotEmpty) {
        onText(event.text!);
      }
    });
  }

  static Future<void> stop() async {
    await speechService!.stop();
  }
}

// Local minimal stubs to replace the missing 'vosk_flutter' package during development.
// These provide the API surface used by VoskService and can be replaced with the real
// package implementation or removed once the correct dependency is added.
class Model {
  Model._();
  static Future<Model> fromAsset(String path) async => Model._();
}

class RecognitionResult {
  final String? text;
  RecognitionResult(this.text);
}

class SpeechService {
  final Model model;
  SpeechService(this.model);

  Future<void> start() async {}
  Future<void> stop() async {}
  Stream<RecognitionResult> onResult() => Stream<RecognitionResult>.empty();
}
