// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// //
// // class HomePage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Home Page'),
// //       ),
// //       body: Center(
// //         child: Text('Welcome to the Home Page!'),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '/screen/login_page.dart';
//
// class HomePage extends StatelessWidget {
//   // Future<void> logout(BuildContext context) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //
//   //   // Clear login status
//   //   await prefs.setBool('isLoggedIn', false);
//   //
//   //   // Navigate to LoginPage
//   //   Navigator.pushAndRemoveUntil(
//   //     context,
//   //     MaterialPageRoute(builder: (context) => LoginPage()),
//   //         (route) => false, // Remove all previous routes
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Page'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               logout(context);
//             },
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: Center(
//         child: Text(
//           'Welcome to the Home Page!',
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admin/admin_home.dart';
import '/screen/login_page.dart';

class HomePage extends StatelessWidget {
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Clear login status
    await prefs.setBool('isLoggedIn', false);

    // Navigate to LoginPage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6E9),
      appBar: AppBar(
        backgroundColor: Color(0xFF3B6B6D),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            DropdownButton<String>(
              value: 'CSE', // Default department
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: SizedBox(), // Removes the underline
              style: TextStyle(color: Colors.white, fontSize: 16),
              onChanged: (String? newValue) {
                // Handle dropdown selection
                if (newValue != null) {
                  print('Selected Department: $newValue');
                }
              },
              items: ['CSE', 'CE', 'IT', 'EEE', 'ME']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
            Text('All Events'),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
               logout(context);
              },
              tooltip: 'Logout',
            ),
          ],
        ),
      ),

        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search an Event ...',
                  prefixIcon: Icon(Icons.search, color: Color(0xFF3B6B6D)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Color(0xFF3B6B6D)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),
              // Explore Category
              Text(
                'Explore Category >',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B6B6D),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var category in [
                      'Sports',
                      'Vrund',
                      'Workshop',
                      'Placement',
                      'Expert talk'
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 35, // Size of the circle
                              backgroundColor: Color(0xFF3B6B6D),
                              child: Text(
                                category[0], // First letter of the category
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              category,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Event Section
              Text(
                'All Department’s Event >>',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B6B6D),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'This Week',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Today',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Next Week',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'This Month',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Event Cards
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/event.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hands-on Workshop',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '27, December 2024 - Hand-on Workshop',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            child: Text(
                              'More details >>>',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddEventScreen(),
                                ),
                              )
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/event.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Workshop',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '27, December 2024 - Hand-on Workshop',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'More details >>>',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
