import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/CurvedIcon.dart';

class CurvedIconsDemo extends StatelessWidget {
  const CurvedIconsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Démonstration des Icônes Courbées'),
        backgroundColor: Color(0xFF5A2A82),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: const [
            CurvedIcon(
              text: 'Nutrition',
              icon: Icons.restaurant,
            ),
            CurvedIcon(
              text: 'Droits des enfants',
              icon: Icons.child_care,
            ),
            CurvedIcon(
              text: 'Conseils aux mamans',
              icon: Icons.pregnant_woman,
            ),
            CurvedIcon(
              text: 'Droits des femmes',
              icon: Icons.woman,
            ),
            CurvedIcon(
              text: 'Protection contre la violence',
              icon: Icons.shield,
            ),
            CurvedIcon(
              text: 'Coopératives',
              icon: Icons.group,
            ),
            CurvedIcon(
              text: 'Marchés',
              icon: Icons.store,
            ),
            CurvedIcon(
              text: 'Formations',
              icon: Icons.school,
            ),
            CurvedIcon(
              text: 'Aides aux financements',
              icon: Icons.money,
            ),
          ],
        ),
      ),
    );
  }
}