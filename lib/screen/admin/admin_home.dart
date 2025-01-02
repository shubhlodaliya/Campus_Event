import 'package:flutter/material.dart';

import 'add_event_detail.dart';

class AddEventScreen extends StatelessWidget {
  final List<String> categories = ['All', 'Work', 'Personal', 'Others'];

  @override
  Widget build(BuildContext context) {
    String selectedCategory = categories[0]; // Default value

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B6B6D),
        title: Text(
          'ADD event',
          style: TextStyle(
            fontFamily: 'Cursive', // Customize font if required
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down),
              underline: Container(
                height: 1,
                color: Colors.grey,
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  selectedCategory = newValue;
                  print('Selected Category: $newValue');
                }
              },
              items: categories
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 50),
            Text(
              'No added any event',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEventDetailPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF80C3C1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Add Event',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFFDF6E4),
    );
  }
}

void main() => runApp(MaterialApp(
  home: AddEventScreen(),
));
