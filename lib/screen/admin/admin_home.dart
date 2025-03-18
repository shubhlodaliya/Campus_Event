// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// //
// // import '../login_page.dart';
// // import 'add_event_detail.dart';
// //
// // class AddEventScreen extends StatefulWidget {
// //   @override
// //   _AddEventScreenState createState() => _AddEventScreenState();
// // }
// //
// // class _AddEventScreenState extends State<AddEventScreen> {
// //   List<Map<String, dynamic>> events = []; // Store fetched events
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchEvents(); // Load events when screen startss
// //   }
// //
// //   // Fetch events from the API
// //   Future<void> fetchEvents() async {
// //     const String apiUrl = "http://192.168.55.473000/api/events"; // Update with your API URL
// //
// //     try {
// //       final response = await http.get(Uri.parse(apiUrl));
// //
// //       if (response.statusCode == 200) {
// //         List<dynamic> eventData = jsonDecode(response.body);
// //         setState(() {
// //           events = List<Map<String, dynamic>>.from(eventData);
// //         });
// //       } else {
// //         print('Failed to fetch events');
// //       }
// //     } catch (e) {
// //       print('Error fetching events: $e');
// //     }
// //   }
// //   Future<void> logout(BuildContext context) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setBool('isLoggedIn', false);
// //
// //     Navigator.pushAndRemoveUntil(
// //       context,
// //       MaterialPageRoute(builder: (context) => LoginPage()),
// //           (route) => false,
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Color(0xFF3B6B6D),
// //         title: Row(
// //           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Center(child: Text('Events')),
// //             IconButton(
// //               icon: Icon(Icons.logout),
// //               onPressed: () => logout(context),
// //               tooltip: 'Logout',
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: events.isEmpty
// //             ? Center(
// //           child: Text(
// //             'No events added yet.',
// //             style: TextStyle(fontSize: 18, color: Colors.grey, fontStyle: FontStyle.italic),
// //           ),
// //         )
// //             : ListView.builder(
// //           itemCount: events.length,
// //           itemBuilder: (context, index) {
// //             final event = events[index];
// //             return Card(
// //               elevation: 4,
// //               margin: EdgeInsets.symmetric(vertical: 8),
// //               child: ListTile(
// //                 title: Text(event['eventName'], style: TextStyle(fontWeight: FontWeight.bold)),
// //                 subtitle: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text('Organized By: ${event['organizedBy']}'),
// //                     Text('Date: ${event['date']}'),
// //                     Text('Time: ${event['time']}'),
// //                     Text('Venue: ${event['venue']}'),
// //                   ],
// //                 ),
// //                 trailing: Icon(Icons.event, color: Colors.teal),
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         backgroundColor: Color(0xFF80C3C1),
// //         onPressed: () async {
// //           await Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (context) => AdminHome()),
// //           );
// //           fetchEvents(); // Refresh event list after adding an event
// //         },
// //         child: Icon(Icons.add, color: Colors.white),
// //       ),
// //       backgroundColor: Color(0xFFFDF6E4),
// //     );
// //   }
// // }
// //
// // void main() => runApp(MaterialApp(
// //   home: AddEventScreen(),
// // ));
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../login_page.dart';
// import 'add_event_detail.dart';
//
// class AdminHome extends StatefulWidget {
//   final Map<String, dynamic>? event; // Accepts event data
//
//   AdminHome({super.key, this.event}); // Correct constructor
//
//   @override
//   State<AdminHome> createState() => _AddEventScreenState(); // Match class name
// }
//
//
// class _AddEventScreenState extends State<AdminHome> {
//   List<Map<String, dynamic>> events = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchEvents();
//   }
//
//   Future<void> fetchEvents() async {
//     const String apiUrl = "http://192.168.55.473000/api/events";
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         List<dynamic> eventData = jsonDecode(response.body);
//         setState(() {
//           events = List<Map<String, dynamic>>.from(eventData);
//         });
//       } else {
//         print('Failed to fetch events');
//       }
//     } catch (e) {
//       print('Error fetching events: $e');
//     }
//   }
//
//   Future<void> deleteEvent(String id) async {
//     final String deleteUrl = "http://192.168.55.47:3000/api/events/$id";
//     try {
//       final response = await http.delete(Uri.parse(deleteUrl));
//       if (response.statusCode == 200) {
//         setState(() {
//           events.removeWhere((event) => event['_id'] == id);
//         });
//         print('Event deleted successfully');
//       } else {
//         print('Failed to delete event');
//       }
//     } catch (e) {
//       print('Error deleting event: $e');
//     }
//   }
//
//   Future<void> logout(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', false);
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//           (route) => false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF3B6B6D),
//         title: Row(
//           children: [
//             Center(child: Text('Events')),
//             Spacer(),
//             IconButton(
//               icon: Icon(Icons.logout),
//               onPressed: () => logout(context),
//               tooltip: 'Logout',
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: events.isEmpty
//             ? Center(
//           child: Text(
//             'No events added yet.',
//             style: TextStyle(fontSize: 18, color: Colors.grey, fontStyle: FontStyle.italic),
//           ),
//         )
//             : ListView.builder(
//           itemCount: events.length,
//           itemBuilder: (context, index) {
//             final event = events[index];
//             return Card(
//               elevation: 4,
//               margin: EdgeInsets.symmetric(vertical: 8),
//               child: ListTile(
//                 title: Text(event['eventName'], style: TextStyle(fontWeight: FontWeight.bold)),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Organized By: ${event['organizedBy']}'),
//                     Text('Date: ${event['date']}'),
//                     Text('Time: ${event['time']}'),
//                     Text('Venue: ${event['venue']}'),
//                   ],
//                 ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit, color: Colors.blue),
//                       onPressed: () async {
//                         await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => AdminHome(event: event),
//                           ),
//                         );
//                         fetchEvents(); // Refresh the list after returning
//                       },
//
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => deleteEvent(event['_id']),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Color(0xFF80C3C1),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddEventDetailPage()),
//           );
//           fetchEvents();
//         },
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//       backgroundColor: Color(0xFFFDF6E4),
//     );
//   }
// }
import 'package:event_mnager/screen/student/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_share/flutter_share.dart';
import '../login_page.dart';

import 'package:event_mnager/lib/screen/student/interested.dart';

class Event {
  final String id;
  final String department;
  final String eventName;
  final String organizedBy;
  final String description;
  final String date;
  final String time;
  final String venue;
  final String guest;
  final String catagory;
  final String? image;
  final String email;
  final String mobile;
  final int seats;

  Event({
    required this.id,
    required this.department,
    required this.eventName,
    required this.organizedBy,
    required this.description,
    required this.date,
    required this.time,
    required this.venue,
    required this.guest,
    required this.catagory,
    this.image,
    required this.email,
    required this.mobile,
    required this.seats,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      department: json['department'],
      eventName: json['eventName'],
      organizedBy: json['organizedBy'],
      description: json['description'],
      date: json['date'],
      time: json['time'],
      venue: json['venue'],
      guest: json['guest'],
      catagory: json['catagory'],
      image: json['image'],
      email: json['email'],
      mobile: json['mobile'],
      seats: json['seats'],
    );
  }
}

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<Event> events = [];
  List<Event> filteredEvents = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  String selectedDepartment = "All"; // Default selection

  @override
  void initState() {
    super.initState();
    fetchEventData();
  }

  Future<void> fetchEventData() async {
    try {
      final List<Event> fetchedEvents = await fetchEventDataFromApi();
      setState(() {
        events = fetchedEvents;
        filteredEvents = fetchedEvents; // Initialize filtered list
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching events: $e')),
      );
    }
  }

  Future<List<Event>> fetchEventDataFromApi() async {
    const String apiUrl = "http://192.168.55.47:3000/api/events";
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      print(data);
      return data.map((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }






// Helper method to check if two dates are on the same day




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6E9),
      appBar: AppBar(
        backgroundColor: Color(0xFF2A4F50), // Slightly darker shade
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            SizedBox(
              width: 70,
            ),
            Text('All Events',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
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

              SizedBox(height: 20),

              // Explore Category

              SizedBox(height: 10),

              SizedBox(height: 10),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredEvents.isEmpty
                  ? Center(
                  child: Text('No events found',
                      style: TextStyle(
                          fontSize: 16, color: Colors.black54)))
                  : Column(
                children: filteredEvents.map((event) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2A4F50),
                            Color(0xFF19514A)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        title: Text(
                          event.eventName,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        subtitle: Text(
                          '📅 Date: ${event.date}',
                          style: TextStyle(
                              fontSize: 16, color: Colors.white70),
                        ),
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF2A4F50),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailsPage(event: event),
                              ),
                            );
                          },
                          icon: Icon(Icons.info, size: 18),
                          label: Text('Details'),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthService {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}

class EventDetailsPage extends StatefulWidget {
  final Event event;

  EventDetailsPage({required this.event});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

// class _EventDetailsPageState extends State<EventDetailsPage> {
//   // final EventService _eventService = EventService();
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.event.eventName,
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20)),
//               child: Image(
//                 image: AssetImage('assets/images/login1.png'),
//                 width: double.infinity,
//                 height: 220,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15)),
//                     child: Padding(
//                       padding: EdgeInsets.all(12),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           DetailRow(
//                               icon: Icons.business,
//                               label: 'Organized By',
//                               value: widget.event.organizedBy),
//                           DetailRow(
//                               icon: Icons.school,
//                               label: 'Department',
//                               value: widget.event.department),
//                           DetailRow(
//                               icon: Icons.calendar_today,
//                               label: 'Date',
//                               value: widget.event.date),
//                           DetailRow(
//                               icon: Icons.access_time,
//                               label: 'Time',
//                               value: widget.event.time),
//                           DetailRow(
//                               icon: Icons.location_on,
//                               label: 'Venue',
//                               value: widget.event.venue),
//                           DetailRow(
//                               icon: Icons.person,
//                               label: 'Guest',
//                               value: widget.event.guest),
//                           DetailRow(
//                               icon: Icons.category,
//                               label: 'Category',
//                               value: widget.event.catagory),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 15),
//                   Text('Description:',
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//                   SizedBox(height: 5),
//                   Text(widget.event.description,
//                       style: TextStyle(fontSize: 16)),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton.icon(
//                         onPressed: () async {
//                           setState(() {
//                             _isLoading = true;
//                           });
//                         },
//                         icon: _isLoading
//                             ? SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.blueAccent),
//                                 ),
//                               )
//                             : Icon(
//
//                                 Icons.star ,
//                                 color: Colors.blueAccent,
//                               ),
//                         label: Text(
//                           _isLoading ? "Adding..." : "Interested",
//                           style: TextStyle(color: Colors.blueAccent),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding:
//                               EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         ),
//                       ),
//                       ElevatedButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.share),
//                         label: Text("Share"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.blueAccent,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 15),
//                   ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       minimumSize: Size(double.infinity, 50),
//                     ),
//                     child: Text("Find Tickets",
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class _EventDetailsPageState extends State<EventDetailsPage> {
  bool _isLoading = false;
  int availableSeats = 0;

  @override
  void initState() {
    super.initState();
    availableSeats = widget.event.seats; // Initialize seats count
  }

  Future<void> _shareEventDetails() async {
    String eventDetails = '''
📢 *${widget.event.eventName}* 📢

🔹 Organized By: ${widget.event.organizedBy}
🏫 Department: ${widget.event.department}
📅 Date: ${widget.event.date}
⏰ Time: ${widget.event.time}
📍 Venue: ${widget.event.venue}
🎤 Guest: ${widget.event.guest}
📂 Category: ${widget.event.catagory}
📩 Email: ${widget.event.email}
📞 Mobile: ${widget.event.mobile}
🪑 Seats Available: $availableSeats

📝 Description: ${widget.event.description}

Don't miss out! 🚀
''';

    await Share.share(eventDetails);
  }

  Future<void> _addToInterestedEvents() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> interestedEvents =
        prefs.getStringList('interestedEvents') ?? [];

    Map<String, String> eventData = {
      'eventName': widget.event.eventName,
      'organizedBy': widget.event.organizedBy,
      'department': widget.event.department,
      'date': widget.event.date,
      'time': widget.event.time,
      'venue': widget.event.venue,
      'guest': widget.event.guest,
      'category': widget.event.catagory,
      'description': widget.event.description,
    };

    interestedEvents.add(jsonEncode(eventData));
    await prefs.setStringList('interestedEvents', interestedEvents);

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Event added to Interested Page!")),
    );
  }

  Future<void> _reserveSeat() async {
    if (availableSeats <= 0) return;

    final String apiUrl = "http://192.168.55.47:3000/api/events/${widget.event.id}/reserve";

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer YOUR_AUTH_TOKEN", // If using authentication
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["success"] == true) {
        setState(() {
          availableSeats--; // Update seats count in UI
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Seat reserved successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Failed to reserve seat.")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong!")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.eventName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              child: Image(
                image: AssetImage('assets/images/login1.png'),
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailRow(
                              icon: Icons.business,
                              label: 'Organized By',
                              value: widget.event.organizedBy),
                          DetailRow(
                              icon: Icons.school,
                              label: 'Department',
                              value: widget.event.department),
                          DetailRow(
                              icon: Icons.calendar_today,
                              label: 'Date',
                              value: widget.event.date),
                          DetailRow(
                              icon: Icons.access_time,
                              label: 'Time',
                              value: widget.event.time),
                          DetailRow(
                              icon: Icons.location_on,
                              label: 'Venue',
                              value: widget.event.venue),
                          DetailRow(
                              icon: Icons.person,
                              label: 'Guest',
                              value: widget.event.guest),
                          DetailRow(
                              icon: Icons.category,
                              label: 'Category',
                              value: widget.event.catagory),
                          DetailRow(
                              icon: Icons.email,
                              label: 'Email',
                              value: widget.event.email),
                          DetailRow(
                              icon: Icons.phone,
                              label: 'Mobile',
                              value: widget.event.mobile),
                          DetailRow(
                              icon: Icons.event_seat,
                              label: 'Seats Available',
                              value: availableSeats.toString()),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text('Description:',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(height: 5),
                  Text(widget.event.description,
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
          
                      ElevatedButton.icon(
                        onPressed: _shareEventDetails,
                        icon: Icon(Icons.share),
                        label: Text("Share"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 10),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
