
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_page.dart';
import 'event_detail.dart';

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
    const String apiUrl = "http://192.168.179.47:3000/api/events";
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
    return d1.year == d2.year &&
        d1.month == d2.month &&
        d1.day == d2.day;
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

        bool matchesCategory = selectedCategory == "All" ||
            event.catagory == selectedCategory;

        bool matchesDateRange = _matchesDateRange(event.date, selectedDateRange);

        bool matchesSearch = searchController.text.isEmpty ||
            event.eventName.toLowerCase().contains(
                searchController.text.toLowerCase()
            );

        return matchesDepartment && matchesCategory &&
            matchesDateRange && matchesSearch;
      }).toList();
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
              items: ['All', 'CSE', 'CE', 'IT', 'EC', 'ME']
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
                      'Expert talk'
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () => filterEventsByCategory(category),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedCategory == category
                                ? Color(0xFF2A4F50)  // Darker shade when selected
                                : Color(0xFF3B6B6D),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(100, 50),
                            elevation: selectedCategory == category ? 8 : 4,
                          ),
                          child: Text(category,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: selectedCategory == category
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),),
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
                  for (var range in ['All', 'This Week', 'Today', 'Next Week', 'This Month'])
                    GestureDetector(
                      onTap: () => filterEventsByDateRange(range),
                      child: Text(
                        range,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedDateRange == range
                              ? Color(0xFF3B6B6D)  // Highlighted color when selected
                              : Colors.black,  // Default color
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


class EventDetailsPage extends StatelessWidget {
  final Event event;

  EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(event.eventName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image at the top
            ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              child: Image(
                image: AssetImage('assets/images/login1.png'), // Ensure the Event model has an imageUrl property
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
                  // Event Details in Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailRow(icon: Icons.business, label: 'Organized By', value: event.organizedBy),
                          DetailRow(icon: Icons.school, label: 'Department', value: event.department),
                          DetailRow(icon: Icons.calendar_today, label: 'Date', value: event.date),
                          DetailRow(icon: Icons.access_time, label: 'Time', value: event.time),
                          DetailRow(icon: Icons.location_on, label: 'Venue', value: event.venue),
                          DetailRow(icon: Icons.person, label: 'Guest', value: event.guest),
                          DetailRow(icon: Icons.category, label: 'Catagory', value: event.catagory),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Description Section
                  Text('Description:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(height: 5),
                  Text(event.description, style: TextStyle(fontSize: 16)),

                  // Buttons Section
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.star_border),
                        label: Text("Interested"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.share),
                        label: Text("Share"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text("Find Tickets", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
