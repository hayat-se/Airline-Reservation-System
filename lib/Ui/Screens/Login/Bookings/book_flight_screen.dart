import 'package:airline_reservation_system/Ui/Screens/Login/Bookings/search_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app_colors.dart';
import '../../../Widgets/app_drawer.dart';
import '../../../Widgets/passenger_picker.dart';


class BookFlightScreen extends StatefulWidget {
  const BookFlightScreen({super.key});

  @override
  State<BookFlightScreen> createState() => _BookFlightScreenState();
}

class _BookFlightScreenState extends State<BookFlightScreen> {
  final _fromCtrl = TextEditingController();
  final _toCtrl   = TextEditingController();

  DateTime? _departDate;
  DateTime? _returnDate;

  int _passengers = 1;
  String _travelClass = 'Economy';

  /* ───────────────────────────── Helpers ───────────────────────────── */

  Future<void> _pickDate({required bool isDepart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isDepart ? (_departDate ?? now) : (_returnDate ?? now),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isDepart) {
          _departDate = picked;
          // auto‑adjust return date if it’s before depart date
          if (_returnDate != null && _returnDate!.isBefore(_departDate!)) {
            _returnDate = _departDate;
          }
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _openPassengerPicker() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => PassengerPicker(
        passengers: _passengers,
        travelClass: _travelClass,
      ),
    );
    if (result != null) {
      setState(() {
        _passengers   = result['passengers'] as int;
        _travelClass  = result['class']      as String;
      });
    }
  }

  void _searchFlights() {
    if (_fromCtrl.text.isEmpty ||
        _toCtrl.text.isEmpty ||
        _departDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultScreen(
          from: _fromCtrl.text,
          to: _toCtrl.text,
          departDate: _departDate!,
          returnDate: _returnDate,            // ✅ matches new constructor
          passengers: _passengers,
          travelClass: _travelClass,
          tickets: [],          // ✅ matches new constructor
        ),
      ),
    );
  }

  /* ───────────────────────────── UI ───────────────────────────── */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Flight'),
        backgroundColor: AppColors.primary,
      ),
      drawer: const AppDrawer(), // if you already implemented it
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _FlightField(
              label: 'From',
              controller: _fromCtrl,
              icon: Icons.flight_takeoff,
            ),
            const SizedBox(height: 15),
            _FlightField(
              label: 'To',
              controller: _toCtrl,
              icon: Icons.flight_land,
            ),
            const SizedBox(height: 25),

            /* ─── Dates ─── */
            Row(
              children: [
                Expanded(
                  child: _DateTile(
                    label: 'Departure',
                    date: _departDate,
                    onTap: () => _pickDate(isDepart: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateTile(
                    label: 'Return',
                    date: _returnDate,
                    onTap: () => _pickDate(isDepart: false),
                    optional: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            /* ─── Passengers / Class ─── */
            ListTile(
              onTap: _openPassengerPicker,
              leading: Icon(Icons.people_outline, color: AppColors.primary),
              title: Text('$_passengers Passenger${_passengers > 1 ? 's' : ''}'),
              subtitle: Text(_travelClass),
              trailing: const Icon(Icons.chevron_right),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _searchFlights,
              child: const Text('Search Flights', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────────── Widgets ───────────────────────────── */

class _FlightField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;

  const _FlightField({
    required this.label,
    required this.controller,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primary),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final bool optional;

  const _DateTile({
    required this.label,
    required this.date,
    required this.onTap,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM, y');
    return ListTile(
      onTap: onTap,
      leading: Icon(Icons.calendar_month, color: AppColors.primary),
      title: Text(label),
      subtitle: Text(
        date != null ? df.format(date!) : (optional ? '—' : 'Select date'),
        style: TextStyle(
          color: date != null || optional ? Colors.black : Colors.redAccent,
        ),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
