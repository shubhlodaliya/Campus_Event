
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import '../../model/event.dart';

class AddEventDetailPage extends StatefulWidget {
  @override
  _AddEventDetailPageState createState() => _AddEventDetailPageState();
}

class _AddEventDetailPageState extends State<AddEventDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? image;
  String? department;
  String? eventName;
  String? organizedBy;
  String? description;
  String? date;
  String? time;
  String? venue;
  String? guest;

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }
  //
  // Future<void> submitData() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //
  //     const String apiUrl = "http://192.168.137.47:3000/api/events";
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
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Event added successfully!')),
  //         );
  //       } else {
  //         final responseBody = jsonDecode(response.body);
  //         final errorMessage = responseBody['message'] ?? 'Unknown error';
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Failed to add event! Error: $errorMessage')),
  //         );
  //       }
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: $e')),
  //       );
  //     }
  //   }
  // }
  Future<void> submitData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      const String apiUrl = "http://192.168.179.47:3000/api/events";

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'department': department,
            'eventName': eventName,
            'organizedBy': organizedBy,
            'description': description,
            'date': date,
            'time': "06:55:00", // Fix time formatting as needed
            'venue': venue,
            'guest': guest,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Event added successfully!')),
          );

          // Call fetchEventData() after successful submission
          final List<Event> updatedEvents = await fetchEventData();

          // Handle the updated events (e.g., refresh a list or UI)
          print('Fetched ${updatedEvents.length} events');
        } else {
          final responseBody = jsonDecode(response.body);
          final errorMessage = responseBody['message'] ?? 'Unknown error';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add event! Error: $errorMessage')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Event',
          style: TextStyle(fontFamily: 'Cursive'),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3B6B6D), Color(0xFF3B6B6D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => submitData(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // GestureDetector(
                //   onTap: _pickImage,
                //   child: Card(
                //     elevation: 4,
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                //     child: Container(
                //       height: 150,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         color: Colors.grey[200],
                //       ),
                //       child: Center(
                //         child: image == null
                //             ? Text(
                //           'Tap to select an image',
                //           style: TextStyle(color: Colors.grey, fontSize: 16),
                //         )
                //             : ClipRRect(
                //           borderRadius: BorderRadius.circular(10),
                //           child: Image.file(
                //             image!,
                //             fit: BoxFit.cover,
                //             width: double.infinity,
                //             height: double.infinity,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Department',
                        border: InputBorder.none,
                      ),
                      items: [
                        DropdownMenuItem(value: 'CS', child: Text('Computer Science')),
                        DropdownMenuItem(value: 'IT', child: Text('Information Technology')),
                        DropdownMenuItem(value: 'EC', child: Text('Electronics and Communication')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          department = value;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a department' : null,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _buildTextField('Event Name', (value) => eventName = value, 'Enter event name'),
                SizedBox(height: 16),
                _buildTextField('Organized By', (value) => organizedBy = value, 'Enter organizer name'),
                SizedBox(height: 16),
                _buildTextField('Description', (value) => description = value, 'Enter description', maxLines: 3),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDatePicker('Date', (value) => date = value),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildTimePicker('Time', (value) => time = value),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildTextField('Venue', (value) => venue = value, 'Enter venue'),
                SizedBox(height: 16),
                _buildTextField('Special Guest', (value) => guest = value, 'Enter guest name'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String?) onSave, String validationMessage, {int maxLines = 1}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextFormField(
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          onSaved: onSave,
          validator: (value) => value == null || value.isEmpty ? validationMessage : null,
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, Function(String) onSave) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            onSave(pickedDate.toIso8601String().split('T')[0]);
          });
        }
      },
      readOnly: true,
    );
  }

  Widget _buildTimePicker(String label, Function(String) onSave) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            onSave(pickedTime.format(context));
          });
        }
      },
      readOnly: true,
    );
  }
}

void main() => runApp(MaterialApp(home: AddEventDetailPage()));
