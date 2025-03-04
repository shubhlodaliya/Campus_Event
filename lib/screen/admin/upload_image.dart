import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageUploadScreen extends StatefulWidget {
  final String eventId; // Pass the event ID to associate the image with the event

  ImageUploadScreen({required this.eventId});

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Replace 'http://192.168.179.47:3000/api/upload' with your API endpoint
      final url = Uri.parse('http://192.168.102.47:3000/api/upload');

      // Create a multipart request
      var request = http.MultipartRequest('POST', url);

      // Add the image file to the request
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully!')),
        );
        Navigator.pop(context); // Return to the previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image == null
                    ? Center(
                  child: Text(
                    'Tap to select an image',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _uploadImage,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}