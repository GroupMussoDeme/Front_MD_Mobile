import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:musso_deme_app/models/chat_message.dart';

class ChatService with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final String _groupId;
  
  ChatService(this._groupId);

  List<ChatMessage> get messages => _messages;

  // Stream controller pour les nouveaux messages
  final StreamController<ChatMessage> _messageController = StreamController<ChatMessage>.broadcast();
  Stream<ChatMessage> get onMessageReceived => _messageController.stream;

  // Envoyer un message texte
  Future<void> sendTextMessage(String text, {String? senderId, String? senderName, String? senderAvatar}) async {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId ?? 'current_user',
      senderName: senderName ?? 'Moi',
      senderAvatar: senderAvatar,
      type: MessageType.text,
      content: text,
      timestamp: DateTime.now(),
      isMe: true,
      status: MessageStatus.sending,
    );

    // Ajouter le message à la liste
    _messages.add(message);
    notifyListeners();

    // Simuler l'envoi au serveur
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mettre à jour le statut du message
    final index = _messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      _messages[index] = message.copyWith(status: MessageStatus.sent);
      notifyListeners();
    }

    // Simuler une réponse du serveur
    await Future.delayed(const Duration(seconds: 1));
    _simulateServerResponse(text);
  }

  // Envoyer un message vocal
  Future<void> sendVoiceMessage(String filePath, Duration duration, {String? senderId, String? senderName, String? senderAvatar}) async {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId ?? 'current_user',
      senderName: senderName ?? 'Moi',
      senderAvatar: senderAvatar,
      type: MessageType.voice,
      content: filePath,
      timestamp: DateTime.now(),
      isMe: true,
      status: MessageStatus.sending,
    );

    _messages.add(message);
    notifyListeners();

    // Simuler l'envoi au serveur
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      _messages[index] = message.copyWith(status: MessageStatus.sent);
      notifyListeners();
    }
  }

  // Envoyer un fichier média
  Future<void> sendMediaMessage(String filePath, MessageType type, {String? senderId, String? senderName, String? senderAvatar}) async {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId ?? 'current_user',
      senderName: senderName ?? 'Moi',
      senderAvatar: senderAvatar,
      type: type,
      content: filePath,
      timestamp: DateTime.now(),
      isMe: true,
      status: MessageStatus.sending,
    );

    _messages.add(message);
    notifyListeners();

    // Simuler l'envoi au serveur
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      _messages[index] = message.copyWith(status: MessageStatus.sent);
      notifyListeners();
    }
  }

  // Simuler une réponse du serveur
  void _simulateServerResponse(String originalMessage) {
    final responses = {
      'salut': 'Bonjour! Comment allez-vous?',
      'bonjour': 'Salut! Comment ça va?',
      'ça va': 'Je vais bien, merci! Et vous?',
      'merci': 'De rien! Puis-je vous aider avec quelque chose d\'autre?',
      'hello': 'Hi there! How can I help you today?',
      'hi': 'Hello! Nice to meet you!',
    };

    final lowerMessage = originalMessage.toLowerCase();
    String responseText = 'Merci pour votre message!';
    
    for (var entry in responses.entries) {
      if (lowerMessage.contains(entry.key)) {
        responseText = entry.value;
        break;
      }
    }

    final responseMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'server',
      senderName: 'MussoDèmè',
      senderAvatar: 'assets/images/cooperative.png',
      type: MessageType.text,
      content: responseText,
      timestamp: DateTime.now(),
      isMe: false,
      status: MessageStatus.delivered,
    );

    _messages.add(responseMessage);
    _messageController.add(responseMessage);
    notifyListeners();
  }

  // Obtenir les messages triés par timestamp
  List<ChatMessage> getSortedMessages() {
    final sortedMessages = List<ChatMessage>.from(_messages);
    sortedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return sortedMessages;
  }

  // Libérer les ressources
  void dispose() {
    _messageController.close();
    super.dispose();
  }

  // Méthode pour charger l'historique des messages
  Future<void> loadMessageHistory() async {
    // Simuler le chargement de l'historique
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Ajouter quelques messages d'exemple
    if (_messages.isEmpty) {
      _messages.addAll([
        ChatMessage(
          id: '1',
          senderId: 'user1',
          senderName: 'Aïssata',
          senderAvatar: 'assets/images/Ellipse 77.png',
          type: MessageType.text,
          content: 'Bonjour tout le monde!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          isMe: false,
        ),
        ChatMessage(
          id: '2',
          senderId: 'user2',
          senderName: 'Koumba',
          senderAvatar: 'assets/images/Ellipse 77.png',
          type: MessageType.text,
          content: 'Bienvenue dans le groupe MussoDèmè!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
          isMe: false,
        ),
        ChatMessage(
          id: '3',
          senderId: 'current_user',
          senderName: 'Moi',
          type: MessageType.text,
          content: 'Merci! Je suis heureuse d\'être ici.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
          isMe: true,
        ),
      ]);
      notifyListeners();
    }
  }
}