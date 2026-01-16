class Idea {
  final String category;
  final String style;
  final String technique;
  final String material;
  final DateTime timestamp;
  final List<String> photosPaths;

  Idea({
    required this.category,
    required this.style,
    required this.technique,
    required this.material,
    DateTime? timestamp,
    List<String>? photosPaths,
  }) : timestamp = timestamp ?? DateTime.now(),
       photosPaths = photosPaths ?? [];

  // Convert to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'style': style,
      'technique': technique,
      'material': material,
      'timestamp': timestamp.toIso8601String(),
      'photosPaths': photosPaths,
    };
  }

  // Create from Map
  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      category: json['category'] as String,
      style: json['style'] as String,
      technique: json['technique'] as String,
      material: json['material'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      photosPaths: json['photosPaths'] != null
          ? List<String>.from(json['photosPaths'] as List)
          : [],
    );
  }

  // Create a copy with updated photos
  Idea copyWith({
    String? category,
    String? style,
    String? technique,
    String? material,
    DateTime? timestamp,
    List<String>? photosPaths,
  }) {
    return Idea(
      category: category ?? this.category,
      style: style ?? this.style,
      technique: technique ?? this.technique,
      material: material ?? this.material,
      timestamp: timestamp ?? this.timestamp,
      photosPaths: photosPaths ?? this.photosPaths,
    );
  }

  // Generate a short title for the idea
  String get shortTitle => '$category in $style style';

  // Generate a full description
  String get fullDescription =>
      'Category: $category\nStyle: $style\nTechnique: $technique\nMaterial: $material';

  // Generate share text
  String get shareText =>
      'My new idea from ArtStyle Factory: $category in $style style, technique $technique on $material';

  // Check equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Idea &&
        other.category == category &&
        other.style == style &&
        other.technique == technique &&
        other.material == material;
  }

  @override
  int get hashCode {
    return category.hashCode ^
        style.hashCode ^
        technique.hashCode ^
        material.hashCode;
  }

  @override
  String toString() => 'Idea($category, $style, $technique, $material)';
}
