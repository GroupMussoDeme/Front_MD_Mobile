import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/primary_header.dart';

// --- Définition des couleurs de la Charte Graphique ---
const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;

class Confirmationscreen extends StatefulWidget {
  const Confirmationscreen({super.key});

  @override
  State<Confirmationscreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<Confirmationscreen> {
  bool _isPasswordVisible = false;

  // Fonction de rappel à exécuter lorsque le haut-parleur est cliqué
  void _playAudioInstruction(String fieldName) {
    // Ici, vous ajouteriez la logique réelle pour jouer le fichier audio
    // correspondant à l'instruction du champ (ex: "Entrez votre nom")
    print("DEMANDE AUDIO : Lecture de l'instruction pour le champ '$fieldName'");
    // Pour un test réel, vous utiliseriez un package comme just_audio ou audioplayers.
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
                  // 2. Bouton "Inscription" avec dégradé
                  _buildInscriptionButton(),
                  
                  const SizedBox(height: 30),
                  
                  // 3. Champs de Formulaire (avec icônes audio)
                  // Nom
                  _buildAudioTextField(label: "Nom", icon: Icons.person_outline),
                  const SizedBox(height: 20),

                  // Prenom
                  _buildAudioTextField(label: "Prenom", icon: Icons.person_outline),
                  const SizedBox(height: 20),

                  // Téléphone
                  _buildAudioTextField(
                    label: "Téléphone",
                    icon: Icons.call_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  // Rôle
                  _buildAudioTextField(label: "Rôle", icon: Icons.person_outline),
                  const SizedBox(height: 20),

                  // Localité
                  _buildAudioTextField(label: "Localité", icon: Icons.location_on_outlined),
                  const SizedBox(height: 20),

                  // Mot clé (Mot de passe)
                  _buildAudioPasswordTextField(),
                  
                  const SizedBox(height: 50),
                  
                  // 4. Icône de Validation Finale (Coche)
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

  // Bouton Inscription (inchangé)
  Widget _buildInscriptionButton() {
    const Gradient inscriptionGradient = LinearGradient(
      colors: [Color(0xFF8A2BE2), primaryViolet],
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
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
  
  // NOUVEAU Widget pour un champ de texte avec icône audio
  Widget _buildAudioTextField({
    required String label,
    required IconData icon,
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
              fontFamily: 'Inter',
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
                decoration: InputDecoration(
                  prefixIcon: Icon(icon, color: primaryViolet),
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
              padding: const EdgeInsets.only(left: 10, top: 12), // Ajustement de positionnement
              iconSize: 30,
            ),
          ],
        ),
      ],
    );
  }
  
  // NOUVEAU Widget spécifique pour le champ du mot de passe avec icône audio
  Widget _buildAudioPasswordTextField() {
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
              fontFamily: 'Inter',
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: primaryViolet),
                  // Bouton de visibilité (œil)
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: primaryViolet,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  border: _getBorder(primaryViolet, 1.5),
                  enabledBorder: _getBorder(Colors.grey, 1.0),
                  focusedBorder: _getBorder(primaryViolet, 2.0),
                ),
              ),
            ),
            
            // Icône de Haut-parleur (Speaker Icon)
            IconButton(
              onPressed: () => _playAudioInstruction("Mot clé"),
              icon: const Icon(Icons.volume_up, color: primaryViolet, size: 30),
              padding: const EdgeInsets.only(left: 10, top: 12),
              iconSize: 30,
            ),
          ],
        ),
      ],
    );
  }
  
  // Widget pour l'icône de validation finale (Coche)
  Widget _buildValidationIcon() {
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
        Icons.check,
        color: neutralWhite,
        size: 60,
      ),
    );
  }

  // Fonction utilitaire pour la bordure (réduit la répétition)
  OutlineInputBorder _getBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}