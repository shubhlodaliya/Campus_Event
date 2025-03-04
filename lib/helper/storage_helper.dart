import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/event.dart';

class StorageHelper {
  // Save interested events for a specific user
  static Future<void> saveInterestedEvents(String userId, List<Event> events) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> eventList = events.map((event) => jsonEncode(event.toJson())).toList();
    await prefs.setStringList('interested_$userId', eventList);
  }

  // Load interested events for a specific user
  static Future<List<Event>> loadInterestedEvents(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedEvents = prefs.getStringList('interested_$userId');
    if (storedEvents != null) {
      return storedEvents.map((e) => Event.fromJson(jsonDecode(e))).toList();
    }
    return [];
  }
}

