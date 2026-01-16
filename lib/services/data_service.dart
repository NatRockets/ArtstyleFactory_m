import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/idea.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final Random _random = Random();
  SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Categories
  final List<String> categories = [
    'Portrait',
    'Landscape',
    'Abstract',
    'Still Life',
    'Concept Art',
    'Logo',
    'Poster',
    'Infographic',
  ];

  // Styles
  final List<String> styles = [
    'Realism',
    'Impressionism',
    'Cubism',
    'Minimalism',
    'Pop Art',
    'Cyberpunk',
    'Vintage',
    'Grunge',
  ];

  // Techniques
  final List<String> techniques = [
    'Oil Painting',
    'Digital Graphics',
    'Collage',
    'Graffiti',
    'Embroidery',
    '3D Modeling',
    'Linocut',
    'Watercolor',
  ];

  // Materials
  final List<String> materials = [
    'Canvas',
    'Paper',
    'Wood',
    'Metal',
    'Digital Canvas',
    'Street Wall',
    'Fabric',
    'Plywood',
  ];

  // Generate random idea
  Idea generateRandomIdea() {
    return Idea(
      category: categories[_random.nextInt(categories.length)],
      style: styles[_random.nextInt(styles.length)],
      technique: techniques[_random.nextInt(techniques.length)],
      material: materials[_random.nextInt(materials.length)],
    );
  }

  // Get a random value from a list
  String getRandomValue(List<String> list) {
    return list[_random.nextInt(list.length)];
  }

  // Favorites management
  static const String _favoritesKey = 'favorites';

  Future<List<Idea>> getFavorites({bool skipCleanup = false}) async {
    if (_prefs == null) await init();
    final String? favoritesJson = _prefs!.getString(_favoritesKey);
    if (favoritesJson == null) return [];

    final List<dynamic> favoritesList = jsonDecode(favoritesJson);
    List<Idea> ideas = favoritesList
        .map((json) => Idea.fromJson(json))
        .toList();

    print('📚 Loaded ${ideas.length} favorites from storage');
    for (var i = 0; i < ideas.length; i++) {
      if (ideas[i].photosPaths.isNotEmpty) {
        print('   - Idea $i has ${ideas[i].photosPaths.length} photos');
      }
    }

    // Clean up missing photo files (skip during update operations)
    if (!skipCleanup) {
      bool needsUpdate = false;
      final cleanedIdeas = <Idea>[];
      final appDir = await getApplicationSupportDirectory();

      for (var idea in ideas) {
        final validPaths = <String>[];
        for (var fileName in idea.photosPaths) {
          // Build full path from filename
          final filePath = '${appDir.path}/$fileName';
          if (await File(filePath).exists()) {
            validPaths.add(fileName);
          } else {
            print('🗑️ Removing invalid file: $fileName');
            needsUpdate = true;
          }
        }
        cleanedIdeas.add(idea.copyWith(photosPaths: validPaths));
      }

      // Save if any paths were removed
      if (needsUpdate) {
        print('🔄 Cleaning up invalid paths...');
        await _saveFavorites(cleanedIdeas);
      }

      return cleanedIdeas;
    }

    return ideas;
  }

  Future<void> addFavorite(Idea idea) async {
    if (_prefs == null) await init();
    final List<Idea> favorites = await getFavorites();

    // Check if already exists
    if (!favorites.any((fav) => fav == idea)) {
      favorites.add(idea);
      await _saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(Idea idea) async {
    if (_prefs == null) await init();
    final List<Idea> favorites = await getFavorites();
    favorites.removeWhere((fav) => fav == idea);
    await _saveFavorites(favorites);
  }

  Future<bool> isFavorite(Idea idea) async {
    final List<Idea> favorites = await getFavorites();
    return favorites.any((fav) => fav == idea);
  }

  Future<void> _saveFavorites(List<Idea> favorites) async {
    final List<Map<String, dynamic>> favoritesJson = favorites
        .map((idea) => idea.toJson())
        .toList();
    final jsonString = jsonEncode(favoritesJson);
    await _prefs!.setString(_favoritesKey, jsonString);
    print('💾 Saved ${favorites.length} favorites to storage');

    // Debug: Print photo counts
    for (var i = 0; i < favorites.length; i++) {
      if (favorites[i].photosPaths.isNotEmpty) {
        print('   - Idea $i has ${favorites[i].photosPaths.length} photos');
      }
    }
  }

  // Update an existing favorite (e.g., when photos are added)
  Future<void> updateFavorite(Idea updatedIdea) async {
    if (_prefs == null) await init();
    // Skip cleanup during update to avoid race condition with newly added photos
    final List<Idea> favorites = await getFavorites(skipCleanup: true);

    // Find and replace the matching idea
    final index = favorites.indexWhere(
      (fav) =>
          fav.category == updatedIdea.category &&
          fav.style == updatedIdea.style &&
          fav.technique == updatedIdea.technique &&
          fav.material == updatedIdea.material,
    );

    if (index != -1) {
      favorites[index] = updatedIdea;
      await _saveFavorites(favorites);
      print('✅ Favorite updated with ${updatedIdea.photosPaths.length} photos');
    } else {
      print('❌ Favorite not found for update');
    }
  }

  // Knowledge base data
  final Map<String, String> styleDescriptions = {
    'Realism':
        'Realism is an artistic movement that emerged in the mid-19th century, emphasizing accurate depiction of contemporary life and the natural world. Artists focus on representing subjects truthfully, without artificiality and avoiding artistic conventions. Key characteristics include attention to detail, natural lighting, and everyday subject matter. Famous artists include Gustave Courbet and Jean-François Millet.',

    'Impressionism':
        'Impressionism is a 19th-century art movement characterized by small, thin brush strokes, open composition, and emphasis on accurate depiction of light in its changing qualities. Artists often painted outdoors to capture natural light and color. Key features include visible brush strokes, bright colors, and movement. Notable artists include Claude Monet, Pierre-Auguste Renoir, and Edgar Degas.',

    'Cubism':
        'Cubism is an early-20th-century avant-garde art movement that revolutionized European painting and sculpture. Objects are analyzed, broken up and reassembled in an abstracted form. Instead of depicting objects from a single viewpoint, artists present the subject from multiple angles simultaneously. Pablo Picasso and Georges Braque pioneered this movement.',

    'Minimalism':
        'Minimalism in art emphasizes simplicity and reduction to essential forms. It emerged in the late 1950s as a reaction against abstract expressionism. Characteristics include geometric shapes, monochromatic palettes, and clean lines. The movement focuses on the fundamental elements of form, color, and space. Artists like Donald Judd and Frank Stella are key figures.',

    'Pop Art':
        'Pop Art emerged in the 1950s, challenging traditions of fine art by incorporating imagery from popular and mass culture. It uses bright colors, bold outlines, and references to advertising, comic books, and consumer products. The movement blurred boundaries between "high" art and "low" culture. Andy Warhol and Roy Lichtenstein are iconic Pop Art artists.',

    'Cyberpunk':
        'Cyberpunk is a science fiction aesthetic featuring advanced technological and scientific achievements, juxtaposed with societal collapse or radical change. It often includes neon colors, dystopian urban environments, and themes of artificial intelligence and virtual reality. The style combines high-tech elements with a sense of rebellion and underground culture.',

    'Vintage':
        'Vintage art refers to styles and aesthetics from past eras, typically 20th century. It often features muted color palettes, retro typography, and nostalgic imagery. Common elements include aged textures, classic design motifs, and references to specific time periods like the 1950s or 1970s. This style evokes nostalgia and timeless elegance.',

    'Grunge':
        'Grunge is a style characterized by raw, unpolished aesthetics. It emerged from 1990s alternative rock culture and features distressed textures, rough edges, and deliberately imperfect elements. Common elements include dark color palettes, torn edges, splatter effects, and a DIY aesthetic. It represents rebellion against polished, mainstream design.',
  };

  final Map<String, String> techniqueDescriptions = {
    'Oil Painting':
        'Oil painting is a traditional technique using pigments suspended in drying oil, typically linseed oil. It offers rich colors, smooth blending, and long working time. The paint can be applied in thin glazes or thick impasto. Oil paintings have excellent longevity and allow for detailed work. Tips: Use quality brushes, work in layers from thin to thick, and ensure proper ventilation.',

    'Digital Graphics':
        'Digital graphics involve creating artwork using computer software and digital tools like graphic tablets. It offers unlimited undo options, easy color adjustment, and layer-based workflows. Popular software includes Photoshop, Procreate, and Illustrator. Tips: Learn keyboard shortcuts, use layers effectively, regularly save your work, and calibrate your monitor for accurate colors.',

    'Collage':
        'Collage is a technique of assembling different materials like paper, photographs, fabric, and found objects onto a surface. It allows for unexpected combinations and textures. You can use various adhesives and incorporate drawing or painting. Tips: Collect diverse materials, plan composition before gluing, use appropriate adhesive for each material, and seal finished work with varnish.',

    'Graffiti':
        'Graffiti is an urban art form using spray paint, markers, and other materials on public surfaces. It features bold lines, vibrant colors, and often includes lettering and characters. Techniques include tagging, throw-ups, and murals. Tips: Practice on paper first, use quality spray paint, work quickly, consider legal walls, and always use protective equipment.',

    'Embroidery':
        'Embroidery is the art of decorating fabric using needle and thread. It includes various stitches like satin stitch, chain stitch, and French knots. Can be done by hand or machine. Tips: Use an embroidery hoop to keep fabric taut, choose appropriate needle and thread weight, transfer designs carefully, and practice basic stitches before complex patterns.',

    '3D Modeling':
        '3D modeling creates three-dimensional representations of objects using specialized software like Blender, Maya, or ZBrush. It involves creating vertices, edges, and polygons to form meshes. Applications include animation, games, and product visualization. Tips: Start with basic shapes, learn topology principles, use reference images, and practice with free software before investing in paid tools.',

    'Linocut':
        'Linocut is a printmaking technique where a design is carved into linoleum block, inked, and pressed onto paper. It produces bold, graphic images with strong contrast. Multiple colors require separate blocks. Tips: Transfer design carefully, carve away from your body, use sharp tools, keep designs simple initially, and test prints before final edition.',

    'Watercolor':
        'Watercolor painting uses water-soluble pigments on paper. It creates transparent, luminous effects through layering and wet-on-wet techniques. The medium is known for its fluidity and unpredictability. Tips: Use quality paper (140lb minimum), work light to dark, embrace happy accidents, let layers dry completely, and keep water clean for vibrant colors.',
  };

  final Map<String, String> materialDescriptions = {
    'Canvas':
        'Canvas is a durable fabric surface, traditionally made from cotton or linen, stretched over a wooden frame. It\'s the standard support for oil and acrylic paintings. Canvas can be pre-primed or prepared with gesso. Available in various textures and weights. Tips: Choose appropriate weave for your technique, ensure proper stretching, apply gesso evenly, and consider canvas quality for longevity.',

    'Paper':
        'Paper is a versatile surface for various art techniques including drawing, watercolor, and printmaking. Different types include hot-pressed (smooth), cold-pressed (textured), and rough. Weight is measured in pounds or grams per square meter. Tips: Match paper to medium, test before important work, store flat in dry conditions, and use acid-free paper for archival quality.',

    'Wood':
        'Wood panels have been used for centuries in painting and are experiencing renewed popularity. They provide a rigid, stable surface. Requires proper sealing and priming. Can be used for oil, acrylic, or mixed media. Tips: Sand smooth before priming, seal all sides to prevent warping, apply multiple gesso layers, and choose hardwoods like birch or maple for durability.',

    'Metal':
        'Metal surfaces including aluminum, copper, and steel offer unique properties for art. They\'re durable, non-absorbent, and can create interesting effects. Often used for contemporary and outdoor art. Tips: Clean surface thoroughly, use appropriate primers, consider metal\'s thermal expansion, use compatible paints, and protect finished work with sealant.',

    'Digital Canvas':
        'Digital canvas refers to the virtual workspace in digital art software. It can be infinitely resizable, supports layers, and allows non-destructive editing. Resolution and dimensions affect final output quality. Tips: Set appropriate DPI for intended use (72 for web, 300 for print), use layers strategically, save in multiple formats, and back up regularly.',

    'Street Wall':
        'Street walls are public surfaces for large-scale murals and graffiti. They present unique challenges including texture, weathering, and scale. Preparation and permission are essential. Tips: Get permission from property owners, prepare surface if possible, use weather-resistant materials, plan design at scale, work in suitable weather, and document your work.',

    'Fabric':
        'Fabric is a flexible material suitable for textile arts, embroidery, painting, and dyeing. Different weaves and fibers affect working properties. Can be natural (cotton, silk) or synthetic. Tips: Pre-wash to remove sizing, use appropriate needles and threads, secure in hoop or frame, test materials first, and heat-set fabric paints as directed.',

    'Plywood':
        'Plywood consists of thin wood layers glued together, offering strength and affordability. It\'s lighter than solid wood but requires edge treatment. Good for large-scale work and outdoor installations. Tips: Choose birch plywood for smooth surface, seal edges thoroughly, sand progressively, prime with gesso or specialized primer, and support large panels to prevent warping.',
  };

  // Get tips for a specific idea
  String getTipsForIdea(Idea idea) {
    final styleTip = styleDescriptions[idea.style] ?? '';
    final techniqueTip = techniqueDescriptions[idea.technique] ?? '';
    final materialTip = materialDescriptions[idea.material] ?? '';

    return 'STYLE INSIGHTS:\n$styleTip\n\n'
        'TECHNIQUE GUIDE:\n$techniqueTip\n\n'
        'MATERIAL NOTES:\n$materialTip';
  }

  // Get random tip from available tips
  String getRandomTip(Idea idea) {
    final tips = [
      styleDescriptions[idea.style],
      techniqueDescriptions[idea.technique],
      materialDescriptions[idea.material],
    ].whereType<String>().toList();

    if (tips.isEmpty) return 'No tips available for this combination.';
    return tips[_random.nextInt(tips.length)];
  }
}
