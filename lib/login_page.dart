import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_page.dart'; 

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();

    String username = _usernameController.text;
    String password = _passwordController.text;

    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');

    if (storedUsername == null || storedPassword == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Pengguna tidak terdaftar!")));
      return;
    }

    if (username == storedUsername && password == storedPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login berhasil!")));
      Navigator.pushReplacementNamed(context, '/homepage'); 
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Username atau kata sandi salah")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.yellow.shade700, 
      ),
      body: Container(
        color: Colors.yellow.shade100, 
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            color: Colors.yellow.shade300, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade700, 
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Login'),
                  ),
                  SizedBox(height: 20),
                  
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      "Belum punya akun? Daftar di sini.",
                      style: TextStyle(
                        color: Colors.black, 
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
