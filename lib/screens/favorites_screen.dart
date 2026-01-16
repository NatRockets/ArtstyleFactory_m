import 'package:flutter/material.dart';
import '../models/idea.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';
import 'idea_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final DataService _dataService = DataService();
  List<Idea> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    final favorites = await _dataService.getFavorites();

    setState(() {
      _favorites = favorites;
      _isLoading = false;
    });
  }

  Future<void> _deleteFavorite(Idea idea) async {
    await _dataService.removeFavorite(idea);
    await _loadFavorites();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from favorites'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToDetail(Idea idea) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IdeaDetailScreen(idea: idea)),
    ).then((_) => _loadFavorites()); // Reload in case favorite status changed
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'portrait':
        return Icons.person;
      case 'landscape':
        return Icons.landscape;
      case 'abstract':
        return Icons.blur_on;
      case 'still life':
        return Icons.local_florist;
      case 'concept art':
        return Icons.lightbulb;
      case 'logo':
        return Icons.style;
      case 'poster':
        return Icons.image;
      case 'infographic':
        return Icons.bar_chart;
      default:
        return Icons.palette;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Ideas')),
      body: GradientBackground(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _favorites.isEmpty
            ? _buildEmptyState()
            : _buildFavoritesList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: AppTheme.textSecondary),
          const SizedBox(height: 20),
          Text(
            'No saved ideas yet',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Start spinning and save your favorite ideas!',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final idea = _favorites[index];
        return Card(
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(_getCategoryIcon(idea.category), color: Colors.white),
            ),
            title: Text(
              idea.shortTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Technique: ${idea.technique}\nMaterial: ${idea.material}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(idea),
            ),
            onTap: () => _navigateToDetail(idea),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  void _showDeleteDialog(Idea idea) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Idea'),
        content: const Text(
          'Are you sure you want to remove this idea from favorites?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFavorite(idea);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
