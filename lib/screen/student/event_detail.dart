// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: EventDetailsPage(),
//   ));
// }
//
// class EventDetailsPage extends StatelessWidget {
//   const EventDetailsPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Hand on Workshop'),
//         backgroundColor: Colors.teal,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(0),
//           child: Column(
//             children: [
//               Column(
//                 children: [
//                   const Image(image: AssetImage('assets/images/event.png')),
//                   Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: const [
//                             Icon(Icons.edit, size: 35),
//                             SizedBox(width: 8),
//                             Text(
//                               'Hand on Workshop',
//                               style: TextStyle(
//                                   fontSize: 25, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: const [
//                             Icon(Icons.calendar_today, size: 35),
//                             SizedBox(width: 8),
//                             Text(
//                               '27, December 2024\n10:00 AM',
//                               style: TextStyle(fontSize: 25),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: const [
//                             Icon(Icons.location_on, size: 35),
//                             SizedBox(width: 8),
//                             Text(
//                               'Charusat, Gujarat',
//                               style: TextStyle(fontSize: 25),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: const [
//                             Icon(Icons.person, size: 35),
//                             SizedBox(width: 8),
//                             Text(
//                               'Special guest',
//                               style: TextStyle(fontSize: 25),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: const [
//                             Icon(Icons.star, size: 35),
//                             SizedBox(width: 8),
//                             Text(
//                               '19+ attending',
//                               style: TextStyle(fontSize: 25),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             ElevatedButton.icon(
//                               onPressed: () {},
//                               icon: const Icon(
//                                 Icons.star,
//                                 color: Colors.white,
//                               ),
//                               label: const Text(
//                                 'Interested',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.teal,
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 16),
//                               ),
//                             ),
//                             OutlinedButton.icon(
//                               onPressed: () {},
//                               icon: const Icon(Icons.share),
//                               label: const Text('Share'),
//                               style: OutlinedButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 16),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: () {},
//                             child: const Text(
//                               'Attendee',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.teal,
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         const Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'About >>',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         const Text(
//                           'All detail description about event........',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: EventDetailsPage(),
//   ));
// }
//
// class EventDetailsPage extends StatefulWidget {
//   const EventDetailsPage({Key? key}) : super(key: key);
//
//   @override
//   _EventDetailsPageState createState() => _EventDetailsPageState();
// }
//
// class _EventDetailsPageState extends State<EventDetailsPage> {
//   // Variables to hold event data
//   String eventName = '';
//   String date = '';
//   String time = '';
//   String venue = '';
//   String guest = '';
//   String description = '';
//   bool isLoading = true;
//
//   // Function to fetch data from API
//   Future<void> fetchEventData() async {
//     const apiUrl = 'http://192.168.235.47:3000/api/events'; // Replace with your API URL
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         // Ensure the structure of your API response matches this logic
//         if (data != null && data.isNotEmpty) {
//           setState(() {
//             eventName = data['eventName'];
//             date = data['date'];
//             time = data['time'];
//             venue = data['venue'];
//             guest = data['guest'];
//             description = data['description'];
//             isLoading = false;
//           });
//         } else {
//           throw Exception('No data available');
//         }
//       } else {
//         throw Exception('Failed to load event data');
//       }
//     } catch (e) {
//       print('Error: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchEventData(); // Fetch data on widget initialization
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Event Details'),
//         backgroundColor: Colors.teal,
//       ),
//       body: isLoading
//           ? const Center(
//         child: CircularProgressIndicator(),
//       )
//           : SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Image(image: AssetImage('assets/images/event.png')),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(Icons.edit, size: 35),
//                         const SizedBox(width: 8),
//                         Text(
//                           eventName,
//                           style: const TextStyle(
//                             fontSize: 25,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         const Icon(Icons.calendar_today, size: 35),
//                         const SizedBox(width: 8),
//                         Text(
//                           '$date\n$time',
//                           style: const TextStyle(fontSize: 25),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, size: 35),
//                         const SizedBox(width: 8),
//                         Text(
//                           venue,
//                           style: const TextStyle(fontSize: 25),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         const Icon(Icons.person, size: 35),
//                         const SizedBox(width: 8),
//                         Text(
//                           guest,
//                           style: const TextStyle(fontSize: 25),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Row(
//                       children: [
//                         Icon(Icons.star, size: 35),
//                         SizedBox(width: 8),
//                         Text(
//                           '19+ attending',
//                           style: TextStyle(fontSize: 25),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'About >>',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       description,
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../model/event.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EventDetailsPage(),
  ));
}
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
      image: json['image'], // Nullable field
    );
  }
}
class EventDetailsPage extends StatefulWidget {
  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  List<Event> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEventData(); // Fetch events when the page loads
  }

  Future<void> fetchEventData() async {
    try {
      // Fetch events
      final List<Event> fetchedEvents = await fetchEventDataFromApi();
      setState(() {
        events = fetchedEvents; // Update the state with fetched events
        isLoading = false; // Stop the loading indicator
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading even if there's an error
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
      return data.map((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : events.isEmpty
          ? const Center(child: Text('No events found'))
          : ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  event.image != null && event.image!.isNotEmpty
                      ? Image.network(event.image!,
                      height: 200, fit: BoxFit.cover)
                      : const Placeholder(fallbackHeight: 200),
                  const SizedBox(height: 16),
                  Text(
                    event.eventName,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Organized By: ${event.organizedBy}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Department: ${event.department}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Date: ${event.date}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Time: ${event.time}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Venue: ${event.venue}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Guest: ${event.guest}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}