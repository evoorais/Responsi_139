import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<String> favoriteItems = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

 
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteItems = prefs.getStringList('favorites') ?? [];
    });
  }

 
  Future<void> _removeFavorite(String item) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteItems.remove(item);
    });
    await prefs.setStringList('favorites', favoriteItems);

    
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$item removed from favorites'),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.yellow.shade700, 
      ),
      body: Container(
        color: Colors.yellow.shade100, 
        child: favoriteItems.isEmpty
            ? Center(child: Text('No favorite items.'))
            : ListView.builder(
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  String item = favoriteItems[index];
                  return Dismissible(
                    key: Key(item),
                    onDismissed: (direction) {
                      
                      _removeFavorite(item);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      color: Colors.yellow.shade300, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(item, style: TextStyle(fontWeight: FontWeight.bold)),
                        onTap: () {
                         
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
