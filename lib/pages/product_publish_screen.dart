import 'package:flutter/material.dart';

class ProductPublishScreen extends StatefulWidget {
  const ProductPublishScreen({super.key});

  @override
  _ProductPublishScreenState createState() => _ProductPublishScreenState();
}

class _ProductPublishScreenState extends State<ProductPublishScreen> {
  // Clé pour gérer l'état du formulaire et la validation
  final _formKey = GlobalKey<FormState>(); 
  // État pour simuler la présence ou l'absence d'une image
  bool _hasProductImage = false; 

  // Contrôleurs de texte
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Simulation des données pré-remplies du 2ème design
    _productNameController.text = 'Beurre de Karité';
    _descriptionController.text = 
        'Le beurre de karité est une matière grasse naturelle extraite des noix de l\'arbre de karité, originaire d\'Afrique de l\'Ouest.';
    _priceController.text = '1000 FCFA';
    _hasProductImage = true; // L'image est présente
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Fonction de soumission (à implémenter)
  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      // Les champs sont valides, procéder à la publication
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produit publié avec succès !')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // La couleur primaire violette des designs
    final Color primaryColor = Color(0xFF491B6D);
    const Color neutralWhite = Colors.white;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Stack(
        children: [
          // Header violet arrondi
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFF491B6D),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: neutralWhite),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Publier produit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: neutralWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: neutralWhite),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Contenu scrollable
          Positioned.fill(
            top: 100,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // --- Section d'ajout de photo de produit ---
                      _buildImageSection(primaryColor),
                      const SizedBox(height: 30),

                      // --- Champ Nom du produit ---
                      _buildInputField(
                        context,
                        controller: _productNameController,
                        labelText: 'Nom du produit',
                        icon: Icons.volume_up, // Icône de son pour l'accessibilité
                        validator: (value) => value!.isEmpty ? 'Veuillez entrer le nom du produit' : null,
                      ),
                      const SizedBox(height: 20),

                      // --- Champ Description ---
                      _buildInputField(
                        context,
                        controller: _descriptionController,
                        labelText: 'Description',
                        maxLines: 3,
                        icon: Icons.volume_up,
                        validator: (value) => value!.isEmpty ? 'Veuillez entrer une description' : null,
                      ),
                      const SizedBox(height: 20),

                      // --- Champ Prix ---
                      _buildInputField(
                        context,
                        controller: _priceController,
                        labelText: 'Prix',
                        keyboardType: TextInputType.number, // Clavier numérique
                        icon: Icons.volume_up,
                        validator: (value) => value!.isEmpty ? 'Veuillez entrer le prix' : null,
                      ),
                      const SizedBox(height: 40),

                      // --- Section du bouton de validation ou d'enregistrement vocal ---
                      Center(
                        child: _hasProductImage
                            ? _buildPublishButton(primaryColor) // 2ème design (rempli)
                            : _buildVoiceRecordButton(primaryColor), // 1er design (vide)
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour la section Image
  Widget _buildImageSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ajouter la photo du produits', style: TextStyle(fontSize: 16)),
            Icon(Icons.volume_up, color: primaryColor, size: 20),
          ],
        ),
        const SizedBox(height: 8),
        // Conteneur pour l'image (simulé)
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _hasProductImage ? null : primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: _hasProductImage ? null : Border.all(color: primaryColor, width: 1.5),
          ),
          child: _hasProductImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/karite_butter.jpg', // Remplacer par votre asset réel
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 80,
                    color: primaryColor,
                  ),
                ),
        ),
      ],
    );
  }

  // Widget réutilisable pour les champs de saisie
  Widget _buildInputField(
    BuildContext context, {
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    // Utilisation d'un Row pour placer l'Input en face de l'icône de son
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(
              labelText: labelText,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        ),
      ],
    );
  }

  // Bouton de publication (visible lorsque le formulaire est rempli - 2ème design)
  Widget _buildPublishButton(Color primaryColor) {
    return ElevatedButton(
      onPressed: _submitProduct,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(30),
        backgroundColor: primaryColor,
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 50,
      ),
    );
  }

  // Bouton d'enregistrement vocal (visible lorsque le formulaire est vide - 1er design)
  Widget _buildVoiceRecordButton(Color primaryColor) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enregistrement vocal démarré...')),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(30),
        backgroundColor: primaryColor.withOpacity(0.1),
      ),
      child: Icon(
        Icons.mic,
        color: primaryColor,
        size: 50,
      ),
    );
  }
}