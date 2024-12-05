import 'package:flutter/material.dart';
import 'register_page.dart';
import 'login_page.dart';
import 'homepage.dart';  

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  
      initialRoute: '/login',  
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/homepage': (context) => HomePage(),
      },
    );
  }
}
