import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/primary_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


// --- Définition des couleurs de la Charte Graphique ---

// Couleur principale : Violet (#491B6D)
const Color primaryViolet = Color(0xFF491B6D);
// Couleur neutre : Blanc (#FFFFFF)
const Color neutralWhite = Colors.white;

class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({super.key});

  static const String LOGO_ASSET_PATH = 'assets/images/logo.png';

  @override
  State<InscriptionScreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  // État pour gérer la visibilité du mot de passe
  bool _isPasswordVisible = false;

  // État pour activer/désactiver le bouton
  bool _isFormValid = false;

  final _formKey = GlobalKey<FormState>();

  // Controllers pour récupérer les valeurs et valider
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _localiteController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    _localiteController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Écoute des changements pour activer/désactiver le bouton
    _nomController.addListener(_validateForm);
    _prenomController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _roleController.addListener(_validateForm);
    _localiteController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _validateForm();
  }

  void _validateForm() {
    final nomOk = _nomController.text.trim().isNotEmpty;
    final prenomOk = _prenomController.text.trim().isNotEmpty;
      final phoneOk = RegExp(r'^\+?[0-9]{7,15}$').hasMatch(_phoneController.text.trim());
    final roleOk = _roleController.text.trim().isNotEmpty;
    final localiteOk = _localiteController.text.trim().isNotEmpty;
    final passwordOk = _passwordController.text.trim().length >= 6;

    final valid = nomOk && prenomOk && phoneOk && roleOk && localiteOk && passwordOk;
    if (valid != _isFormValid) {
      setState(() {
        _isFormValid = valid;
      });
    }
  }

  void _submitForm() {
    // Exécuter la validation du Form pour afficher les erreurs côté champs
    final formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez remplir tous les champs correctement')));
      return;
    }

    // Vérifications additionnelles (format téléphone et longueur mot de passe)
      if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(_phoneController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Format de téléphone invalide')));
      return;
    }

    if (_passwordController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Le mot de passe doit contenir au moins 6 caractères')));
      return;
    }

    // Tous les champs sont remplis correctement -> on peut naviguer
    Navigator.pushReplacementNamed(context, '/ConfirmationScreen');
  }

  @override
  Widget build(BuildContext context) {
    // Le widget de votre logo Image.asset
    final Widget logoImage = Image.asset(
      InscriptionScreen.LOGO_ASSET_PATH,
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

            // 2. Le Corps du Formulaire
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // 3. Bouton "Inscription" avec dégradé (devient cliquable)
                    _buildInscriptionButton(),

                    const SizedBox(height: 30),

                    // 4. Champs de Formulaire
                    // Nom
                    _buildTextField(label: "Nom", icon: Icons.person_outline, controller: _nomController),
                    const SizedBox(height: 20),

                    // Prenom
                    _buildTextField(label: "Prenom", icon: Icons.person_outline, controller: _prenomController),
                    const SizedBox(height: 20),

                    // Téléphone
                    _buildTextField(
                      label: "Téléphone",
                      icon: Icons.call_outlined,
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                    ),
                    const SizedBox(height: 20),

                    // Rôle
                    _buildTextField(label: "Rôle", icon: Icons.person_outline, controller: _roleController),
                    const SizedBox(height: 20),

                    // Localité
                    _buildTextField(label: "Localité", icon: Icons.location_on_outlined, controller: _localiteController),
                    const SizedBox(height: 20),

                    // Mot clé (Mot de passe)
                    _buildPasswordTextField(),

                    const SizedBox(height: 50),

                    // 5. Icône Audio (Oreille)
                    const Center(
                      child: Icon(
                        // Utilisation d'une icône Font Awesome ou une icône générique
                        FontAwesomeIcons.earListen, // Nécessite l'installation de font_awesome_flutter
                        color: primaryViolet,
                        size: 60,
                      ),
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

  // --- Widgets de construction ---

  // Construction de la zone de tête (Container violet, courbes et cercle de profil)
  Widget _buildHeader(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      height: 180, // Hauteur fixe pour la zone de tête
      decoration: const BoxDecoration(
        color: primaryViolet,
        // Les coins arrondis dans le design sont simulés par la forme du Container
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Le cercle de profil centré
            Container(
              margin: const EdgeInsets.only(top: 50), // Ajustement pour centrer visuellement
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: neutralWhite,
                shape: BoxShape.circle,
                border: Border.all(color: primaryViolet, width: 4),
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: primaryViolet,
                  size: 45,
                ),
              ),
            ),
          ],
        ),
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

    return IgnorePointer(
      ignoring: !_isFormValid,
      child: Opacity(
        opacity: _isFormValid ? 1.0 : 0.5,
        child: InkWell(
          onTap: _isFormValid ? _submitForm : null,
          child: Container(
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
    TextEditingController? controller,
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
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'Champ requis';
            return null;
          },
          decoration: InputDecoration(
            // L'icône est positionnée à gauche du champ
            prefixIcon: Icon(icon, color: primaryViolet),
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: primaryViolet, width: 1.5),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: primaryViolet, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }
  
  // Widget spécifique pour le champ du mot de passe
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
          controller: _passwordController,
          // Masquer le texte du mot de passe
          obscureText: !_isPasswordVisible,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'Champ requis';
            return null;
          },
          decoration: InputDecoration(
            // Icône de verrouillage
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
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: primaryViolet, width: 1.5),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: primaryViolet, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }
}
