import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Ajout de l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets
import 'package:musso_deme_app/wingets/primary_header.dart';
import 'package:musso_deme_app/wingets/SpeakerIcon.dart'; 
import 'package:musso_deme_app/pages/InscriptionScreen.dart';
import 'package:musso_deme_app/pages/ValiderConnexion.dart';
import 'package:musso_deme_app/services/api_service.dart'; // Import de l'API service
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

// --- Définition des couleurs de la Charte Graphique ---
const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;

const String ASSET_IMAGE_PATH = 'assets/images/image2.png';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  late AudioPlayer _audioPlayer; // Ajout du lecteur audio
  bool _isPlayingAudio = false; // État de lecture de l'audio
  
  // Speech to text & TTS
  late FlutterTts _flutterTts;
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  int _currentStep = 0;

  // Prompts en bamanankan
  final List<String> _prompts = [
    "I tɛlɛfɔn nimɔrɔ ko dɔnni ?",  // Téléphone
    "I ka sira siri ko dɔnni ?",    // Mot de passe
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Initialisation du lecteur audio
    _flutterTts = FlutterTts();
    _speechToText = stt.SpeechToText();
    _initTts();
    _initSpeech();
    _playInscriptionAudio(); // Lecture de l'audio d'inscription au démarrage
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _audioPlayer.dispose(); // Libération des ressources du lecteur audio
    super.dispose();
  }

  // Fonction pour jouer l'audio d'inscription
  Future<void> _playInscriptionAudio() async {
    try {
      setState(() {
        _isPlayingAudio = true;
      });
      
      await _audioPlayer.setAsset(AppAssets.audioInscription);
      
      // Écouter la fin de la lecture
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlayingAudio = false;
          });
        }
      });
      
      await _audioPlayer.play();
    } catch (e) {
      print('Erreur lors de la lecture de l\'audio d\'inscription: $e');
      setState(() {
        _isPlayingAudio = false;
      });
    }
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
      // On ne démarre pas automatiquement la reconnaissance vocale pour la connexion
      // L'utilisateur doit appuyer sur le microphone
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reconnaissance vocale non disponible")),
      );
    }
  }

  Future<void> _startVoiceGuidance() async {
    if (_currentStep >= _prompts.length) {
      await _flutterTts.speak("Tout est prêt ! I bɛ se ka valider kɔnɔ.");
      // Rediriger vers la page de validation
      _navigateToValidationPage();
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
          _navigateToValidationPage();
        });
      }
    }
  }

  void _fillCurrentField(String text) {
    switch (_currentStep) {
      case 0:
        // Nettoie le numéro (garde chiffres uniquement)
        _phoneController.text = text.replaceAll(RegExp(r'[^0-9+]'), '');
        break;
      case 1:
        _passwordController.text = text;
        break;
    }
  }

  void _navigateToValidationPage() {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ValiderConnexion(
            telephone: _phoneController.text,
            motDePasse: _passwordController.text,
          ),
        ),
      );
    }
  }

  // Fonction de rappel à exécuter lorsque le haut-parleur est cliqué
  void _playAudioInstruction(String fieldName) {
    print("DEMANDE AUDIO : Lecture de l'instruction pour le champ '$fieldName'");
  }

  // Fonction pour gérer la connexion
  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.login(
        _phoneController.text.trim(),
        _passwordController.text.trim(),
      );

      if (result != null) {
        // Connexion réussie - naviguer vers la page de validation
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ValiderConnexion()),
          );
        }
      } else {
        // Erreur de connexion
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Échec de la connexion. Veuillez vérifier vos identifiants."),
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

  @override
  Widget build(BuildContext context) {
    final Widget logoImage = Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.person,
          color: primaryViolet,
          size: 45,
        );
      },
    );

    return Scaffold(
      backgroundColor: neutralWhite,
      
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // 1. Zone Supérieure (Tête de page et Logo)
                PrimaryHeader(logoChild: logoImage, showNotification: false),
                
                const SizedBox(height: 50),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                      
                      // 2. Bouton "Connexion" avec dégradé
                      _buildLoginButton(),
                      
                      const SizedBox(height: 30),
                      
                      // 3. Zone de l'Image (simulée par une Card)
                      _buildImagePlaceholder(),
                      
                      const SizedBox(height: 30),

                      // 4. Champs de Connexion (avec icônes audio)
                      // Téléphone
                      _buildAudioTextField(
                        label: "Téléphone",
                        icon: Icons.call_outlined,
                        keyboardType: TextInputType.phone,
                        isPassword: false,
                        controller: _phoneController,
                      ),
                      const SizedBox(height: 20),

                      // Mot clé (Mot de passe)
                      _buildAudioTextField(
                        label: "Mot clé",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        controller: _passwordController,
                      ),
                      
                      const SizedBox(height: 15),

                      // 5. Lien "S'inscrire"
                      _buildRegisterLink(),
                      
                      const SizedBox(height: 40),
                      
                      // 6. Icône d'enregistrement vocal (Microphone) - avec navigation vers ValiderConnexion
                      GestureDetector(
                        onTap: _isLoading || _isListening ? null : _startVoiceGuidance,
                        child: _buildMicIcon(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Ajout de l'icône de haut-parleur
          const SpeakerIcon(),
        ],
      ),
    );
  }

  // --- Widgets de construction ---

  // Bouton "Connexion" avec dégradé
  Widget _buildLoginButton() {
    const Gradient loginGradient = LinearGradient(
      colors: [Color(0xFF8A2BE2), primaryViolet],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Container(
      height: 30,
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
        gradient: loginGradient,
      ),
      child: const Center(
        child: Text(
          "Connexion",
          style: TextStyle(
            color: neutralWhite,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            // fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

Widget _buildImagePlaceholder() {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: ClipRRect( // Utilisez ClipRRect pour s'assurer que l'image est bien arrondie
      borderRadius: BorderRadius.circular(15.0),
      child: SizedBox(
        height: 200, // Augmenté de 180 à 200
        width: double.infinity, // Occupe toute la largeur disponible
        child: Image.asset(
          ASSET_IMAGE_PATH,
          fit: BoxFit.cover, // Assurez-vous que l'image couvre bien la zone
          errorBuilder: (context, error, stackTrace) {
            return Center(child: Text("Erreur de chargement de l'image"));
          },
        ),
      ),
    ),
  );
}

  // Champ de texte unique pour téléphone et mot de passe (gestion audio et visibilité)
  Widget _buildAudioTextField({
    required String label,
    required IconData icon,
    required bool isPassword,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
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
              // fontFamily: 'Inter',
            ),
          ),
        ),
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Champ de Texte
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: isPassword && !_isPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: Icon(icon, color: primaryViolet),
                  // Icône de visibilité/dévisibilité pour le mot de passe
                  suffixIcon: isPassword
                      ? IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: primaryViolet,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        )
                      : null, // Pas d'icône si ce n'est pas le mot de passe
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  border: _getBorder(primaryViolet, 1.5),
                  enabledBorder: _getBorder(Colors.grey, 1.0),
                  focusedBorder: _getBorder(primaryViolet, 2.0),
                ),
              ),
            ),
            
            // Icône de Haut-parleur (Speaker Icon)
            IconButton(
              onPressed: () => _playAudioInstruction(label),
              icon: const Icon(Icons.volume_up, color: primaryViolet, size: 30),
              padding: const EdgeInsets.only(left: 10, top: 12),
              iconSize: 30,
            ),
          ],
        ),
      ],
    );
  }
  
  // Lien vers la page d'inscription
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Vous n'avez pas de compte ? ",
          style: TextStyle(fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            // Logique de navigation vers la page d'inscription
            print("Navigation vers la page d'inscription...");
            Navigator.push(context, MaterialPageRoute(builder: (context) => const InscriptionScreen()));
          },
          child: Text(
            "S'inscrire.",
            style: TextStyle(
              color: primaryViolet,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              decoration: TextDecoration.underline,
              decorationColor: primaryViolet,
            ),
          ),
        ),
      ],
    );
  }
  
  // Icône du Microphone
  Widget _buildMicIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: primaryViolet,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primaryViolet.withOpacity(0.5),
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
              Icons.mic_none,
              color: neutralWhite,
              size: 60,
            ),
    );
  }

  // Fonction utilitaire pour la bordure
  OutlineInputBorder _getBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}