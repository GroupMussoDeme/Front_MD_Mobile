import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/primary_header.dart';
import 'package:musso_deme_app/pages/HomeScreen.dart'; // Import de la page d'accueil

// --- Définition des couleurs de la Charte Graphique ---
const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;

const String ASSET_IMAGE_PATH = 'assets/images/background3.png';

class ValiderConnexion extends StatefulWidget {
  const ValiderConnexion({super.key});

  @override
  State<ValiderConnexion> createState() => _ValiderConnexionState();
}

class _ValiderConnexionState extends State<ValiderConnexion> {
  bool _isPasswordVisible = false;

  // Fonction de rappel à exécuter lorsque le haut-parleur est cliqué
  void _playAudioInstruction(String fieldName) {
    print("DEMANDE AUDIO : Lecture de l'instruction pour le champ '$fieldName'");
  }

  @override
  Widget build(BuildContext context) {
    final Widget logoImage = Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.cover,
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
                  
                  // 6. Icône de validation au lieu du microphone
                  _buildValidationIcon(),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.asset(
            ASSET_IMAGE_PATH,
            fit: BoxFit.cover,
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
            ),
            
            const SizedBox(width: 10),
            
            // Bouton Audio (Haut-parleur)
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: primaryViolet,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.volume_up,
                  color: neutralWhite,
                ),
                onPressed: () {
                  _playAudioInstruction(label);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Lien "S'inscrire"
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Vous n'avez pas de compte ? ",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigation vers la page d'inscription
            Navigator.pushNamed(context, '/InscriptionScreen');
          },
          child: const Text(
            "S'inscrire",
            style: TextStyle(
              color: primaryViolet,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  // Icône de validation au lieu du microphone
  Widget _buildValidationIcon() {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Navigation vers la page d'accueil
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: primaryViolet,
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
          child: const Icon(
            Icons.check, // Icône de validation
            color: neutralWhite,
            size: 40,
          ),
        ),
      ),
    );
  }
}