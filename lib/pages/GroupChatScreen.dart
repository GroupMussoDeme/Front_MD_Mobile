// lib/pages/GroupChatScreen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'package:musso_deme_app/pages/GroupCallScreen.dart';
import 'package:musso_deme_app/pages/GroupInfoScreen.dart';
import 'package:musso_deme_app/pages/Notifications.dart';
import 'package:musso_deme_app/models/marche_models.dart'; // Cooperative, ChatVocal
import 'package:musso_deme_app/services/femme_rurale_api.dart';
import 'package:musso_deme_app/services/auth_service.dart';
import 'package:musso_deme_app/services/session_service.dart';

const Color _kPrimaryPurple = Color(0xFF4A0072);
const Color _kLightPurple = Color(0xFFEAE1F4);
const Color _kBackgroundColor = Colors.white;

// ===================== ÉCRAN DE CHAT DE GROUPE (DYNAMIQUE) =====================

class GroupChatScreen extends StatefulWidget {
  final Cooperative cooperative;

  const GroupChatScreen({
    super.key,
    required this.cooperative,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  FemmeRuraleApi? _api;
  int? _currentUserId;

  bool _isLoading = true;
  bool _isSending = false;
  String? _errorMessage;

  List<ChatVocal> _messages = [];

  // --- Enregistrement audio (nouvelle API) ---
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _currentRecordPath;

  // --- Saisie texte (SMS) ---
  final TextEditingController _textController = TextEditingController();

  int get _cooperativeId => widget.cooperative.id!; // on suppose non nul

  @override
  void initState() {
    super.initState();
    _initApiAndLoadMessages();
  }

  @override
  void dispose() {
    _recorder.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _initApiAndLoadMessages() async {
    print('[UI] init GroupChatScreen coop=$_cooperativeId');
    try {
      final token = await SessionService.getAccessToken();
      final userId = await SessionService.getUserId();
      print('[UI] token=${token != null} userId=$userId');

      if (token == null || token.isEmpty || userId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Session expirée. Veuillez vous reconnecter.';
        });
        return;
      }

      final api = FemmeRuraleApi(
        baseUrl: AuthService.baseUrl,
        token: token,
        femmeId: userId,
      );
      print('[UI] FemmeRuraleApi.baseUrl = ${AuthService.baseUrl}');

      final messages = await api.getMessagesCooperative(
        cooperativeId: _cooperativeId,
      );

      setState(() {
        _api = api;
        _currentUserId = userId;
        _messages = messages;
        _isLoading = false;
        _errorMessage = null;
      });

      print('[UI] Messages chargés: ${_messages.length}');
    } catch (e) {
      print('[UI] Erreur _initApiAndLoadMessages: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erreur chargement messages : $e';
      });
    }
  }

  /// Rafraîchit la liste des messages depuis le backend
  Future<void> _refreshMessages() async {
    final api = _api;
    if (api == null) return;
    try {
      print('[UI] _refreshMessages() coop=$_cooperativeId');
      final messages = await api.getMessagesCooperative(
        cooperativeId: _cooperativeId,
      );

      setState(() {
        _messages = messages;
        _errorMessage = null;
      });

      print('[UI] Messages après refresh: ${_messages.length}');
    } catch (e) {
      print('[UI] Erreur _refreshMessages: $e');
      setState(() {
        _errorMessage = 'Erreur rafraîchissement messages : $e';
      });
    }
  }

  // ===================== GESTION ENREGISTREMENT VOCAL =====================

  Future<void> _startRecording() async {
    final api = _api;
    if (api == null) {
      print('[UI] _startRecording: API null');
      return;
    }

    final hasPermission = await _recorder.hasPermission();
    print('[UI] _startRecording: hasPermission=$hasPermission');

    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission microphone refusée'),
          ),
        );
      }
      return;
    }

    final dir = await getTemporaryDirectory();
    final filePath =
        '${dir.path}/coop_${_cooperativeId}_${DateTime.now().millisecondsSinceEpoch}.m4a';

    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
    );

    print('[UI] _startRecording: path=$filePath');
    await _recorder.start(
      config,
      path: filePath,
    );

    setState(() {
      _isRecording = true;
      _currentRecordPath = filePath;
    });
  }

  Future<void> _stopRecordingAndSend() async {
    final api = _api;
    if (api == null) {
      print('[UI] _stopRecordingAndSend: API null');
      return;
    }

    try {
      final path = await _recorder.stop();
      print('[UI] _stopRecordingAndSend: path=$path');

      setState(() {
        _isRecording = false;
      });

      if (path == null || !File(path).existsSync()) {
        print('[UI] Fichier audio inexistant');
        return;
      }

      setState(() {
        _isSending = true;
      });

      // 1) Upload du fichier audio vers le backend pour obtenir une URL
      final audioUrl = await api.uploadCoopAudio(
        cooperativeId: _cooperativeId,
        filePath: path,
      );
      print('[UI] uploadCoopAudio OK, audioUrl=$audioUrl');

      // 2) Envoi du message vocal avec cette URL
      await api.envoyerMessageCooperative(
        cooperativeId: _cooperativeId,
        audioUrl: audioUrl,
      );
      print('[UI] envoyerMessageCooperative OK');

      // 3) Rechargement des messages
      await _refreshMessages();
    } catch (e) {
      print('[UI] Erreur _stopRecordingAndSend: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur envoi message : $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  /// Tap sur le micro : toggle start/stop comme WhatsApp simple
  Future<void> _onMicPressed() async {
    if (_isSending) {
      print('[UI] _onMicPressed ignoré car _isSending=true');
      return;
    }

    if (!_isRecording) {
      print('[UI] _onMicPressed => startRecording');
      await _startRecording();
    } else {
      print('[UI] _onMicPressed => stopRecording');
      await _stopRecordingAndSend();
    }
  }

  // ===================== GESTION ENVOI TEXTE (SMS) =====================

  Future<void> _onSendText() async {
    final api = _api;
    if (api == null) {
      print('[UI] _onSendText: API null');
      return;
    }

    final text = _textController.text.trim();
    print('[UI] _onSendText: texte="$text"');
    if (text.isEmpty) return;

    try {
      setState(() => _isSending = true);

      await api.envoyerMessageTexteCooperative(
        cooperativeId: _cooperativeId,
        texte: text,
      );
      print('[UI] envoyerMessageTexteCooperative OK');

      _textController.clear();
      await _refreshMessages();
    } catch (e) {
      print('[UI] Erreur _onSendText: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur envoi SMS : $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  String _formatHeure(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final dt = DateTime.parse(isoDate);
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final titreGroupe = widget.cooperative.nom;

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
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/cooperative.png'),
                    radius: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    titreGroupe,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.videocam,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GroupCallScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GroupCallScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      final api = _api;

                      if (api == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Impossible d\'ouvrir les informations du groupe. API non initialisée.',
                            ),
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupInfoScreen(
                            cooperative: widget.cooperative,
                            api: api,
                          ),
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

      // 2. Corps : liste dynamique de messages + barre de saisie
      body: Column(
        children: [
          Expanded(
            child: _buildMessagesList(),
          ),
          ChatInputBar(
            textController: _textController,
            onSendText: _onSendText,
            onMicPressed: _onMicPressed,
            isSending: _isSending,
            isRecording: _isRecording,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (_messages.isEmpty) {
      return const Center(
        child: Text(
          'Aucun message pour le moment.\nUtilisez le micro ou le clavier pour envoyer un message.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshMessages,
      child: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final msg = _messages[index];

          final bool isMe =
              _currentUserId != null && msg.expediteurId == _currentUserId;

          final String senderName = (msg.expediteurPrenom ?? '').isNotEmpty
              ? '${msg.expediteurPrenom} ${msg.expediteurNom ?? ''}'.trim()
              : (msg.expediteurNom ?? '');

          final String duree = msg.duree ?? '0:20';
          final String time = _formatHeure(msg.dateEnvoi);

          if (msg.audioUrl != null && msg.audioUrl!.isNotEmpty) {
            return VoiceMessageBubble(
              sender: isMe ? '' : (senderName.isEmpty ? 'Membre' : senderName),
              isMe: isMe,
              avatarUrl: 'assets/images/Ellipse 77.png',
              duration: duree,
              time: time,
              audioUrl: msg.audioUrl,
            );
          }

          if ((msg.texte ?? '').isNotEmpty) {
            return TextMessageBubble(
              sender: isMe ? '' : (senderName.isEmpty ? 'Membre' : senderName),
              isMe: isMe,
              avatarUrl: 'assets/images/Ellipse 77.png',
              texte: msg.texte ?? '',
              time: time,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ===================== BULLE DE MESSAGE VOCAL (LECTURE) =====================

class VoiceMessageBubble extends StatefulWidget {
  final String sender;
  final String avatarUrl;
  final bool isMe;
  final String duration;
  final String time;
  final String? audioUrl;

  const VoiceMessageBubble({
    super.key,
    required this.sender,
    required this.avatarUrl,
    required this.isMe,
    this.duration = '0:20',
    this.time = '11:14',
    this.audioUrl,
  });

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  late AudioPlayer _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    _player.playerStateStream.listen((state) {
      final playing = state.playing;
      final processingState = state.processingState;

      if (!mounted) return;

      setState(() {
        if (processingState == ProcessingState.completed) {
          _isPlaying = false;
          _player.seek(Duration.zero);
        } else {
          _isPlaying = playing;
        }
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (widget.audioUrl == null || widget.audioUrl!.isEmpty) {
      return;
    }

    if (_isPlaying) {
      await _player.pause();
    } else {
      try {
        String fullUrl;
        if (widget.audioUrl!.startsWith('http')) {
          fullUrl = widget.audioUrl!;
        } else {
          final base = AuthService.baseUrl;
          final apiIndex = base.indexOf('/api');
          final root = apiIndex == -1 ? base : base.substring(0, apiIndex);
          fullUrl = '$root${widget.audioUrl}';
        }

        print('[UI] Lecture audio: $fullUrl');
        await _player.setUrl(fullUrl);
        await _player.play();
      } catch (e) {
        print('[UI] Erreur lecture audio: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lecture audio : $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMe = widget.isMe;

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
                backgroundImage: AssetImage(widget.avatarUrl),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe && widget.sender.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, bottom: 4.0),
                    child: Text(
                      widget.sender,
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
                      GestureDetector(
                        onTap: _togglePlay,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: _kPrimaryPurple,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: 120,
                        height: 30,
                        child: CustomPaint(
                          painter: WaveformPainter(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        widget.duration,
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
                    widget.time,
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
                backgroundImage: AssetImage(widget.avatarUrl),
              ),
            ),
        ],
      ),
    );
  }
}

// ===================== BULLE DE MESSAGE TEXTE =====================

class TextMessageBubble extends StatelessWidget {
  final String sender;
  final String avatarUrl;
  final bool isMe;
  final String texte;
  final String time;

  const TextMessageBubble({
    super.key,
    required this.sender,
    required this.avatarUrl,
    required this.isMe,
    required this.texte,
    required this.time,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? _kLightPurple : Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
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
                  child: Text(
                    texte,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
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

// ===================== WAVEFORM (DÉCORATION) =====================

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
      0.3, 0.6, 0.9, 0.7, 0.5, 0.8, 1.0, 0.6, 0.4, 0.7,
      0.9, 0.5, 0.3, 0.6, 0.8
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

// ===================== BARRE DE SAISIE (VOCAL + TEXTE) =====================

class ChatInputBar extends StatefulWidget {
  final VoidCallback? onMicPressed;
  final VoidCallback onSendText;
  final bool isSending;
  final bool isRecording;
  final TextEditingController textController;

  const ChatInputBar({
    super.key,
    required this.textController,
    required this.onSendText,
    required this.onMicPressed,
    this.isSending = false,
    this.isRecording = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasTextNow = widget.textController.text.trim().isNotEmpty;
    if (hasTextNow != _hasText) {
      setState(() {
        _hasText = hasTextNow;
      });
    }
  }

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
              child: TextField(
                controller: widget.textController,
                enabled: !widget.isRecording,
                decoration: InputDecoration(
                  hintText: widget.isRecording
                      ? 'Enregistrement en cours...'
                      : 'Message vocal ou SMS…',
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.only(top: 12, bottom: 12),
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
            child: widget.isSending
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      _hasText
                          ? Icons.send
                          : (widget.isRecording ? Icons.stop : Icons.mic),
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: () {
                      if (_hasText) {
                        widget.onSendText();
                      } else {
                        widget.onMicPressed?.call();
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
