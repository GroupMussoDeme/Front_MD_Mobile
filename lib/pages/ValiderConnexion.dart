import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/widgets/primary_header.dart';
import 'package:musso_deme_app/pages/HomeScreen.dart'; // Import de la page d'accueil
import 'package:musso_deme_app/pages/Formations.dart';
import 'package:musso_deme_app/pages/DroitsScreens.dart';
import 'package:musso_deme_app/pages/NutritionScreen.dart';
import 'package:musso_deme_app/pages/FinancialAidScreen.dart';
import 'package:musso_deme_app/pages/RuralMarketScreen.dart';
import 'package:musso_deme_app/pages/HistoriquesDesCommandes.dart';
import 'package:musso_deme_app/pages/cooperative_page.dart';
import 'package:musso_deme_app/pages/ProfileScreen.dart';
import 'package:musso_deme_app/services/session_service.dart';

// --- Définition des couleurs de la Charte Graphique ---
const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;

const String ASSET_IMAGE_PATH = 'assets/images/image2.png';

class ValiderConnexion extends StatefulWidget {
  const ValiderConnexion({super.key});

  @override
  State<ValiderConnexion> createState() => _ValiderConnexionState();
}

class _ValiderConnexionState extends State<ValiderConnexion> {
  bool _isPasswordVisible = false;
  late AudioPlayer audioPlayer;
  bool _isKeypadVisible = false;
  TextEditingController? _currentController;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Fonction de rappel à exécuter lorsque le haut-parleur est cliqué
  void _playAudioInstruction(String fieldName) {
    // Arrêter toute lecture en cours
    audioPlayer.stop();
    
    print("DEMANDE AUDIO : Lecture de l'instruction pour le champ '$fieldName'");
  }

  // Méthode pour afficher le clavier numérique personnalisé
  void _showNumericKeypad(TextEditingController controller) {
    // Arrêter toute lecture en cours
    audioPlayer.stop();
    
    setState(() {
      _currentController = controller;
      _isKeypadVisible = true;
    });
    
    // Lecture en boucle de l'audio "clavierNumérique.aac" toutes les 2 secondes
    _playClavierAudioLoop();
  }
  
  // Méthode pour lire l'audio du clavier en boucle
  void _playClavierAudioLoop() async {
    if (!_isKeypadVisible) return;
    
    try {
      // Lecture de l'audio "clavierNumérique.aac"
      await audioPlayer.setAsset("assets/audios/clavierNumérique.aac");
      await audioPlayer.play();
      
      // Attendre 2 secondes
      await Future.delayed(const Duration(seconds: 2));
      
      // Relancer la lecture si le clavier est toujours visible
      if (_isKeypadVisible) {
        _playClavierAudioLoop();
      }
    } catch (e) {
      print("Erreur lors de la lecture de l'audio: $e");
    }
  }

  // Méthode pour masquer le clavier numérique personnalisé
  void _hideNumericKeypad() {
    setState(() {
      _isKeypadVisible = false;
      _currentController = null;
    });
    
    // Arrêt de la lecture audio
    audioPlayer.stop();
  }

  // Méthode pour ajouter un chiffre au champ de texte
  void _addDigit(String digit) {
    // Arrêter toute lecture audio en cours
    audioPlayer.stop();
    
    // Redirection vers différentes pages selon le chiffre entré
    switch (digit) {
      case '1':
        // Direction page formation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormationVideosPage()),
        );
        break;
      case '2':
        // Direction page DroitsDesFemmesScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DroitsDesFemmesScreen()),
        );
        break;
      case '3':
        // Direction page DroitsDesEnfantsScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DroitsDesEnfantsScreen()),
        );
        break;
      case '4':
        // Direction page ConseilsNouvellesMamansScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ConseilsNouvellesMamansScreen()),
        );
        break;
      case '5':
        // Direction page NutritionScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NutritionScreen()),
        );
        break;
      case '6':
        // Direction page FinancialAidScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FinancialAidScreen()),
        );
        break;
      case '7':
        // Direction page RuralMarketScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RuralMarketScreen()),
        );
        break;
      case '8':
        // Direction page OrderHistoryScreen (HistoriquesDesCommandes)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
        );
        break;
      case '9':
        // Direction page CooperativeTile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CooperativePage()),
        );
        break;
      case '0':
        // Direction page accueil
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case '*':
        // Direction page ProfileScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
      case '#':
        // Pour la déconnexion avec popup
        _showLogoutDialog();
        break;
      default:
        // Comportement par défaut pour les autres caractères
        if (_currentController != null) {
          _currentController!.text += digit;
          _currentController!.selection = TextSelection.fromPosition(
            TextPosition(offset: _currentController!.text.length),
          );
        }
        break;
    }
  }

  // Méthode pour supprimer le dernier chiffre
  void _backspace() {
    if (_currentController != null && _currentController!.text.isNotEmpty) {
      _currentController!.text = _currentController!.text.substring(0, _currentController!.text.length - 1);
      _currentController!.selection = TextSelection.fromPosition(
        TextPosition(offset: _currentController!.text.length),
      );
    }
  }

  // Méthode pour lire l'audio de déconnexion
  void _playLogoutAudio() async {
    try {
      await audioPlayer.setAsset("assets/audios/deconnexion.aac");
      await audioPlayer.play();
    } catch (e) {
      print("Erreur lors de la lecture de l'audio de déconnexion: $e");
    }
  }

  // Méthode pour afficher le popup de déconnexion
  void _showLogoutDialog() {
    // Lecture de l'audio de déconnexion
    audioPlayer.stop();
    
    // Lecture de l'audio "deconnexion.aac"
    _playLogoutAudio();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Souhaitez-vous vraiment vous déconnecter ?'),
          actions: [
            // Bouton d'annulation (rouge)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le popup
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cancel, color: Colors.red),
                  SizedBox(width: 5),
                  Text('Annuler'),
                ],
              ),
            ),
            // Bouton de validation (vert)
            TextButton(
              onPressed: () async {
                // Déconnexion de l'utilisateur
                await SessionService.clearSession();
                
                // Redirection vers la page de démarrage
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 5),
                  Text('Valider'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget pour le clavier numérique personnalisé
  Widget _buildNumericKeypad() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent, // Palette du clavier transparente
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ligne 1: 1, 2, 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('1', () => _addDigit('1')),
              _buildKeypadButton('2', () => _addDigit('2')),
              _buildKeypadButton('3', () => _addDigit('3')),
            ],
          ),
          const SizedBox(height: 10),
          
          // Ligne 2: 4, 5, 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('4', () => _addDigit('4')),
              _buildKeypadButton('5', () => _addDigit('5')),
              _buildKeypadButton('6', () => _addDigit('6')),
            ],
          ),
          const SizedBox(height: 10),
          
          // Ligne 3: 7, 8, 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('7', () => _addDigit('7')),
              _buildKeypadButton('8', () => _addDigit('8')),
              _buildKeypadButton('9', () => _addDigit('9')),
            ],
          ),
          const SizedBox(height: 10),
          
          // Ligne 4: *, 0, #
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('*', () => _addDigit('*')),
              _buildKeypadButton('0', () => _addDigit('0')),
              _buildKeypadButton('#', () => _addDigit('#')),
            ],
          ),
        ],
      ),
    );
  }

  // Widget pour un bouton du clavier numérique
  Widget _buildKeypadButton(String text, VoidCallback onPressed, {bool isSpecial = false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF491B6D), // Couleur #491B6D
        shape: const CircleBorder(), // Boutons en cercle
        padding: const EdgeInsets.all(20.0),
        minimumSize: const Size(70, 70),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white, // Chiffres en blanc
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
          // Clavier numérique personnalisé
          if (_isKeypadVisible)
            GestureDetector(
              onTap: _hideNumericKeypad,
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: GestureDetector(
                    onTap: () {}, // Empêche la fermeture lors du tap sur le clavier
                    child: _buildNumericKeypad(),
                  ),
                ),
              ),
            ),
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
                controller: label == "Téléphone" ? _phoneController : null,
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
                      : (label == "Téléphone" 
                          ? IconButton(
                              icon: const Icon(Icons.dialpad, color: primaryViolet),
                              onPressed: () {
                                _showNumericKeypad(_phoneController);
                              },
                            )
                          : null),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: primaryViolet),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: primaryViolet, width: 2.0),
                  ),
                ),
                onTap: label == "Téléphone" ? () {
                  _showNumericKeypad(_phoneController);
                } : null,
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