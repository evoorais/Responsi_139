import 'dart:convert'; 
import 'package:http/http.dart' as http; 


Future<List<dynamic>> fetchAmiiboData() async {
  final String baseUrl = 'https://www.amiiboapi.com/api/amiibo';

  try {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('amiibo')) {
        return data['amiibo']; 
      } else {
        throw Exception('Data tidak ditemukan.');
      }
    } else {
      throw Exception('Gagal mengambil data dari API.');
    }
  } catch (e) {
    throw Exception('Error: $e'); 
  }
}
