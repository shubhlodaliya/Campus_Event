import 'package:event_mnager/screen/student/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_share/flutter_share.dart';
import '../login_page.dart';
import 'event_detail.dart';
import 'interested.dart';
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  // Future<void> logout(BuildContext context) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isLoggedIn', false);
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginPage()),
  //     (route) => false,
  //   );
  // }

  void filterEvents(String query) {
    setState(() {
      applyMultipleFilters();
      if (query.isEmpty) {
        filteredEvents = events;
      } else {
        filteredEvents = events
            .where((event) =>
                event.eventName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void filterEventsByDepartment(String department) {
    setState(() {
      selectedDepartment = department;
      filteredEvents = department == "All"
          ? events
          : events.where((event) => event.department == department).toList();
    });
    setState(() {
      selectedDepartment = department;
      applyMultipleFilters();
    });
  }

  void filterEventsByCategory(String category) {
    setState(() {
      filteredEvents = category == "All"
          ? events
          : events.where((event) => event.catagory == category).toList();
    });
    setState(() {
      selectedCategory = category;
      applyMultipleFilters();
    });
  }

  String selectedDateRange = 'All';
  String selectedCategory = "All";

  void filterEventsByDateRange(String range) {
    DateTime now = DateTime.now();
    setState(() {
      selectedDateRange = range;
      applyMultipleFilters();
      filteredEvents = events.where((event) {
        DateTime eventDate = DateTime.parse(event.date);

        switch (range) {
          case 'Today':
            return isSameDay(eventDate, now);

          case 'This Week':
            return eventDate.isAfter(now.subtract(Duration(days: 1))) &&
                eventDate.isBefore(now.add(Duration(days: 7)));

          case 'Next Week':
            return eventDate.isAfter(now.add(Duration(days: 7))) &&
                eventDate.isBefore(now.add(Duration(days: 14)));

          case 'This Month':
            return eventDate.year == now.year && eventDate.month == now.month;

          case 'All':
          default:
            return true;
        }
      }).toList();
    });
  }

// Helper method to check if two dates are on the same day
  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  bool _matchesDateRange(String dateString, String range) {
    DateTime now = DateTime.now();
    DateTime eventDate = DateTime.parse(dateString);

    switch (range) {
      case 'Today':
        return isSameDay(eventDate, now);
      case 'This Week':
        return eventDate.isAfter(now.subtract(Duration(days: 1))) &&
            eventDate.isBefore(now.add(Duration(days: 7)));
      case 'Next Week':
        return eventDate.isAfter(now.add(Duration(days: 7))) &&
            eventDate.isBefore(now.add(Duration(days: 14)));
      case 'This Month':
        return eventDate.year == now.year && eventDate.month == now.month;
      case 'All':
      default:
        return true;
    }
  }

  void applyMultipleFilters() {
    setState(() {
      filteredEvents = events.where((event) {
        bool matchesDepartment = selectedDepartment == "All" ||
            event.department == selectedDepartment;

        bool matchesCategory =
            selectedCategory == "All" || event.catagory == selectedCategory;

        bool matchesDateRange =
            _matchesDateRange(event.date, selectedDateRange);

        bool matchesSearch = searchController.text.isEmpty ||
            event.eventName
                .toLowerCase()
                .contains(searchController.text.toLowerCase());

        return matchesDepartment &&
            matchesCategory &&
            matchesDateRange &&
            matchesSearch;
      }).toList();
    });
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex1 = 0;

  void _onItemTapped1(int index) {
    setState(() {
      _selectedIndex = index;

      // Navigate based on selected index
      switch (index) {
        case 0:
          // Already on HomePage
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InterestedPage()),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6E9),
      appBar: AppBar(
        backgroundColor: Color(0xFF2A4F50), // Slightly darker shade
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: selectedDepartment.isNotEmpty ? selectedDepartment : 'All',
              // Ensure a default value
              dropdownColor: Color(0xFF3B6B6D),
              // Dark background for contrast
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: SizedBox(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              // Ensure selected value is visible
              onChanged: (String? newValue) {
                if (newValue != null) {
                  filterEventsByDepartment(newValue);
                }
              },
              items: ['All', 'CSE', 'CE', 'IT', 'EC', 'ME', 'AIML']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(
                          color: Colors
                              .white)), // White text for better visibility
                );
              }).toList(),
            ),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2A4F50),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 7)
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled, size: 28), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.star, size: 28), label: 'Interested'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person, size: 28), label: 'Profile'),
            ],
            currentIndex: _selectedIndex1,
            selectedItemColor: Colors.orangeAccent,
            unselectedItemColor: Colors.white.withOpacity(0.7),
            backgroundColor: Color(0xFF2A4F50),
            onTap: _onItemTapped1,
          ),
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
                controller: searchController,
                onChanged: filterEvents,
                decoration: InputDecoration(
                  hintText: '🔍 Search an Event...',
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF2A4F50)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  // boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2))],
                ),
              ),
              SizedBox(height: 20),

              // Explore Category
              Text(
                '🏆 Explore Categories',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A4F50)),
              ),
              SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var category in [
                      'All',
                      'Sports',
                      'Vrund',
                      'Workshop',
                      'Placement',
                      'Expert talk',
                      'Compitition'
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () => filterEventsByCategory(category),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedCategory == category
                                ? Color(0xFF19514A)
                                : Color(0xFF2A4F50),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: selectedCategory == category ? 8 : 4,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: selectedCategory == category
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Events List
              Text(
                '📌 All Department Events',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A4F50)),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var range in [
                    'All',
                    'This Week',
                    'Today',
                    'Next Week',
                    'This Month'
                  ])
                    GestureDetector(
                      onTap: () => filterEventsByDateRange(range),
                      child: Text(
                        range,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedDateRange == range
                              ? Color(0xFF3B6B6D)
                              : Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
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
                        onPressed: _addToInterestedEvents,
                        icon: _isLoading
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent),
                          ),
                        )
                            : Icon(Icons.star, color: Colors.blueAccent),
                        label: Text(
                          _isLoading ? "Adding..." : "Interested",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: availableSeats > 0 ? _reserveSeat : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text("Reserve My Seat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
