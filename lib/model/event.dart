
import 'package:http/http.dart' as http;
import 'dart:convert';
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
      seats: json['seats'] ?? 0,  // Nullable field
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'department': department,
      'eventName': eventName,
      'organizedBy': organizedBy,
      'description': description,
      'date': date,
      'time': time,
      'venue': venue,
      'guest': guest,
      'catagory': catagory,
      'email': email,      // ✅ Added Email
      'mobile': mobile,    // ✅ Added Mobile
      'seats': seats,
    };
  }
}
String department = 'N/A';
String image = '';
String eventName = 'N/A';
String organizedBy = 'N/A';
String description = 'N/A';
String date = 'N/A';
String time = 'N/A';
String venue = 'N/A';
String guest = 'N/A';
String catagory = 'N/A';
String email = 'N/A';
String mobile = 'N/A';
int seats = 0;

bool isLoading = true;
Future<List<Event>> fetchEventData() async {
  const String apiUrl = "http://192.168.137.47:3000/api/events";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      // Check if success is true and data exists
      if (responseBody['success'] == true) {
        List<dynamic> eventsJson = responseBody['data'];
        return eventsJson.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch events: ${responseBody['message']}");
      }
    } else {
      throw Exception("Failed to fetch events with status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error: $e");
  }
}
