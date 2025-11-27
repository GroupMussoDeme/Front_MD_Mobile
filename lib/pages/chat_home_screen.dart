import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/chat_list.dart';
import 'package:musso_deme_app/pages/select_contact_screen.dart';

class ChatHomeScreen extends StatelessWidget {
  const ChatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: const TabBarView(
          children: [
            ChatList(),
            Center(
              child: Text('Statistiques'),
            ),
          ],
        ),
      ),
    );
  }
  
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('MussoDèmè'),
      backgroundColor: const Color(0xFF4A0072),
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // TODO: Implémenter la recherche
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // TODO: Implémenter les options du menu
          },
        ),
      ],
      bottom: const TabBar(
        tabs: [
          Tab(text: 'DISCUSSIONS'),
          Tab(text: 'STATISTIQUES'),
        ],
      ),
    );
  }
}