import 'package:flutter/material.dart';
import 'api_service.dart'; 
import 'favorites.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'item_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> amiiboList;
  int _selectedIndex = 0; 

  @override
  void initState() {
    super.initState();
    amiiboList = fetchAmiiboData(); 
  }

  Future<void> addFavorite(String amiiboName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentFavorites = prefs.getStringList('favorites') ?? [];
    if (!currentFavorites.contains(amiiboName)) {
      currentFavorites.add(amiiboName);
      prefs.setStringList('favorites', currentFavorites);
    }
  }

  Future<bool> isFavorite(String amiiboName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentFavorites = prefs.getStringList('favorites') ?? [];
    return currentFavorites.contains(amiiboName);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amiibo List'),
        backgroundColor: Colors.yellow.shade700,
      ),
      body: _selectedIndex == 0 ? _buildHomePage() : FavoritesPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

 
  Widget _buildHomePage() {
    return Container(
      color: Colors.yellow.shade100,
      child: FutureBuilder<List<dynamic>>(
        future: amiiboList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada item.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var amiibo = snapshot.data![index];
                String amiiboName = amiibo['name'];
                String amiiboImage = amiibo['image'];
                String gameSeries = amiibo['gameSeries']; 

                return Card(
                  color: Colors.yellow.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: amiiboImage.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              amiiboImage,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.image_not_supported, color: Colors.grey),
                    title: Text(
                      amiiboName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Game Series: $gameSeries'),
                    onTap: () async {
                      bool favoriteStatus = await isFavorite(amiiboName);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailPage(
                            name: amiiboName,
                            imageUrl: amiiboImage,
                            amiiboSeries: amiibo['amiiboSeries'],
                            character: amiibo['character'],
                            gameSeries: amiibo['gameSeries'],
                            type: amiibo['type'],
                            head: amiibo['head'],
                            tail: amiibo['tail'],
                            releaseDates: {
                              'au': amiibo['release']['au'] ?? 'N/A',
                              'eu': amiibo['release']['eu'] ?? 'N/A',
                              'jp': amiibo['release']['jp'] ?? 'N/A',
                              'na': amiibo['release']['na'] ?? 'N/A',
                            },
                            isFavorite: favoriteStatus,
                            onFavoriteChanged: (updatedFavorites) async {
                              setState(() {
                                addFavorite(amiiboName);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
