import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/GroupCallScreen.dart';
import 'package:musso_deme_app/pages/GroupInfoScreen.dart';
import 'package:musso_deme_app/pages/Notifications.dart';
import 'package:musso_deme_app/pages/chat_home_screen.dart';

const Color _kPrimaryPurple = Color(0xFF4A0072);
const Color _kLightPurple = Color(0xFFEAE1F4);
const Color _kBackgroundColor = Colors.white;

// --- WIDGET PRINCIPAL : ÉCRAN DE CHAT DE GROUPE ---
class GroupChatScreen extends StatelessWidget {
  final int? cooperativeId;
  final String? cooperativeNom;

  const GroupChatScreen({
    super.key,
    this.cooperativeId,
    this.cooperativeNom,
  });

  @override
  Widget build(BuildContext context) {
    final String titreGroupe = cooperativeNom ?? 'MussoDèmè';

    return Scaffold(
      backgroundColor: _kBackgroundColor,

      // 1. AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
            color: _kPrimaryPurple,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  // Icône de retour
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Image de profil du groupe/contact
                  const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/cooperative.png'),
                    radius: 18,
                  ),
                  const SizedBox(width: 10),
                  // Nom du groupe
                  Text(
                    titreGroupe,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Icône Notification
                  IconButton(
                    icon: const Icon(Icons.notifications_none,
                        color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  // Icône Vidéo
                  IconButton(
                    icon: const Icon(Icons.videocam,
                        color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GroupCallScreen(),
                        ),
                      );
                    },
                  ),
                  // Icône Appel
                  IconButton(
                    icon: const Icon(Icons.call, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GroupCallScreen(),
                        ),
                      );
                    },
                  ),
                  // Menu
                  IconButton(
                    icon: const Icon(Icons.more_vert,
                        color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupInfoScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // 2. Corps : Liste des messages vocaux (statique pour l’instant)
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12.0),
              children: const [
                VoiceMessageBubble(
                  sender: 'Aïssata',
                  isMe: false,
                  avatarUrl: 'assets/images/Ellipse 77.png',
                  duration: '0:20',
                  time: '11:14 AM',
                ),
                VoiceMessageBubble(
                  sender: 'Koumba',
                  isMe: false,
                  avatarUrl: 'assets/images/Ellipse 77.png',
                  duration: '1:07',
                  time: '11:15 AM',
                ),
                VoiceMessageBubble(
                  sender: '',
                  isMe: false,
                  avatarUrl: 'assets/images/Ellipse 77.png',
                  duration: '0:15',
                  time: '11:16 AM',
                ),
                VoiceMessageBubble(
                  sender: 'Aïssata',
                  isMe: false,
                  avatarUrl: 'assets/images/Ellipse 77.png',
                  duration: '0:35',
                  time: '11:17 AM',
                ),
                VoiceMessageBubble(
                  sender: '',
                  isMe: true,
                  avatarUrl: 'assets/images/Ellipse 77.png',
                  duration: '0:45',
                  time: '11:18 AM',
                ),
              ],
            ),
          ),

          // 3. Barre de saisie
          const ChatInputBar(),
        ],
      ),
    );
  }
}

// --- BULLE DE MESSAGE VOCAL ---
class VoiceMessageBubble extends StatelessWidget {
  final String sender;
  final String avatarUrl;
  final bool isMe;
  final String duration;
  final String time;

  const VoiceMessageBubble({
    super.key,
    required this.sender,
    required this.avatarUrl,
    required this.isMe,
    this.duration = '0:20',
    this.time = '11:14 AM',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(avatarUrl),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe && sender.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, bottom: 4.0),
                    child: Text(
                      sender,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                Container(
                  margin: EdgeInsets.only(
                    left: isMe ? 50.0 : 0.0,
                    right: isMe ? 0.0 : 50.0,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isMe ? _kLightPurple : Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: isMe ? _kLightPurple : Colors.grey.shade300,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: _kPrimaryPurple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: 120,
                        height: 30,
                        child: CustomPaint(
                          painter:
                              WaveformPainter(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        duration,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Icon(
                        Icons.mic,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, left: 8.0, right: 8.0),
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMe)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(avatarUrl),
              ),
            ),
        ],
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final Color color;

  WaveformPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final double barWidth = 3.0;
    final double spacing = 4.0;

    final List<double> heights = [
      0.3,
      0.6,
      0.9,
      0.7,
      0.5,
      0.8,
      1.0,
      0.6,
      0.4,
      0.7,
      0.9,
      0.5,
      0.3,
      0.6,
      0.8
    ];

    for (int i = 0; i < heights.length; i++) {
      final double x = i * (barWidth + spacing);
      final double barHeight = size.height * heights[i];
      final double y = (size.height - barHeight) / 2;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          const Radius.circular(1.0),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- BARRE DE SAISIE DE MESSAGE ---
class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.tag_faces, color: Colors.grey),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: _kLightPurple,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(top: 12, bottom: 12),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.grey),
            onPressed: () {},
          ),
          Container(
            margin: const EdgeInsets.only(left: 4.0),
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: _kPrimaryPurple,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mic,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
