import 'package:flutter/material.dart';
import '../../model/event.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(event.eventName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
         // Prevents last button from being cut off
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image
              ClipRRect(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                // child: Image.network(
                //   , // Dynamic event image
                //   width: double.infinity,
                //   height: 220,
                //   fit: BoxFit.cover,
                //   errorBuilder: (context, error, stackTrace) {
                //     return Container(
                //       width: double.infinity,
                //       height: 220,
                //       color: Colors.grey.shade300,
                //       child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                //     );
                //   },
                // ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Organized By
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Text(event.organizedBy[0].toUpperCase(),
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(event.organizedBy,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Event Details in Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DetailRow(icon: Icons.business, label: 'Department', value: event.department),
                            DetailRow(icon: Icons.category, label: 'Category', value: event.catagory),
                            DetailRow(icon: Icons.calendar_today, label: 'Date', value: event.date),
                            DetailRow(icon: Icons.access_time, label: 'Time', value: event.time),
                            DetailRow(icon: Icons.location_on, label: 'Venue', value: event.venue),
                            DetailRow(icon: Icons.person, label: 'Guest', value: event.guest),
                            DetailRow(icon: Icons.email, label: 'Email', value: event.email),
                            DetailRow(icon: Icons.phone, label: 'Mobile', value: event.mobile),
                            DetailRow(icon: Icons.event_seat, label: 'Seats Available', value: event.seats.toString()),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Description
                    Text('Description:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(height: 5),
                    Text(event.description, style: TextStyle(fontSize: 16)),

                    // Buttons
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
                            foregroundColor: Color(0xFF3B6B6D),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.share),
                          label: Text("Share"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF3B6B6D),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Find Tickets Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3B6B6D),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text("Find Tickets", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),

                    SizedBox(height: 15),

                    // Reserve My Seat Button
                    ElevatedButton(
                      onPressed: () {
                        print("Seat Reserved!"); // Debugging log
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text("Reserve My Seat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

// Widget for Detail Row with Icon
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailRow({Key? key, required this.icon, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: '$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
