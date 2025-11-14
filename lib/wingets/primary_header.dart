import 'package:flutter/material.dart';

const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;

class PrimaryHeader extends StatelessWidget {
  final Widget logoChild;
  final bool showNotification;
  final double? height;
  final VoidCallback? onNotificationTap;

  const PrimaryHeader({
    super.key,
    required this.logoChild,
    this.showNotification = true,
    this.height,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double headerHeight = height ?? 100.0; 

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: screenWidth,
          height: headerHeight,
          decoration: const BoxDecoration(
            color: primaryViolet,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),

        // Icône notification
        showNotification
            ? Positioned(
                right: 15,
                top: 10,
                child: IconButton(
                  icon: const Icon(Icons.notifications_none,
                      color: neutralWhite, size: 28),
                  onPressed: onNotificationTap ?? () {},
                ),
              )
            : const SizedBox.shrink(),

        // 2. Le cercle de profil/logo
        Positioned(
          // Centré horizontalement
          left: 0,
          right: 0,
          // Positionné pour que le cercle déborde
          top: 55, 
          child: Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: neutralWhite,
                shape: BoxShape.circle,
                border: Border.all(color: primaryViolet, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              // --- Insertion du logo (Image) directement ---
              child: ClipOval( // Assurez-vous que l'image est bien coupée en cercle
                child: logoChild,
              ),
              // ------------------------------------------
            ),
          ),
        ),
      ],
    );
  }
}