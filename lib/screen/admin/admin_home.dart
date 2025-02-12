import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../login_page.dart';
import 'add_event_detail.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  List<Map<String, dynamic>> events = []; // Store fetched events

  @override
  void initState() {
    super.initState();
    fetchEvents(); // Load events when screen starts
  }

  // Fetch events from the API
  Future<void> fetchEvents() async {
    const String apiUrl = "http://192.168.179.47:3000/api/events"; // Update with your API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> eventData = jsonDecode(response.body);
        setState(() {
          events = List<Map<String, dynamic>>.from(eventData);
        });
      } else {
        print('Failed to fetch events');
      }
    } catch (e) {
      print('Error fetching events: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B6B6D),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Text('Events')),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => logout(context),
              tooltip: 'Logout',
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: events.isEmpty
            ? Center(
          child: Text(
            'No events added yet.',
            style: TextStyle(fontSize: 18, color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        )
            : ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(event['eventName'], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Organized By: ${event['organizedBy']}'),
                    Text('Date: ${event['date']}'),
                    Text('Time: ${event['time']}'),
                    Text('Venue: ${event['venue']}'),
                  ],
                ),
                trailing: Icon(Icons.event, color: Colors.teal),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF80C3C1),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEventDetailPage()),
          );
          fetchEvents(); // Refresh event list after adding an event
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: Color(0xFFFDF6E4),
    );
  }
}

void main() => runApp(MaterialApp(
  home: AddEventScreen(),
));
