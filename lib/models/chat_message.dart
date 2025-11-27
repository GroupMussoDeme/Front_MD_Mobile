import 'package:flutter/material.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final MessageType type;
  final String content;
  final DateTime timestamp;
  final bool isMe;
  final MessageStatus status;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.type,
    required this.content,
    required this.timestamp,
    required this.isMe,
    this.status = MessageStatus.sent,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    MessageType? type,
    String? content,
    DateTime? timestamp,
    bool? isMe,
    MessageStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      type: type ?? this.type,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
      status: status ?? this.status,
    );
  }
}

enum MessageType {
  text,
  image,
  audio,
  video,
  document,
  voice,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}