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
    const String apiUrl = "http://192.168.102.47:3000/api/events";
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InterestedPage()),
          );
          break;
        case 2:
          Navigator.push(
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
        backgroundColor: Color(0xFF3B6B6D),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: selectedDepartment,
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: SizedBox(),
              style: TextStyle(color: Colors.white, fontSize: 16),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  filterEventsByDepartment(newValue);
                }
              },
              items: ['All', 'CSE', 'CE', 'IT', 'EC', 'ME', 'AIML']
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF3B6B6D),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Interested',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex1,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            backgroundColor: Color(0xFF3B6B6D),
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
              TextField(
                controller: searchController,
                onChanged: filterEvents,
                decoration: InputDecoration(
                  hintText: 'Search an Event ...',
                  prefixIcon: Icon(Icons.search, color: Color(0xFF3B6B6D)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20),
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
                      'All', // Add 'All' option
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
                                ? Color(
                                    0xFF2A4F50) // Darker shade when selected
                                : Color(0xFF3B6B6D),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(100, 50),
                            elevation: selectedCategory == category ? 8 : 4,
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 18,
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
                              ? Color(
                                  0xFF3B6B6D) // Highlighted color when selected
                              : Colors.black, // Default color
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredEvents.isEmpty
                      ? Center(child: Text('No events found'))
                      : Column(
                          children: filteredEvents.map((event) {
                            return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF3B6B6D),
                                      Color(0xFF3B6B6D)
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
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '📅 Date: ${event.date}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  trailing: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Color(0xFF3B6B6D),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
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

📝 Description: ${widget.event.description}

Don't miss out! 🚀
''';



    await Share.share(subject: "Event Details",sharePositionOrigin: Rect.fromLTWH(0, 0, 0, 0),eventDetails
      // title: widget.event.eventName,
      // text: eventDetails,ś
      // linkUrl: '', // Add a registration link if available
      // chooserTitle: 'Share Event Details',
    );
  }

  Future<void> _addToInterestedEvents() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> interestedEvents = prefs.getStringList('interestedEvents') ?? [];

    // Convert event to JSON format and store it
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
                        onPressed: _shareEventDetails, // Call the share function
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
