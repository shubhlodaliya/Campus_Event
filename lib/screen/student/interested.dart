import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class InterestedPage extends StatefulWidget {
  @override
  _InterestedPageState createState() => _InterestedPageState();
}

class _InterestedPageState extends State<InterestedPage> {
  List<Map<String, String>> _interestedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadInterestedEvents();
  }

  Future<void> _loadInterestedEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedEvents = prefs.getStringList('interestedEvents') ?? [];

    setState(() {
      _interestedEvents = savedEvents
          .map((eventJson) => Map<String, String>.from(jsonDecode(eventJson)))
          .toList();
    });
  }

  Future<void> _removeEvent(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedEvents = prefs.getStringList('interestedEvents') ?? [];

    savedEvents.removeAt(index);
    await prefs.setStringList('interestedEvents', savedEvents);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "Interested Events",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: _interestedEvents.isEmpty
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                title: Text(
                  event['eventName'] ?? "No Name",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blueAccent),
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   'assets/images/empty.png',
          //   width: 200,
          // ),
          // SizedBox(height: 20),
          Text(
            "No interested events yet!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),
          ),
          SizedBox(height: 8),
          Text(
            "Explore and add events you're interested in.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
