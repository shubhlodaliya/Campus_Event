import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../admin/add_event_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organizer Module',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OrganizerHomePage(),
    );
  }
}

class OrganizerHomePage extends StatefulWidget {
  @override
  _OrganizerHomePageState createState() => _OrganizerHomePageState();
}

class _OrganizerHomePageState extends State<OrganizerHomePage> {
  List<Map<String, String>> interestedStudents = [];

  @override
  void initState() {
    super.initState();
    _loadInterestedStudents();
  }

  Future<void> _loadInterestedStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedStudents = prefs.getStringList('interestedStudents') ?? [];

    setState(() {
      interestedStudents = storedStudents.map((e) => jsonDecode(e)).cast<Map<String, String>>().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Organizer Dashboard')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: interestedStudents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(interestedStudents[index]['eventName'] ?? ''),
                  subtitle: Text(interestedStudents[index]['email'] ?? ''),
                  leading: Icon(Icons.person),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddEventDetailPage()));
              },
              child: Text('Add Event'),
            ),
          ),
        ],
      ),
    );
  }
}

