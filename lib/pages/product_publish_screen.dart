import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:musso_deme_app/models/marche_models.dart';
import 'package:musso_deme_app/services/femme_rurale_api.dart';

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

  final FemmeRuraleApi _api = FemmeRuraleApi();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    if (widget.existingProduct != null) {
      // MODE ÉDITION : pré-remplir avec les vraies valeurs
      final p = widget.existingProduct!;
      _productNameController.text = p.nom;
      _descriptionController.text = p.description ?? '';
      _priceController.text =
          p.prix != null ? p.prix!.toStringAsFixed(0) : '';
      _hasProductImage = p.image != null && p.image!.isNotEmpty;
    } else {
      // MODE CRÉATION : champs vides, pas d’image
      _productNameController.text = '';
      _descriptionController.text = '';
      _priceController.text = '';
      _hasProductImage = false;
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final double? prix =
          double.tryParse(_priceController.text.replaceAll(',', '.'));

      final produit = Produit(
        id: widget.existingProduct?.id,
        nom: _productNameController.text,
        description: _descriptionController.text,
        prix: prix,
        quantite: widget.existingProduct?.quantite ?? 1,
        typeProduit:
            widget.existingProduct?.typeProduit ?? 'ALIMENTAIRE',
        image: widget.existingProduct?.image,
        // NOTE : toujours pas d’upload fichier → l’URL/nom d’image est géré côté backend
        femmeRuraleId: widget.existingProduct?.femmeRuraleId,
      );

      late Produit saved;

      if (widget.existingProduct == null) {
        // création
        saved = await _api.publierProduit(produit: produit);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit publié avec succès')),
        );
      } else {
        // édition
        saved = await _api.modifierProduit(
          produitId: widget.existingProduct!.id!,
          produit: produit,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit modifié avec succès')),
        );
      }

      Navigator.pop(context, saved);
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: neutralWhite),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          isEdit
                              ? 'Modifier produit'
                              : 'Publier produit',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: neutralWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none,
                            color: neutralWhite),
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
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildImageSection(primaryColor),
                      const SizedBox(height: 30),

                      _buildInputField(
                        context,
                        controller: _productNameController,
                        labelText: 'Nom du produit',
                        icon: Icons.volume_up,
                        validator: (value) => value == null ||
                                value.isEmpty
                            ? 'Veuillez entrer le nom du produit'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      _buildInputField(
                        context,
                        controller: _descriptionController,
                        labelText: 'Description',
                        maxLines: 3,
                        icon: Icons.volume_up,
                        validator: (value) => value == null ||
                                value.isEmpty
                            ? 'Veuillez entrer une description'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      _buildInputField(
                        context,
                        controller: _priceController,
                        labelText: 'Prix',
                        keyboardType: TextInputType.number,
                        icon: Icons.volume_up,
                        validator: (value) => value == null ||
                                value.isEmpty
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
    } else if (existingImageUrl != null &&
        existingImageUrl.isNotEmpty) {
      // image déjà connue du produit (en édition)
      content = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          existingImageUrl,
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
      // état initial : bloc d’upload
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
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ajouter la photo du produits',
              style: TextStyle(fontSize: 16),
            ),
            Icon(Icons.volume_up,
                color: primaryColor, size: 20),
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
              border:
                  Border.all(color: primaryColor, width: 1.5),
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
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 15),
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
          child: Icon(icon,
              color: Theme.of(context).primaryColor, size: 20),
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
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Enregistrement vocal démarré...')),
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
