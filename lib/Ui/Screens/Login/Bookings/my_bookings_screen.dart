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
      _bookings = decoded.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
          ? const Center(child: Text('No bookings found'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final booking = _bookings[index];
          return _buildTicketCard(booking);
        },
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          // Airline Logo (Placeholder)
          Center(
            child: Image.asset(
              'assets/images/indigo.png', // Replace with dynamic image if available
              height: 40,
            ),
          ),
          const SizedBox(height: 20),

          // Route Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeColumn(booking['departTime'] ?? '-', booking['fromCode'] ?? '-', booking['fromAirport'] ?? ''),
              const Icon(Icons.flight_takeoff_rounded, color: Colors.redAccent),
              _buildTimeColumn(booking['arriveTime'] ?? '-', booking['toCode'] ?? '-', booking['toAirport'] ?? ''),
            ],
          ),
          const SizedBox(height: 20),

          // Date & Time Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoBox(Icons.calendar_today_outlined, _formatDate(booking['bookedAt'])),
              _infoBox(Icons.access_time_filled_rounded, booking['departTime'] ?? '-'),
            ],
          ),
          const SizedBox(height: 20),

          // Flight details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _flightDetail('Flight', booking['flightNo'] ?? 'IN 230'),
              _flightDetail('Gate', booking['gate'] ?? '22'),
              _flightDetail('Seat', booking['seat'] ?? '-'),
              _flightDetail('Class', booking['class'] ?? 'Economy'),
            ],
          ),
          const SizedBox(height: 20),

          // Modify Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Modify', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(String time, String code, String airport) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(time, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(code, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
        SizedBox(
          width: 90,
          child: Text(
            airport,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _infoBox(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _flightDetail(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  String _formatDate(String? isoString) {
    if (isoString == null) return '-';
    try {
      final dt = DateTime.parse(isoString);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return isoString;
    }
  }
}
