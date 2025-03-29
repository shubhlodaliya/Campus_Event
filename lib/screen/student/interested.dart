// import 'package:event_mnager/screen/student/profile.dart';
// import 'package:event_mnager/screen/student/student_home.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
//
// class InterestedPage extends StatefulWidget {
//   @override
//   _InterestedPageState createState() => _InterestedPageState();
// }
//
// class _InterestedPageState extends State<InterestedPage> {
//   List<Map<String, String>> _interestedEvents = [];
//   int _selectedIndex = 1; // Assuming Interested Page is at index 1
//
//   @override
//   void initState() {
//     super.initState();
//     _loadInterestedEvents();
//   }
//
//   Future<void> _loadInterestedEvents() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> savedEvents = prefs.getStringList('interestedEvents') ?? [];
//
//     setState(() {
//       _interestedEvents = savedEvents
//           .map((eventJson) => Map<String, String>.from(jsonDecode(eventJson)))
//           .toList();
//     });
//   }
//
//   Future<void> _removeEvent(int index) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> savedEvents = prefs.getStringList('interestedEvents') ?? [];
//
//     savedEvents.removeAt(index);
//     await prefs.setStringList('interestedEvents', savedEvents);
//
//     setState(() {
//       _interestedEvents.removeAt(index);
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Event removed from Interested Page!"),
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.redAccent,
//       ),
//     );
//   }
//   // int _selectedIndex = 1;
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   int _selectedIndex1 = 1;
//
//   void _onItemTapped1(int index) {
//     setState(() {
//       _selectedIndex = index;
//
//       // Navigate based on selected index
//       switch (index) {
//         case 0:
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => HomePage()),
//           );
//
//           break;
//         case 1:
//
//           break;
//         case 2:
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => ProfilePage()),
//           );
//           break;
//       }
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF5F7FA),
//       appBar: AppBar(
//         title: Text(
//           "Interested Events",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
//         ),
//         backgroundColor: Color(0xFF2A4F50),
//         elevation: 5,
//       ),
//       body: _interestedEvents.isEmpty
//           ? _buildEmptyState()
//           : ListView.builder(
//         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         itemCount: _interestedEvents.length,
//         itemBuilder: (context, index) {
//           final event = _interestedEvents[index];
//           return Dismissible(
//             key: Key(event['eventName'] ?? index.toString()),
//             direction: DismissDirection.endToStart,
//             background: Container(
//               alignment: Alignment.centerRight,
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               color: Colors.redAccent,
//               child: Icon(Icons.delete, color: Colors.white, size: 30),
//             ),
//             onDismissed: (direction) => _removeEvent(index),
//             child: Card(
//               elevation: 4,
//               margin: EdgeInsets.symmetric(vertical: 8),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15)),
//               child: ListTile(
//                 contentPadding: EdgeInsets.all(12),
//                 title: Text(
//                   event['eventName'] ?? "No Name",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.blueAccent),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Icon(Icons.calendar_today,
//                             size: 18, color: Colors.grey),
//                         SizedBox(width: 5),
//                         Text("Date: ${event['date']}",
//                             style: TextStyle(
//                                 fontSize: 14, color: Colors.black54),
//                         overflow: TextOverflow.clip,),
//                       ],
//                     ),
//                     SizedBox(height: 4),
//                     Row(
//
//
//                       children: [
//                         Icon(Icons.location_on,
//                             size: 18, color: Colors.grey),
//                         SizedBox(width: 5),
//                         Text("Venue: ${event['venue']}",
//                             style: TextStyle(
//                                 fontSize: 14, color: Colors.black54),
//                             overflow: TextOverflow.ellipsis,
//                             softWrap: true),
//                       ],
//                     ),
//                   ],
//                 ),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete,
//                       color: Colors.redAccent, size: 26),
//                   onPressed: () => _removeEvent(index),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Color(0xFF2A4F50),
//           borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//           boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 3, blurRadius: 7)],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//           child: BottomNavigationBar(
//             items: [
//               BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 28), label: 'Home'),
//               BottomNavigationBarItem(icon: Icon(Icons.star, size: 28), label: 'Interested'),
//               BottomNavigationBarItem(icon: Icon(Icons.person, size: 28), label: 'Profile'),
//             ],
//             currentIndex: _selectedIndex1,
//             selectedItemColor: Colors.orangeAccent,
//             unselectedItemColor: Colors.white.withOpacity(0.7),
//             backgroundColor: Color(0xFF2A4F50),
//             onTap: _onItemTapped1,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "No interested events yet!",
//             style: TextStyle(
//                 fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),
//           ),
//           SizedBox(height: 8),
//           Text(
//             "Explore and add events you're interested in.",
//             style: TextStyle(fontSize: 14, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:event_mnager/screen/student/profile.dart';
import 'package:event_mnager/screen/student/student_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterestedPage extends StatefulWidget {
  @override
  _InterestedPageState createState() => _InterestedPageState();
}

class _InterestedPageState extends State<InterestedPage> {
  List<Map<String, dynamic>> _interestedEvents = [];
  bool _isLoading = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _fetchInterestedEvents();
  }

  Future<void> _fetchInterestedEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('jwt_token') ?? ''; // Retrieve stored JWT token

      if (token.isEmpty) {
        throw Exception("Token not found. Please log in again.");
      }

      print("Token: $token"); // Debugging: Print token to verify

      final response = await http.get(
        Uri.parse('http://192.168.137.164:3000/api/events/interested'), // Ensure this is the correct API URL
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Ensure proper content type
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody.containsKey('events')) {
          setState(() {
            _interestedEvents = List<Map<String, dynamic>>.from(responseBody['events']);
            _isLoading = false;
          });
        } else {
          throw Exception("Invalid response format");
        }
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: Please log in again.");
      } else {
        throw Exception("Failed to load events. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching events: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _removeEvent(int index) async {
    setState(() {
      _interestedEvents.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Event removed from Interested Page!"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          break;
        case 2:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text("Interested Events", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Color(0xFF2A4F50),
        elevation: 5,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _interestedEvents.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: _interestedEvents.length,
        itemBuilder: (context, index) {
          final event = _interestedEvents[index];
          return Dismissible(
            key: Key(event['eventName'] ?? index.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.redAccent,
              child: Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            onDismissed: (direction) => _removeEvent(index),
            child: Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                title: Text(
                  event['eventName'] ?? "No Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueAccent),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                        SizedBox(width: 5),
                        Text("Date: ${event['date']}", style: TextStyle(fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 18, color: Colors.grey),
                        SizedBox(width: 5),
                        Text("Venue: ${event['venue']}", style: TextStyle(fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent, size: 26),
                  onPressed: () => _removeEvent(index),
                ),
              ),
            ),
          );
        },
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
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("No interested events yet!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54)),
          SizedBox(height: 8),
          Text("Explore and add events you're interested in.", style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
