import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';

class KnowledgeBaseScreen extends StatelessWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Knowledge Base'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Styles', icon: Icon(Icons.palette)),
              Tab(text: 'Techniques', icon: Icon(Icons.brush)),
              Tab(text: 'Materials', icon: Icon(Icons.texture)),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: GradientBackground(
          child: TabBarView(
            children: [
              _KnowledgeTab(
                items: dataService.styleDescriptions,
                emptyMessage: 'No style information available',
              ),
              _KnowledgeTab(
                items: dataService.techniqueDescriptions,
                emptyMessage: 'No technique information available',
              ),
              _KnowledgeTab(
                items: dataService.materialDescriptions,
                emptyMessage: 'No material information available',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KnowledgeTab extends StatelessWidget {
  final Map<String, String> items;
  final String emptyMessage;

  const _KnowledgeTab({required this.items, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(emptyMessage, style: Theme.of(context).textTheme.bodyLarge),
      );
    }

    // Sort items alphabetically
    final sortedKeys = items.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final key = sortedKeys[index];
        final description = items[key]!;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ExpansionTile(
            title: Text(key, style: Theme.of(context).textTheme.titleLarge),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  key[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
