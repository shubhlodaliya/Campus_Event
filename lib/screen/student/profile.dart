import 'package:event_mnager/screen/student/student_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_page.dart';
import 'interested.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _email = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email'); // Retrieve stored email

    setState(() {
      _email = email ?? "No Email Found";
    });
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logged out successfully!"), backgroundColor: Colors.redAccent),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );
  }
  int _selectedIndex = 2;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  void _onItemTapped1(int index) {
    setState(() {
      _selectedIndex = index;

      // Navigate based on selected index
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InterestedPage()),
          );
          break;
        case 2:

          break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF2A4F50),
        title: Text("Profile", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),

        // elevation: 5,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile.png'), // Replace with actual user image if available
              ),
              SizedBox(height: 15),
              Text(
                "Email:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              Text(
                _email,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  logout(context);
                },
                icon: Icon(Icons.logout),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2A4F50),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 3, blurRadius: 7)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 28), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.star, size: 28), label: 'Interested'),
              BottomNavigationBarItem(icon: Icon(Icons.person, size: 28), label: 'Profile'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.orangeAccent,
            unselectedItemColor: Colors.white.withOpacity(0.7),
            backgroundColor: Color(0xFF2A4F50),
            onTap: _onItemTapped1,
          ),
        ),
      ),
    );
  }
}
