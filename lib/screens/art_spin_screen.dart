import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/idea.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/wheel_widget.dart';
import 'favorites_screen.dart';
import 'idea_detail_screen.dart';
import 'knowledge_base_screen.dart';

class ArtSpinScreen extends StatefulWidget {
  const ArtSpinScreen({super.key});

  @override
  State<ArtSpinScreen> createState() => _ArtSpinScreenState();
}

class _ArtSpinScreenState extends State<ArtSpinScreen> {
  final DataService _dataService = DataService();

  late String currentCategory;
  late String currentStyle;
  late String currentTechnique;
  late String currentMaterial;

  bool isSpinning = false;
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _initializeValues();
    _checkIfFavorite();
  }

  void _initializeValues() {
    currentCategory = _dataService.getRandomValue(_dataService.categories);
    currentStyle = _dataService.getRandomValue(_dataService.styles);
    currentTechnique = _dataService.getRandomValue(_dataService.techniques);
    currentMaterial = _dataService.getRandomValue(_dataService.materials);
  }

  Future<void> _checkIfFavorite() async {
    final idea = _getCurrentIdea();
    final favorited = await _dataService.isFavorite(idea);
    setState(() {
      isFavorited = favorited;
    });
  }

  Idea _getCurrentIdea() {
    return Idea(
      category: currentCategory,
      style: currentStyle,
      technique: currentTechnique,
      material: currentMaterial,
    );
  }

  Future<void> _spinWheels() async {
    if (isSpinning) return;

    setState(() {
      isSpinning = true;
    });

    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 2000));

    setState(() {
      currentCategory = _dataService.getRandomValue(_dataService.categories);
      currentStyle = _dataService.getRandomValue(_dataService.styles);
      currentTechnique = _dataService.getRandomValue(_dataService.techniques);
      currentMaterial = _dataService.getRandomValue(_dataService.materials);
      isSpinning = false;
    });

    await _checkIfFavorite();
  }

  Future<void> _toggleFavorite() async {
    final idea = _getCurrentIdea();

    if (isFavorited) {
      await _dataService.removeFavorite(idea);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from favorites'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      await _dataService.addFavorite(idea);
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
      isFavorited = !isFavorited;
    });
  }

  void _shareIdea() {
    final idea = _getCurrentIdea();
    Share.share(idea.shareText);
  }

  void _navigateToDetail() {
    final idea = _getCurrentIdea();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IdeaDetailScreen(idea: idea)),
    );
  }

  void _navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FavoritesScreen()),
    );
  }

  void _navigateToKnowledgeBase() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const KnowledgeBaseScreen()),
    );
  }

  Future<void> _openPrivacyPolicy() async {
    final Uri url = Uri.parse(
      'https://artstylefactory.com/privacy-policy.html',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open Privacy Policy'),
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
        title: const Text('ArtStyle Factory'),
        leading: IconButton(
          icon: const Icon(Icons.privacy_tip_outlined),
          onPressed: _openPrivacyPolicy,
          tooltip: 'Privacy Policy',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: _navigateToFavorites,
            tooltip: 'Saved Ideas',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _navigateToKnowledgeBase,
            tooltip: 'Knowledge Base',
          ),
        ],
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Title
                Text(
                  'Spin for Inspiration',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Tap any wheel or the button below',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // Wheels Grid
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    WheelWidget(
                      label: 'CATEGORY',
                      currentValue: currentCategory,
                      color: AppTheme.wheel1Color,
                      onTap: _spinWheels,
                      isSpinning: isSpinning,
                    ),
                    WheelWidget(
                      label: 'STYLE',
                      currentValue: currentStyle,
                      color: AppTheme.wheel2Color,
                      onTap: _spinWheels,
                      isSpinning: isSpinning,
                    ),
                    WheelWidget(
                      label: 'TECHNIQUE',
                      currentValue: currentTechnique,
                      color: AppTheme.wheel3Color,
                      onTap: _spinWheels,
                      isSpinning: isSpinning,
                    ),
                    WheelWidget(
                      label: 'MATERIAL',
                      currentValue: currentMaterial,
                      color: AppTheme.wheel4Color,
                      onTap: _spinWheels,
                      isSpinning: isSpinning,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Main action button with gradient and glow
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: AppTheme.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: isSpinning ? null : _spinWheels,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: isSpinning
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.white,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Generate Idea',
                              style: TextStyle(
                                color: isSpinning
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionButton(
                      icon: isFavorited
                          ? Icons.favorite
                          : Icons.favorite_border,
                      label: 'Save',
                      onPressed: _toggleFavorite,
                      color: isFavorited ? Colors.red : AppTheme.primaryBlue,
                    ),
                    _ActionButton(
                      icon: Icons.share,
                      label: 'Share',
                      onPressed: _shareIdea,
                      color: AppTheme.primaryBlue,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Tips button with gradient and glow
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: AppTheme.accentGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentOrange.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _navigateToDetail,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.white),
                            SizedBox(width: 12),
                            Text(
                              'Get Implementation Tips',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
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
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: AppTheme.glowShadow(color),
          ),
          child: FloatingActionButton(
            onPressed: onPressed,
            backgroundColor: color,
            heroTag: label,
            child: Icon(icon),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
