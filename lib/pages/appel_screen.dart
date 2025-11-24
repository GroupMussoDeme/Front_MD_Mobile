// lib/pages/appel_screen.dart
import 'package:flutter/material.dart';
import 'package:musso_deme_app/models/institution.dart';

const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;
const Color darkGrey = Color(0xFF707070);
const Color callEndRed = Color(0xFFD32F2F);

class CallActionButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final double size;

  const CallActionButton({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: neutralWhite, size: size * 0.5),
        onPressed: onPressed,
      ),
    );
  }
}

class AppelScreen extends StatelessWidget {
  final InstitutionFinanciere institution;

  const AppelScreen({super.key, required this.institution});

  @override
  Widget build(BuildContext context) {
    final String contactName = institution.nom;
    final String tel = institution.numeroTel.isNotEmpty
        ? institution.numeroTel
        : 'Numéro non renseigné';

    return Scaffold(
      backgroundColor: neutralWhite,
      appBar: null,
      body: Stack(
        children: [
          // Header violet
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                color: primaryViolet,
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
                          'Appel en cours... "$contactName"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: neutralWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
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
          // Contenu principal
          Positioned.fill(
            top: 100,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contactName,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const Text(
                                  "Appel",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: darkGrey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  tel,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: darkGrey,
                                  ),
                                ),
                              ],
                            ),
                            const CircleAvatar(
                              radius: 25,
                              backgroundColor: primaryViolet,
                              child: Icon(Icons.person_outline,
                                  color: neutralWhite, size: 30),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: primaryViolet.withOpacity(0.5),
                              width: 2),
                          color: Colors.white,
                        ),
                        child: const Center(
                          child: Icon(Icons.house_outlined,
                              color: primaryViolet, size: 60),
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        "00:45",
                        style: TextStyle(fontSize: 20, color: darkGrey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30, horizontal: 20),
                  decoration: const BoxDecoration(
                    color: primaryViolet,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CallActionButton(
                        icon: Icons.volume_up,
                        backgroundColor: neutralWhite.withOpacity(0.2),
                        onPressed: () {},
                        size: 65,
                      ),
                      CallActionButton(
                        icon: Icons.mic_off,
                        backgroundColor: neutralWhite.withOpacity(0.2),
                        onPressed: () {},
                        size: 65,
                      ),
                      CallActionButton(
                        icon: Icons.call_end,
                        backgroundColor: callEndRed,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        size: 65,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
