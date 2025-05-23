import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<Map<String, dynamic>> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookingsJson = prefs.getString('my_bookings');

    if (bookingsJson != null) {
      final List<dynamic> decoded = jsonDecode(bookingsJson);
      // cast to List<Map<String, dynamic>>
      _bookings = decoded.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      _bookings = [];
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _deleteBooking(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Booking'),
        content: const Text('Are you sure you want to delete this booking?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _bookings.removeAt(index);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('my_bookings', jsonEncode(_bookings));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.orange,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
          ? const Center(
        child: Text(
          'No bookings found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final booking = _bookings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(
                booking['airline'] ?? 'Unknown Airline',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text('From: ${booking['fromCode'] ?? '-'}'),
                  Text('To: ${booking['toCode'] ?? '-'}'),
                  Text('Departure: ${booking['departTime'] ?? '-'}'),
                  Text('Arrival: ${booking['arriveTime'] ?? '-'}'),
                  Text('Seat: ${booking['seat'] ?? '-'}'),
                  Text('Booked At: ${_formatDate(booking['bookedAt'])}'),
                  Text('Price: \$${booking['price']?.toStringAsFixed(2) ?? '-'}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _deleteBooking(index),
                tooltip: 'Delete booking',
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String? isoString) {
    if (isoString == null) return '-';
    try {
      final dt = DateTime.parse(isoString);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoString;
    }
  }
}
