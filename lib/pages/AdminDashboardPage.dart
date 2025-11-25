import 'package:flutter/material.dart';
import 'package:musso_deme_app/services/content_service.dart';
import 'package:musso_deme_app/services/institution_service.dart';
import 'package:musso_deme_app/services/admin_profile_service.dart';
import 'package:musso_deme_app/modeles/content_model.dart';
import 'package:musso_deme_app/modeles/institution_model.dart';

class AdminDashboardPage extends StatefulWidget {
  final String authToken;
  
  const AdminDashboardPage({super.key, required this.authToken});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  List<ContentModel> _contents = [];
  List<ContentModel> _videos = [];
  List<ContentModel> _audios = [];
  List<InstitutionModel> _institutions = [];
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _message = 'Chargement des données...';
    });

    try {
      // Clear all lists first
      setState(() {
        _contents = [];
        _videos = [];
        _audios = [];
        _institutions = [];
      });

      // Load all contents
      final contents = await ContentService.getAllContents(widget.authToken);
      if (contents != null) {
        setState(() {
          _contents = contents;
        });
      }

      // Load videos
      final videos = await ContentService.getContentsByType(widget.authToken, 'VIDEOS');
      if (videos != null) {
        setState(() {
          _videos = videos;
        });
      }

      // Load audios
      final audios = await ContentService.getContentsByType(widget.authToken, 'AUDIOS');
      if (audios != null) {
        setState(() {
          _audios = audios;
        });
      }

      // Load institutions
      final institutions = await InstitutionService.getAllInstitutions(widget.authToken);
      if (institutions != null) {
        setState(() {
          _institutions = institutions;
        });
      }

      setState(() {
        _message = 'Données chargées avec succès';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _message = 'Erreur lors du chargement des données: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _createSampleContent() async {
    setState(() {
      _isLoading = true;
      _message = 'Création d\'un contenu exemple...';
    });

    try {
      final sampleContent = ContentModel(
        id: 0, // Will be assigned by the server
        titre: 'Contenu Exemple',
        langue: 'Français',
        description: 'Description du contenu exemple',
        urlContenu: 'https://example.com/content.mp4',
        duree: '30',
        adminId: 1,
        categorieId: 1,
      );

      final createdContent = await ContentService.createContent(widget.authToken, sampleContent);
      if (createdContent != null) {
        setState(() {
          _contents.add(createdContent);
          // Add to videos list if it's a video
          if (createdContent.urlContenu.contains('.mp4') || createdContent.urlContenu.contains('.avi') || createdContent.urlContenu.contains('.mov')) {
            _videos.add(createdContent);
          }
          // Add to audios list if it's an audio
          if (createdContent.urlContenu.contains('.mp3') || createdContent.urlContenu.contains('.wav') || createdContent.urlContenu.contains('.aac')) {
            _audios.add(createdContent);
          }
          _message = 'Contenu créé avec succès';
        });
      } else {
        setState(() {
          _message = 'Erreur lors de la création du contenu';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Exception lors de la création du contenu: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createSampleInstitution() async {
    setState(() {
      _isLoading = true;
      _message = 'Création d\'une institution exemple...';
    });

    try {
      final sampleInstitution = InstitutionModel(
        id: 0, // Will be assigned by the server
        nom: 'Institution Exemple',
        numeroTel: '+223 12 34 56 78',
        description: 'Description de l\'institution exemple',
        logoUrl: 'https://example.com/logo.png',
      );

      final createdInstitution = await InstitutionService.createInstitution(widget.authToken, sampleInstitution);
      if (createdInstitution != null) {
        setState(() {
          _institutions.add(createdInstitution);
          _message = 'Institution créée avec succès';
        });
      } else {
        setState(() {
          _message = 'Erreur lors de la création de l\'institution';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Exception lors de la création de l\'institution: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord Admin'),
        backgroundColor: const Color(0xFF491B6D),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _message,
              style: TextStyle(
                color: _message.contains('Erreur') || _message.contains('Exception') 
                  ? Colors.red 
                  : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
            const SizedBox(height: 16),
            // Cards for content statistics
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Total Contenus', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('${_contents.length}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Total Vidéos', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('${_videos.length}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    color: Colors.orange,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('Total Audios', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('${_audios.length}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Text('Liste des Contenus (${_contents.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _contents.length,
                itemBuilder: (context, index) {
                  final content = _contents[index];
                  return Card(
                    child: ListTile(
                      title: Text(content.titre),
                      subtitle: Text('${content.langue} - ${content.duree}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final success = await ContentService.deleteContent(widget.authToken, content.id);
                          if (success) {
                            setState(() {
                              _contents.removeAt(index);
                              // Remove from videos list if it exists there
                              _videos.removeWhere((video) => video.id == content.id);
                              // Remove from audios list if it exists there
                              _audios.removeWhere((audio) => audio.id == content.id);
                              _message = 'Contenu supprimé avec succès';
                            });
                          } else {
                            setState(() {
                              _message = 'Erreur lors de la suppression du contenu';
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Institutions (${_institutions.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _institutions.length,
                itemBuilder: (context, index) {
                  final institution = _institutions[index];
                  return Card(
                    child: ListTile(
                      title: Text(institution.nom),
                      subtitle: Text(institution.numeroTel),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final success = await InstitutionService.deleteInstitution(widget.authToken, institution.id);
                          if (success) {
                            setState(() {
                              _institutions.removeAt(index);
                              _message = 'Institution supprimée avec succès';
                            });
                          } else {
                            setState(() {
                              _message = 'Erreur lors de la suppression de l\'institution';
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _createSampleContent,
                  child: const Text('Ajouter Contenu'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _createSampleInstitution,
                  child: const Text('Ajouter Institution'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _loadData,
                  child: const Text('Rafraîchir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}