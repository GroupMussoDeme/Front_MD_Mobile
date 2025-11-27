import 'package:flutter/material.dart';

class Contact {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? profileImage;
  final bool isOnline;
  final String? lastSeen;
  final bool isFavorite;

  Contact({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.profileImage,
    this.isOnline = false,
    this.lastSeen,
    this.isFavorite = false,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? profileImage,
    bool? isOnline,
    String? lastSeen,
    bool? isFavorite,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}