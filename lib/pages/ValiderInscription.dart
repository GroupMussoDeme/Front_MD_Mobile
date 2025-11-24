import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/primary_header.dart';
import 'package:musso_deme_app/pages/LoginScreen.dart'; // Import de la page de connexion

// --- Définition des couleurs de la Charte Graphique ---
const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;

class ValiderInscription extends StatefulWidget {
  const ValiderInscription({super.key});

  static const String LOGO_ASSET_PATH = 'assets/images/logo.png';

  @override
  State<ValiderInscription> createState() => _ValiderInscriptionState();
}

class _ValiderInscriptionState extends State<ValiderInscription> {
  @override
  Widget build(BuildContext context) {
    // Le widget de votre logo Image.asset
    final Widget logoImage = Image.asset(
      ValiderInscription.LOGO_ASSET_PATH,
      fit: BoxFit.cover, // Assure que l'image remplit bien le cercle
      // Vous pouvez utiliser un BoxFit.contain si l'image est petite
    );
    return Scaffold(
      backgroundColor: neutralWhite,

      // Le SingleChildScrollView permet aux champs de défiler si l'écran est petit (ou le clavier s'ouvre)
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 1. Zone Supérieure (Tête de page et Logo)
            PrimaryHeader(
              logoChild: logoImage,
              showNotification: false,
            ),

            // 2. Le Corps du Formulaire - même design que la page d'inscription
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0), // Même marge que la page d'inscription
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // 3. Bouton "Inscription" avec dégradé (même design)
                  _buildInscriptionButton(),

                  const SizedBox(height: 30),

                  // 4. Champs de Formulaire (mêmes que la page d'inscription)
                  // Nom
                  _buildTextField(label: "Nom", icon: Icons.person_outline),
                  const SizedBox(height: 20),

                  // Prenom
                  _buildTextField(label: "Prenom", icon: Icons.person_outline),
                  const SizedBox(height: 20),

                  // Téléphone
                  _buildTextField(
                    label: "Téléphone",
                    icon: Icons.call_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  // Localité
                  _buildTextField(label: "Localité", icon: Icons.location_on_outlined),
                  const SizedBox(height: 20),

                  // Mot clé (Mot de passe)
                  _buildPasswordTextField(),

                  const SizedBox(height: 50),

                  // 5. Icône de validation au lieu de l'icône d'oreille
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
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
                        child: const Icon(
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
    );
  }

  // --- Widgets de construction ---
  // Mêmes widgets que dans la page d'inscription

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
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
  
  // Widget pour un champ de texte standard
  Widget _buildTextField({
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
        TextFormField(
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
              fontFamily: 'Inter',
            ),
          ),
        ),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, color: primaryViolet),
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

  // Construction de l'image d'arrière-plan (Placeholder)
  Widget _buildImagePlaceholder() {
    return Container(
      height: 200, // Augmenté de 180 à 200
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage(ValiderInscription.LOGO_ASSET_PATH),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}