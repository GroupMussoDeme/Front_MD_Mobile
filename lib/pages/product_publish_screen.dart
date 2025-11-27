import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:musso_deme_app/models/marche_models.dart';
import 'package:musso_deme_app/services/femme_rurale_api.dart';
import 'package:musso_deme_app/services/auth_service.dart';
import 'package:musso_deme_app/services/session_service.dart';

class ProductPublishScreen extends StatefulWidget {
  final Produit? existingProduct;

  const ProductPublishScreen({super.key, this.existingProduct});

  @override
  _ProductPublishScreenState createState() => _ProductPublishScreenState();
}

class _ProductPublishScreenState extends State<ProductPublishScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _hasProductImage = false;
  File? _imageFile;

  // contrôleurs
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController(); // ✅ NOUVEAU

  FemmeRuraleApi? _api;
  bool _isSubmitting = false;
  bool _apiReady = false;

  @override
  void initState() {
    super.initState();
    _initApi();

    if (widget.existingProduct != null) {
      // MODE ÉDITION : pré-remplir avec les vraies valeurs
      final p = widget.existingProduct!;
      _productNameController.text = p.nom;
      _descriptionController.text = p.description ?? '';
      _priceController.text = p.prix != null ? p.prix!.toStringAsFixed(0) : '';
      _quantityController.text =
          p.quantite != null ? p.quantite!.toString() : '';
      _unitController.text = p.unite ?? ''; // ✅ pré-remplissage unité
      _hasProductImage = p.image != null && p.image!.isNotEmpty;
    } else {
      // MODE CRÉATION : champs vides, pas d’image
      _productNameController.text = '';
      _descriptionController.text = '';
      _priceController.text = '';
      _quantityController.text = '';
      _unitController.text = ''; // ✅
      _hasProductImage = false;
    }
  }

  Future<void> _initApi() async {
    final token = await SessionService.getAccessToken();
    final userId = await SessionService.getUserId();

    if (!mounted) return;

    if (token == null || token.isEmpty || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session expirée. Veuillez vous reconnecter.'),
        ),
      );
      return;
    }

    setState(() {
      _api = FemmeRuraleApi(
        baseUrl: AuthService.baseUrl,
        token: token,
        femmeId: userId,
      );
      _apiReady = true;
    });
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _unitController.dispose(); // ✅ libération
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        _hasProductImage = true;
      });
    }
  }

  Future<void> _submitProduct() async {
    if (!_apiReady || _api == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Service non prêt. Réessayez dans un instant.'),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    // L’image est obligatoire côté backend (NotBlank sur "image")
    final existingImageName = widget.existingProduct?.image;
    final hasExistingImage =
        existingImageName != null && existingImageName.isNotEmpty;

    if (_imageFile == null && !hasExistingImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez ajouter une photo du produit.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Prix
      final double? prix = double.tryParse(
        _priceController.text.replaceAll(',', '.'),
      );

      if (prix == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prix invalide.')),
        );
        setState(() => _isSubmitting = false);
        return;
      }

      // Quantité
      final int? quantite = int.tryParse(_quantityController.text.trim());
      if (quantite == null || quantite <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Quantité invalide. Veuillez saisir un entier > 0.'),
          ),
        );
        setState(() => _isSubmitting = false);
        return;
      }

      // Unité (optionnelle, mais nettoyée)
      final String uniteText = _unitController.text.trim();
      final String? unite =
          uniteText.isEmpty ? null : uniteText; // ✅ on envoie null si vide

      // 1) Gérer le nom de fichier de l’image
      String? imageName = existingImageName;

      // Si une nouvelle image est choisie, on l’upload
      if (_imageFile != null) {
        imageName = await _api!.uploadProduitImage(_imageFile!);
      }

      // 2) Appel API : création ou édition
      final String nom = _productNameController.text.trim();
      final String description = _descriptionController.text.trim();

      late Produit saved;
      final bool isEdit = widget.existingProduct != null;

      if (!isEdit) {
        // CRÉATION
        saved = await _api!.publierProduit(
          nom: nom,
          description: description,
          prix: prix,
          quantite: quantite,
          typeProduit: 'ALIMENTAIRE', // valeur par défaut
          image: imageName,
          audioGuideUrl: null,
          unite: unite, // ✅ ENVOI DE L’UNITÉ
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit publié avec succès')),
        );
      } else {
        // ÉDITION
        final existing = widget.existingProduct!;

        saved = await _api!.modifierProduit(
          produitId: existing.id!,
          nom: nom,
          description: description,
          prix: prix,
          quantite: quantite,
          typeProduit: existing.typeProduit ?? 'ALIMENTAIRE',
          image: imageName,
          audioGuideUrl: null,
          unite: unite, // ✅ ENVOI DE L’UNITÉ
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit modifié avec succès')),
        );
      }

      // On retourne le produit sauvegardé à l’écran précédent
      if (mounted) {
        Navigator.pop(context, saved);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color neutralWhite = Colors.white;
    const Color primaryColor = Color(0xFF491B6D);

    final isEdit = widget.existingProduct != null;

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
                      Expanded(
                        child: Text(
                          isEdit ? 'Modifier produit' : 'Publier produit',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: neutralWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_none,
                          color: neutralWhite,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Contenu
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
                      _buildImageSection(primaryColor),
                      const SizedBox(height: 30),

                      // Nom produit
                      _buildInputField(
                        context,
                        controller: _productNameController,
                        labelText: 'Nom du produit',
                        icon: Icons.volume_up,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Veuillez entrer le nom du produit'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Description
                      _buildInputField(
                        context,
                        controller: _descriptionController,
                        labelText: 'Description',
                        maxLines: 3,
                        icon: Icons.volume_up,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Veuillez entrer une description'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Quantité en stock
                      _buildInputField(
                        context,
                        controller: _quantityController,
                        labelText: 'Quantité en stock',
                        keyboardType: TextInputType.number,
                        icon: Icons.inventory_2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer la quantité';
                          }
                          final q = int.tryParse(value);
                          if (q == null || q <= 0) {
                            return 'La quantité doit être un entier > 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // ✅ Unité (champ texte libre)
                      _buildInputField(
                        context,
                        controller: _unitController,
                        labelText: 'Unité (kg, litre, sachet…)',
                        keyboardType: TextInputType.text,
                        icon: Icons.scale, // ou autres
                        // validator: (value) => null, // optionnel (non obligatoire)
                      ),
                      const SizedBox(height: 20),

                      // Prix
                      _buildInputField(
                        context,
                        controller: _priceController,
                        labelText: 'Prix (FCFA)',
                        keyboardType: TextInputType.number,
                        icon: Icons.volume_up,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Veuillez entrer le prix'
                            : null,
                      ),
                      const SizedBox(height: 40),

                      Center(
                        child: _hasProductImage
                            ? _buildPublishButton(primaryColor)
                            : _buildVoiceRecordButton(primaryColor),
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

  // ================== WIDGETS PRIVÉS ==================

  Widget _buildImageSection(Color primaryColor) {
    final existingImageUrl = widget.existingProduct?.image;

    Widget content;

    if (_imageFile != null) {
      // image choisie pendant cette session
      content = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          _imageFile!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 180,
        ),
      );
    } else if (existingImageUrl != null && existingImageUrl.isNotEmpty) {
      // image déjà connue du produit (en édition)
      final url = existingImageUrl.startsWith('http')
          ? existingImageUrl
          : 'http://10.0.2.2:8080/uploads/$existingImageUrl';

      content = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 180,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(
              Icons.broken_image,
              color: primaryColor,
              size: 60,
            ),
          ),
        ),
      );
    } else {
      // état initial : bloc d’upload (pas d’image par défaut)
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 80,
            color: primaryColor,
          ),
          const SizedBox(height: 10),
          const Text(
            'Cliquez pour uploader une image',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ajouter la photo du produit',
              style: TextStyle(fontSize: 16),
            ),
            Icon(Icons.volume_up, color: primaryColor, size: 20),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryColor, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: content,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildPublishButton(Color primaryColor) {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : _submitProduct,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(30),
        backgroundColor: primaryColor,
      ),
      child: _isSubmitting
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(
              Icons.check,
              color: Colors.white,
              size: 50,
            ),
    );
  }

  Widget _buildVoiceRecordButton(Color primaryColor) {
    // Placeholder pour l’enregistrement vocal
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enregistrement vocal démarré...'),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(30),
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
