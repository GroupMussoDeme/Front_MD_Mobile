import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/pages/HomeScreen.dart';
import 'package:musso_deme_app/services/session_service.dart';
import 'package:musso_deme_app/widgets/primary_header.dart';
import 'package:musso_deme_app/pages/InscriptionScreen.dart';
import 'package:musso_deme_app/services/auth_service.dart';

// Couleurs
const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;

const String ASSET_IMAGE_PATH = 'assets/images/image2.png';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _playAudio();
  }

  void _playAudio() async {
    try {
      // Arrêter toute lecture en cours
      await audioPlayer.stop();
      
      // Lecture automatique de l'audio "inscription.aac"
      await audioPlayer.setAsset("assets/audios/inscription.aac");
      await audioPlayer.play();
    } catch (e) {
      print("Erreur lors de la lecture de l'audio: $e");
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _identifiantController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final TextEditingController _identifiantController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _playAudioInstruction(String fieldName) {
    // Arrêter toute lecture en cours
    audioPlayer.stop();
    
    print("DEMANDE AUDIO : Lecture de l'instruction pour '$fieldName'");
  }

  Future<void> _submitLogin() async {
    print('🔸 _submitLogin() appelé');

    final formValid = _formKey.currentState?.validate() ?? false;
    print('🔸 formValid = $formValid');

    if (!formValid) {
      print('🔸 Formulaire login invalide, annulation');
      return;
    }

    setState(() => _isLoading = true);

    final response = await AuthService.login(
      identifiant: _identifiantController.text,
      motDePasse: _passwordController.text,
    );

    setState(() => _isLoading = false);

    print('🔸 Réponse login: $response');

    if (response["status"] == 200) {
      final data = response["data"];
      final accessToken = data["accessToken"] as String;
      final refreshToken = data["refreshToken"] as String;
      final role = data["role"] as String;
      final userId = data["userId"] as int;

      print('✅ Login OK: role=$role, userId=$userId');

      // Sauvegarde locale de la session
      await SessionService.saveSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        role: role,
        userId: userId,
      );

      // Redirection (mobile = FEMME_RURALE)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      final message =
          response["data"]["message"] ?? "Identifiant ou mot de passe invalide";
      print('❌ Erreur login: $message');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : $message")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget logoImage = Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.person, color: primaryViolet, size: 45);
      },
    );

    return Scaffold(
      backgroundColor: neutralWhite,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            PrimaryHeader(logoChild: logoImage, showNotification: false),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildLoginButton(),
                    const SizedBox(height: 30),
                    _buildImagePlaceholder(),
                    const SizedBox(height: 30),

                    // Champ identifiant (Téléphone ou Email)
                    _buildAudioTextField(
                      label: "Téléphone ou Email",
                      icon: Icons.call_outlined,
                      keyboardType: TextInputType.text,
                      isPassword: false,
                      controller: _identifiantController,
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) {
                          return 'Identifiant requis';
                        }
                        if (v.contains('@')) {
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                          if (!emailRegex.hasMatch(v)) {
                            return 'Format email invalide';
                          }
                        } else {
                          if (v.length < 8) {
                            return 'Le numéro doit contenir au moins 8 caractères';
                          }
                          if (!RegExp(r'^[0-9+ ]+$').hasMatch(v)) {
                            return 'Le numéro ne doit contenir que des chiffres, espaces ou +';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Champ mot de passe
                    _buildAudioTextField(
                      label: "Mot clé",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: _passwordController,
                      validator: (value) {
                        final v = value ?? '';
                        if (v.trim().isEmpty) {
                          return 'Mot de passe requis';
                        }
                        if (v.length < 4) {
                          return 'Le mot de passe doit contenir au moins 4 caractères';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    _buildRegisterLink(),
                    const SizedBox(height: 40),

                    // ICI : le micro joue le rôle de bouton de connexion
                    GestureDetector(
                      onTap: _isLoading ? null : _submitLogin,
                      child: _buildMicIcon(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    const Gradient loginGradient = LinearGradient(
      colors: [Color(0xFF8A2BE2), primaryViolet],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return InkWell(
      onTap: _isLoading ? null : _submitLogin,
      child: Container(
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
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(neutralWhite),
                  ),
                )
              : const Text(
                  "Connexion",
                  style: TextStyle(
                    color: neutralWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.asset(
            ASSET_IMAGE_PATH,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text("Erreur de chargement de l'image"),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAudioTextField({
    required String label,
    required IconData icon,
    required bool isPassword,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
    String? Function(String?)? validator,
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
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: isPassword && !_isPasswordVisible,
                validator:
                    validator ??
                    (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Champ requis';
                      }
                      return null;
                    },
                decoration: InputDecoration(
                  prefixIcon: Icon(icon, color: primaryViolet),
                  suffixIcon: isPassword
                      ? IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: primaryViolet,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 10.0,
                  ),
                  border: _getBorder(Colors.grey, 1.0),
                  enabledBorder: _getBorder(Colors.grey, 1.0),
                  focusedBorder: _getBorder(primaryViolet, 2.0),
                ),
              ),
            ),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InscriptionScreen(),
              ),
            );
          },
          child: const Text(
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
      child: const Icon(Icons.mic_none, color: neutralWhite, size: 60),
    );
  }

  OutlineInputBorder _getBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
