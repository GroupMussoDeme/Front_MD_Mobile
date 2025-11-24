import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/RightsBaseScreen.dart';
import 'package:musso_deme_app/pages/backend_audio_content_screen.dart';

/// Droits des femmes
class DroitsDesFemmesScreen extends StatelessWidget {
  const DroitsDesFemmesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackendAudioContentScreen(
      screenTitle: 'Droits des femmes',
      introMessage:
          'Bienvenue dans l\'espace droit des femmes.\nEcouter vos droits expliqués en Bambara.',
      typeInfo: 'DROITS_FEMMES',
      typeCategorie: 'AUDIOS',
      defaultIcon: Icons.favorite_border,
    );
  }
}


/// Droits des enfants
class DroitsDesEnfantsScreen extends StatelessWidget {
  const DroitsDesEnfantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackendAudioContentScreen(
      screenTitle: 'Droits des enfants',
      introMessage:
          'Bienvenue dans l\'espace droit des enfants.\nEcouter vos droits expliqués en Bambara.',
      typeInfo: 'DROITS_ENFANTS',
      typeCategorie: 'AUDIOS',
      defaultIcon: Icons.family_restroom,
    );
  }
}


/// Conseils aux nouvelles mamans
class ConseilsNouvellesMamansScreen extends StatelessWidget {
  const ConseilsNouvellesMamansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackendAudioContentScreen(
      screenTitle: 'Conseils aux nouvelles mamans',
      introMessage:
          'Bienvenue dans l\'espace santé de la femme.\nEcouter des conseils en Bambara.',
      typeInfo: 'CONSEILS_NOUVELLES_MAMANS',
      typeCategorie: 'AUDIOS',
      defaultIcon: Icons.pregnant_woman,
    );
  }
}


class ProtectionViolenceScreen extends StatelessWidget {
  const ProtectionViolenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RightsBaseScreen(
      typeInfo: 'PROTECTION_CONTRE_VIOLENCE',
      screenTitle: 'Protection contre la violence',
      introMessage:
          "Bienvenue dans l'espace de protection.\nEcouter des conseils en Bambara.",
      defaultIcon: Icons.shield_outlined,
    );
  }
}
