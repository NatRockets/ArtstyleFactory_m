import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/idea.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';

class IdeaDetailScreen extends StatefulWidget {
  final Idea idea;

  const IdeaDetailScreen({super.key, required this.idea});

  @override
  State<IdeaDetailScreen> createState() => _IdeaDetailScreenState();
}

class _IdeaDetailScreenState extends State<IdeaDetailScreen> {
  final DataService _dataService = DataService();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isFavorited = false;
  String _currentTip = '';
  late Idea _currentIdea;

  @override
  void initState() {
    super.initState();
    _currentIdea = widget.idea;
    _checkIfFavorite();
    _loadTips();
  }

  Future<void> _checkIfFavorite() async {
    final favorited = await _dataService.isFavorite(_currentIdea);
    setState(() {
      _isFavorited = favorited;
    });
  }

  void _loadTips() {
    setState(() {
      _currentTip = _dataService.getTipsForIdea(_currentIdea);
    });
  }

  void _loadRandomTip() {
    setState(() {
      _currentTip = _dataService.getRandomTip(_currentIdea);
    });
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorited) {
      await _dataService.removeFavorite(_currentIdea);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from favorites'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      await _dataService.addFavorite(_currentIdea);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to favorites!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  Future<void> _shareIdea() async {
    if (_currentIdea.photosPaths.isEmpty) {
      Share.share(_currentIdea.shareText);
    } else {
      // Share with photos
      final files = _currentIdea.photosPaths
          .map((path) => XFile(path))
          .toList();
      await Share.shareXFiles(files, text: _currentIdea.shareText);
    }
  }

  Future<void> _pickImage() async {
    print('🖼️ _pickImage called');

    if (!_isFavorited) {
      print('⚠️ Idea not favorited');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please save this idea to favorites first'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      print('📷 Opening image picker...');
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      print('📷 Image selected: ${image?.path}');

      if (image != null) {
        // Copy image to app's support directory (persists across rebuilds)
        final appDir = await getApplicationSupportDirectory();
        final fileName = 'idea_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedPath = '${appDir.path}/$fileName';

        print('💾 Copying image to: $savedPath');
        await File(image.path).copy(savedPath);

        // Save only filename (not full path) to handle container ID changes
        final updatedIdea = _currentIdea.copyWith(
          photosPaths: [..._currentIdea.photosPaths, fileName],
        );

        print(
          '💾 Updating favorite with ${updatedIdea.photosPaths.length} photos',
        );
        await _dataService.updateFavorite(updatedIdea);

        setState(() {
          _currentIdea = updatedIdea;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo added successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        print('✅ Photo added successfully!');
      } else {
        print('❌ No image selected');
      }
    } catch (e) {
      print('❌ Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding photo: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _removePhoto(int index) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Photo'),
        content: const Text('Are you sure you want to remove this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      // Delete the file (build full path from filename)
      try {
        final fileName = _currentIdea.photosPaths[index];
        final appDir = await getApplicationSupportDirectory();
        final filePath = '${appDir.path}/$fileName';
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // File deletion failed, but continue with removing from list
      }

      // Update idea
      final updatedPaths = List<String>.from(_currentIdea.photosPaths);
      updatedPaths.removeAt(index);
      final updatedIdea = _currentIdea.copyWith(photosPaths: updatedPaths);

      await _dataService.updateFavorite(updatedIdea);

      setState(() {
        _currentIdea = updatedIdea;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo removed'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idea Details'),
        actions: [
          IconButton(
            icon: Icon(_isFavorited ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
            tooltip: _isFavorited
                ? 'Remove from favorites'
                : 'Add to favorites',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareIdea,
            tooltip: 'Share',
          ),
        ],
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Idea card
                Container(
                  width: double.infinity,
                  decoration: AppTheme.cardDecoration(
                    gradient: AppTheme.primaryGradient,
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Creative Idea',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      _buildIdeaRow(
                        'Category',
                        _currentIdea.category,
                        Icons.category,
                        AppTheme.wheel1Color,
                      ),
                      const SizedBox(height: 12),
                      _buildIdeaRow(
                        'Style',
                        _currentIdea.style,
                        Icons.style,
                        AppTheme.wheel2Color,
                      ),
                      const SizedBox(height: 12),
                      _buildIdeaRow(
                        'Technique',
                        _currentIdea.technique,
                        Icons.brush,
                        AppTheme.wheel3Color,
                      ),
                      const SizedBox(height: 12),
                      _buildIdeaRow(
                        'Material',
                        _currentIdea.material,
                        Icons.texture,
                        AppTheme.wheel4Color,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Implementation Photos Section
                if (_isFavorited) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Implementation Photos',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      IconButton(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.add_photo_alternate),
                        tooltip: 'Add Photo',
                        color: AppTheme.primaryBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_currentIdea.photosPaths.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.photo_library_outlined,
                                size: 64,
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No photos yet',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add photos of your implementation',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.add_photo_alternate),
                                label: const Text('Add First Photo'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _currentIdea.photosPaths.length,
                        itemBuilder: (context, index) {
                          final fileName = _currentIdea.photosPaths[index];

                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: FutureBuilder<Map<String, dynamic>>(
                              future: _getPhotoFile(fileName),
                              builder: (context, snapshot) {
                                final data = snapshot.data;
                                final file = data?['file'] as File?;
                                final fileExists =
                                    data?['exists'] as bool? ?? false;

                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: fileExists && file != null
                                          ? Image.file(
                                              file,
                                              height: 200,
                                              width: 200,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return _buildPhotoPlaceholder();
                                                  },
                                            )
                                          : _buildPhotoPlaceholder(),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          onPressed: () => _removePhoto(index),
                                          tooltip: 'Remove photo',
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                ],

                // Section title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Implementation Tips',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TextButton.icon(
                      onPressed: _loadRandomTip,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Random Tip'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Tips card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: AppTheme.accentYellow,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Professional Guidance',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _currentTip,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _loadTips,
                    icon: const Icon(Icons.tips_and_updates),
                    label: const Text('Reload All Tips'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdeaRow(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 48, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Text(
            'Photo not found',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Build full path from filename and check if file exists
  Future<Map<String, dynamic>> _getPhotoFile(String fileName) async {
    final appDir = await getApplicationSupportDirectory();
    final filePath = '${appDir.path}/$fileName';
    final file = File(filePath);
    final exists = await file.exists();
    return {'file': file, 'exists': exists};
  }
}
