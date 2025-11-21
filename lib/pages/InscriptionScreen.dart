import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/LoginScreen.dart';
import 'package:musso_deme_app/wingets/primary_header.dart';
import 'package:musso_deme_app/services/auth_service.dart';

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
  bool _isPasswordVisible = false;
  bool _isFormValid = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _localiteController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomController.addListener(_validateForm);
    _prenomController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _localiteController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _validateForm();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _phoneController.dispose();
    _localiteController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final nomOk = _nomController.text.trim().isNotEmpty;
    final prenomOk = _prenomController.text.trim().isNotEmpty;
    final phoneOk =
        RegExp(r'^\+?[0-9]{7,15}$').hasMatch(_phoneController.text.trim());
    final localiteOk = _localiteController.text.trim().isNotEmpty;
    final passwordOk = _passwordController.text.trim().length >= 4;

    final valid = nomOk && prenomOk && phoneOk && localiteOk && passwordOk;
    if (valid != _isFormValid) {
      setState(() {
        _isFormValid = valid;
      });
    }
  }

  Future<void> _submitForm() async {
    print('🔸 _submitForm() appelé (Inscription)');

    final formValid = _formKey.currentState?.validate() ?? false;
    print('🔸 formValid = $formValid');

    if (!formValid) {
      print('🔸 Formulaire inscription invalide, annulation');
      return;
    }

    setState(() => _isLoading = true);

    final response = await AuthService.registerUser(
      nom: _nomController.text,
      prenom: _prenomController.text,
      telephone: _phoneController.text,
      localite: _localiteController.text,
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    print('🔸 Réponse inscription: $response');

    if (response["status"] == 200 || response["status"] == 201) {
      // Inscription OK -> aller à l’écran de connexion
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      final message =
          response["data"]["message"] ?? "Inscription impossible, veuillez réessayer";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $message")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget logoImage = Image.asset(
      InscriptionScreen.LOGO_ASSET_PATH,
      fit: BoxFit.cover,
    );

    return Scaffold(
      backgroundColor: neutralWhite,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            PrimaryHeader(
              logoChild: logoImage,
              showNotification: false,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildInscriptionButton(),
                    const SizedBox(height: 30),
                    _buildTextField(
                      label: "Nom",
                      icon: Icons.person_outline,
                      controller: _nomController,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: "Prenom",
                      icon: Icons.person_outline,
                      controller: _prenomController,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: "Téléphone",
                      icon: Icons.call_outlined,
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: "Localité",
                      icon: Icons.location_on_outlined,
                      controller: _localiteController,
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordTextField(),
                    const SizedBox(height: 50),

                    // L’ICÔNE JOUE ICI LE RÔLE DE BOUTON D’INSCRIPTION
                    Center(
                      child: GestureDetector(
                        onTap: (!_isFormValid || _isLoading)
                            ? null
                            : _submitForm,
                        child: Opacity(
                          opacity: _isFormValid ? 1.0 : 0.5,
                          child: const Icon(
                            Icons.hearing,
                            color: primaryViolet,
                            size: 80,
                          ),
                        ),
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

  Widget _buildInscriptionButton() {
    const Gradient inscriptionGradient = LinearGradient(
      colors: [Color(0xFF8A2BE2), primaryViolet],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return IgnorePointer(
      ignoring: !_isFormValid || _isLoading,
      child: Opacity(
        opacity: _isFormValid ? 1.0 : 0.5,
        child: InkWell(
          onTap: _isFormValid && !_isLoading ? _submitForm : null,
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
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(neutralWhite),
                    )
                  : const Text(
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
            if (value == null || value.trim().isEmpty) {
              return 'Champ requis';
            }
            if (label == "Téléphone") {
              final v = value.trim();
              if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(v)) {
                return 'Numéro invalide';
              }
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: primaryViolet),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
          obscureText: !_isPasswordVisible,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Mot de passe requis';
            }
            if (value.length < 4) {
              return 'Le mot de passe doit contenir au moins 4 caractères';
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, color: primaryViolet),
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
