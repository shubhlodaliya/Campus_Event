import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signup() async {
    final String username = usernameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'All fields are required!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.137.47:3000/api/users/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.greenAccent),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sign-up successful! Redirecting to login...',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Wait for the SnackBar to finish before navigating
        await Future.delayed(Duration(seconds: 3));

        Navigator.pop(context); // Navigate back to LoginPage
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? 'Signup failed!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred. Please try again later.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Color(0xFFFFF6E9),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 270,),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    color: Color(0xFF3B6B6D), // Custom label color
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners when focused
                    borderSide: BorderSide(
                      color: Color(0xFF3B6B6D), // Border color when focused
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners when enabled
                    borderSide: BorderSide(
                      color: Colors.grey, // Border color when not focused
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200], // Background color
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Color(0xFF3B6B6D), // Custom label color
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners when focused
                    borderSide: BorderSide(
                      color: Color(0xFF3B6B6D), // Border color when focused
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners when enabled
                    borderSide: BorderSide(
                      color: Colors.grey, // Border color when not focused
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200], // Background color
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Color(0xFF3B6B6D), // Custom label color
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners when focused
                    borderSide: BorderSide(
                      color: Color(0xFF3B6B6D), // Border color when focused
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners when enabled
                    borderSide: BorderSide(
                      color: Colors.grey, // Border color when not focused
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200], // Background color
                ),
                obscureText: true, // Hide password text
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: signup,
                child: Text('Sign Up', style: TextStyle(color: Colors.white,fontSize: 20),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3B6B6D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(120, 45),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(
                      color: Color(0xFF3B6B6D),
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
