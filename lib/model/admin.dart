//
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// import 'event.dart';
//
// final _formKey = GlobalKey<FormState>();
// final ImagePicker _picker = ImagePicker();
// File? image;
// String? department;
// String? eventName;
// String? organizedBy;
// String? description;
// String? date;
// String? time;
// String? venue;
// String? guest;
// Future<void> submitData() async {
//   if (_formKey.currentState!.validate()) {
//     _formKey.currentState!.save();
//
//     const String apiUrl = "http://192.168.179.47:3000/api/events";
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'department': department,
//           'eventName': eventName,
//           'organizedBy': organizedBy,
//           'description': description,
//           'date': date,
//           'time': "06:55:00", // Fix time formatting as needed
//           'venue': venue,
//           'guest': guest,
//         }),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text('Event added successfully!')),
//         // );
//
//         // Call fetchEventData() after successful submission
//         final List<Event> updatedEvents = await fetchEventData();
//
//         // Handle the updated events (e.g., refresh a list or UI)
//         print('Fetched ${updatedEvents.length} events');
//       } else {
//         final responseBody = jsonDecode(response.body);
//         final errorMessage = responseBody['message'] ?? 'Unknown error';
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text('Failed to add event! Error: $errorMessage')),
//         // );
//       }
//     } catch (e) {
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(content: Text('Error: $e')),
//       // );
//     }
//   }
// }
