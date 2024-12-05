import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemDetailPage extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String amiiboSeries;
  final String character;
  final String gameSeries;
  final String type;
  final String head;
  final String tail;
  final Map<String, String> releaseDates;
  final bool isFavorite;
  final Function(List<String>) onFavoriteChanged;

  ItemDetailPage({
    required this.name,
    required this.imageUrl,
    required this.amiiboSeries,
    required this.character,
    required this.gameSeries,
    required this.type,
    required this.head,
    required this.tail,
    required this.releaseDates,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentFavorites = prefs.getStringList('favorites') ?? [];

    if (isFavorite) {
      currentFavorites.remove(widget.name);
      _showSnackBar('Amiibo removed from favorites');
    } else {
      currentFavorites.add(widget.name);
      _showSnackBar('Amiibo added to favorites');
    }

    await prefs.setStringList('favorites', currentFavorites);

    setState(() {
      isFavorite = !isFavorite;
    });

    widget.onFavoriteChanged(currentFavorites);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amiibo Details'),
        backgroundColor: Colors.yellow.shade700,  
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Container(
        color: Colors.yellow.shade100,  
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildDetailCard(),
              SizedBox(height: 16),
              Text(
                'Release Dates',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildReleaseDateRow('Australia:', widget.releaseDates['au']),
              _buildReleaseDateRow('Europe:', widget.releaseDates['eu']),
              _buildReleaseDateRow('Japan:', widget.releaseDates['jp']),
              _buildReleaseDateRow('North America:', widget.releaseDates['na']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard() {
    return Card(
      color: Colors.yellow.shade300,  
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Amiibo Series:', widget.amiiboSeries),
            _buildDetailRow('Character:', widget.character),
            _buildDetailRow('Game Series:', widget.gameSeries),
            _buildDetailRow('Type:', widget.type),
            _buildDetailRow('Head:', widget.head),
            _buildDetailRow('Tail:', widget.tail),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildReleaseDateRow(String title, String? date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Text(date ?? 'N/A'),
        ],
      ),
    );
  }
}
