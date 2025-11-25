import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart'; // Ajout de l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets
import 'package:musso_deme_app/wingets/primary_header.dart';
import 'package:musso_deme_app/wingets/SpeakerIcon.dart'; // Changement d'import
import 'package:musso_deme_app/pages/ValiderInscription.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:musso_deme_app/services/api_service.dart'; // Import de l'API service
import 'package:speech_to_text/speech_to_text.dart' as stt; // Using speech_to_text instead of vosk_flutter

// Couleurs
const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;

class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({super.key});
  static const String LOGO_ASSET_PATH = 'assets/images/logo.png';

  @override
  State<InscriptionScreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  // Controllers
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _localiteController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // États UI
  bool _isPasswordVisible = false;
  bool _isFormValid = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late AudioPlayer _audioPlayer; // Ajout du lecteur audio
  bool _isPlayingAudioSequence = false; // État de lecture de la séquence audio
  int _currentAudioIndex = 0; // Index de l'audio actuel dans la séquence

  // Speech to text & TTS
  late FlutterTts _flutterTts;
  late stt.SpeechToText _speechToText; // Using speech_to_text instead of vosk_flutter
  bool _isListening = false;
  int _currentStep = 0;

  // Prompts en bamanankan (plus naturel)
  final List<String> _prompts = [
    "I tɔgɔ ko dɔnni ?",           // Nom
    "I prenɔn ko dɔnni ?",          // Prénom
    "I tɛlɛfɔn nimɔrɔ ko dɔnni ?",  // Téléphone
    "I bɛ min kɔnɔ ?",              // Localité
    "I ka sira siri ko dɔnni ?",    // Mot de passe
  ];

  // Liste des audios à jouer dans l'ordre
  final List<String> _audioAssets = [
    AppAssets.audioNom,
    AppAssets.audioPrenom,
    AppAssets.audioNumTel,
    AppAssets.audioLocalite,
    AppAssets.audioMotDePasse,
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Initialisation du lecteur audio
    _flutterTts = FlutterTts();
    _speechToText = stt.SpeechToText(); // Initialize speech_to_text
    _initTts();
    _initSpeech(); // Initialize speech recognition

    // Validation en temps réel
    for (var controller in [
      _nomController,
      _prenomController,
      _phoneController,
      _localiteController,
      _passwordController
    ]) {
      controller.addListener(_validateForm);
    }

    // Démarrer la lecture de la séquence audio après un court délai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        _playAudioSequence();
      });
    });
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _phoneController.dispose();
    _localiteController.dispose();
    _passwordController.dispose();
    _audioPlayer.dispose(); // Libération des ressources du lecteur audio
    super.dispose();
  }

  // Fonction pour jouer la séquence d'audios
  Future<void> _playAudioSequence() async {
    if (_isPlayingAudioSequence) return;

    setState(() {
      _isPlayingAudioSequence = true;
      _currentAudioIndex = 0;
    });

    // Jouer chaque audio avec un intervalle de 5 secondes
    for (int i = 0; i < _audioAssets.length; i++) {
      if (!_isPlayingAudioSequence) break; // Arrêter si la séquence est interrompue

      try {
        await _audioPlayer.setAsset(_audioAssets[i]);
        await _audioPlayer.play();

        // Attendre la fin de la lecture de l'audio actuel
        await _audioPlayer.playerStateStream.firstWhere(
          (state) => state.processingState == ProcessingState.completed,
        );

        setState(() {
          _currentAudioIndex = i + 1;
        });

        // Attendre 5 secondes avant de jouer le prochain audio
        if (i < _audioAssets.length - 1) {
          await Future.delayed(const Duration(seconds: 5));
        }
      } catch (e) {
        print('Erreur lors de la lecture de l\'audio ${_audioAssets[i]}: $e');
      }
    }

    setState(() {
      _isPlayingAudioSequence = false;
      _currentAudioIndex = 0;
    });
  }

  // Fonction pour arrêter la lecture de la séquence audio
  void _stopAudioSequence() {
    setState(() {
      _isPlayingAudioSequence = false;
      _currentAudioIndex = 0;
    });
    _audioPlayer.stop();
  }

  // ==================== TTS ====================
  Future<void> _initTts() async {
    await _flutterTts.setLanguage("fr-FR");
    await _flutterTts.setSpeechRate(0.9);
    // Optionnel : voix féminine
    final voices = await _flutterTts.getVoices;
    final female = voices.firstWhere(
      (v) => v['locale'].toString().startsWith('fr') && (v['gender'] ?? '').toString().contains('female'),
      orElse: () => voices.firstWhere((v) => v['locale'].toString().startsWith('fr'), orElse: () => voices[0]),
    );
    await _flutterTts.setVoice({"name": female['name'], "locale": female['locale']});
  }

  // ==================== Speech Recognition ====================
  Future<void> _initSpeech() async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Autorise le micro pour la reconnaissance vocale")),
      );
      return;
    }

    // Initialize speech recognition
    bool available = await _speechToText.initialize(
      onStatus: (status) {
        print('Speech recognition status: $status');
        if (status == stt.SpeechToText.listeningStatus) {
          setState(() => _isListening = true);
        } else {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        print('Speech recognition error: $error');
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur reconnaissance vocale : $error")),
        );
      },
      debugLogging: true,
    );

    if (available) {
      _startVoiceGuidance(); // Démarre la guidance
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reconnaissance vocale non disponible")),
      );
    }
  }

  Future<void> _startVoiceGuidance() async {
    if (_currentStep >= _prompts.length) {
      await _flutterTts.speak("Tout est prêt ! I bɛ se ka valider kɔnɔ.");
      return;
    }

    await _flutterTts.speak(_prompts[_currentStep]);
    _startListening();
  }

  Future<void> _startListening() async {
    if (_isListening) return;

    // Start listening for speech
    _speechToText.listen(
      localeId: 'fr_FR', // French locale
      listenFor: const Duration(seconds: 8), // Listen for 8 seconds
      pauseFor: const Duration(seconds: 3), // Pause for 3 seconds before stopping
      partialResults: true, // Get partial results
    );
    
    setState(() => _isListening = true);

    // Set up a timer to stop listening after 8 seconds
    Future.delayed(const Duration(seconds: 8), () {
      if (_isListening) {
        _stopListening();
        _checkField();
      }
    });
  }

  void _stopListening() {
    if (_isListening) {
      _speechToText.stop();
      setState(() => _isListening = false);
    }
  }

  void _checkField() {
    // Get the last recognized words
    String recognizedWords = _speechToText.lastRecognizedWords;
    
    if (recognizedWords.trim().isEmpty) {
      _flutterTts.speak("Champ vide, veuillez répéter").then((_) => _startListening());
    } else {
      _fillCurrentField(recognizedWords);
      _currentStep++;
      if (_currentStep < _prompts.length) {
        _startVoiceGuidance();
      } else {
        _flutterTts.speak("Tout est rempli ! Vous allez être redirigé vers la page de validation.");
        // Rediriger vers la page de validation après un court délai
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ValiderInscription(
                  nom: _nomController.text,
                  prenom: _prenomController.text,
                  telephone: _phoneController.text,
                  localite: _localiteController.text,
                  motDePasse: _passwordController.text,
                ),
              ),
            );
          }
        });
      }
    }
  }

  void _fillCurrentField(String text) {
    switch (_currentStep) {
      case 0:
        _nomController.text = text;
        break;
      case 1:
        _prenomController.text = text;
        break;
      case 2:
        // Nettoie le numéro (garde chiffres uniquement)
        _phoneController.text = text.replaceAll(RegExp(r'[^0-9+]'), '');
        break;
      case 3:
        _localiteController.text = text;
        break;
      case 4:
        _passwordController.text = text;
        break;
    }
    _validateForm();
  }

  // ==================== Validation ====================
  void _validateForm() {
    final valid = _nomController.text.trim().isNotEmpty &&
        _prenomController.text.trim().isNotEmpty &&
        RegExp(r'^\+?[0-9]{7,15}$').hasMatch(_phoneController.text.trim()) &&
        _localiteController.text.trim().isNotEmpty &&
        _passwordController.text.trim().length >= 6;

    if (valid != _isFormValid) {
      setState(() => _isFormValid = valid);
    }
  }

  // Fonction pour gérer l'inscription
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate() || !_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vérifie tous les champs")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.register(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        numeroTel: _phoneController.text.trim(),
        localite: _localiteController.text.trim(),
        motCle: _passwordController.text.trim(),
      );

      if (result != null) {
        // Inscription réussie - naviguer vers la page de validation
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ValiderInscription()),
          );
        }
      } else {
        // Erreur d'inscription
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Échec de l'inscription. Veuillez réessayer."),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _submitForm() {
    _handleRegister();
  }

  // ==================== UI ====================
  @override
  Widget build(BuildContext context) {
    // Le widget de votre logo Image.asset
    final Widget logoImage = Image.asset(
      InscriptionScreen.LOGO_ASSET_PATH,
      fit: BoxFit.cover,
    );
    
    return Scaffold(
      backgroundColor: neutralWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // 1. Zone Supérieure (Tête de page et Logo)
                PrimaryHeader(
                  logoChild: logoImage,
                  showNotification: false,
                ),

                // 2. Le Corps du Formulaire - même design que la page ValiderInscription
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Indicateur d'écoute
                      if (_isListening)
                        Column(
                          children: const [
                            Icon(Icons.mic, size: 70, color: primaryViolet),
                            SizedBox(height: 10),
                            Text("Écoute...", style: TextStyle(fontSize: 18, color: primaryViolet)),
                          ],
                        ),
                      if (_isListening)
                        const SizedBox(height: 20),

                      // 3. Bouton "Inscription" avec dégradé (même design)
                      _buildInscriptionButton(),

                      const SizedBox(height: 30),

                      // 4. Champs de Formulaire (mêmes que la page ValiderInscription)
                      // Nom
                      _buildTextField("Nom", Icons.person_outline, _nomController),
                      const SizedBox(height: 20),

                      // Prénom
                      _buildTextField("Prénom", Icons.person_outline, _prenomController),
                      const SizedBox(height: 20),

                      // Téléphone
                      _buildTextField("Téléphone", Icons.call_outlined, _phoneController, keyboardType: TextInputType.phone),
                      const SizedBox(height: 20),

                      // Localité
                      _buildTextField("Localité", Icons.location_on_outlined, _localiteController),
                      const SizedBox(height: 20),

                      // Mot clé (Mot de passe)
                      _buildPasswordTextField(),

                      const SizedBox(height: 50),

                      // 5. Icône de validation au lieu de l'icône d'oreille
                      Center(
                        child: GestureDetector(
                          onTap: _isLoading ? null : _handleRegister,
                          child: Container(
                            width: 80, // Même taille que l'icône d'oreille
                            height: 80, // Même taille que l'icône d'oreille
                            decoration: BoxDecoration(
                              color: primaryViolet, // Fond violet comme l'icône d'oreille
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryViolet.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                : const Icon(
                                    Icons.check, // Icône de validation
                                    color: neutralWhite, // Couleur blanche comme l'icône d'oreille
                                    size: 40, // Taille de l'icône
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Ajout de l'icône de microphone
          const SpeakerIcon(),
        ],
      ),
    );
  }

  // Construction du bouton "Inscription" avec dégradé
  Widget _buildInscriptionButton() {
    // Le dégradé du bouton est Violet clair au Violet foncé
    const Gradient inscriptionGradient = LinearGradient(
      colors: [Color(0xFF8A2BE2), primaryViolet], // Du violet plus clair au violet principal
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primaryViolet.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        gradient: inscriptionGradient,
      ),
      child: const Center(
        child: Text(
          "Inscription",
          style: TextStyle(
            color: neutralWhite,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: primaryViolet),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: primaryViolet),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: primaryViolet, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }

  // Widget pour le champ de mot de passe
  Widget _buildPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 5.0),
          child: Text(
            "Mot clé",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, color: primaryViolet),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: primaryViolet,
              ),
              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: primaryViolet),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: primaryViolet, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }
}