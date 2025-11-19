import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/primary_header.dart';
import 'package:musso_deme_app/pages/InscriptionScreen.dart';
import 'package:musso_deme_app/pages/ValiderConnexion.dart'; // Import de la nouvelle page

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

  // Fonction de rappel à exécuter lorsque le haut-parleur est cliqué
  void _playAudioInstruction(String fieldName) {
    print("DEMANDE AUDIO : Lecture de l'instruction pour le champ '$fieldName'");
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
      
      body: SingleChildScrollView(
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
                  ),
                  const SizedBox(height: 20),

                  // Mot clé (Mot de passe)
                  _buildAudioTextField(
                    label: "Mot clé",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  
                  const SizedBox(height: 15),

                  // 5. Lien "S'inscrire"
                  _buildRegisterLink(),
                  
                  const SizedBox(height: 40),
                  
                  // 6. Icône d'enregistrement vocal (Microphone) - avec navigation vers ValiderConnexion
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ValiderConnexion()),
                      );
                    },
                    child: _buildMicIcon(),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      child: const Icon(
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