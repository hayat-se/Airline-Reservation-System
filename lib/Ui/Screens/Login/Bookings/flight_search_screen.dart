// lib/Ui/Screens/Login/Bookings/flight_search_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../Data/Providers/Models/ticket.dart';
import '../../../Widgets/location_picker_field.dart';
import 'search_result_screen.dart';

// NEW: shared navigation drawer
import '../../../Widgets/app_drawer.dart';   // adjust the path if your folder differs

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  DateTime _departDate = DateTime.now().add(const Duration(days: 1));
  DateTime? _returnDate;
  int _passengers = 1;
  String _travelClass = 'Economy';

  final _df = DateFormat('dd MMM yyyy');

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  /// sample tickets – replace with your API call
  final _sampleTickets = const [
    Ticket(
        airline: 'Indigo',
        flightNumber: '6E‑221',
        fromCode: 'DXB',
        toCode: 'LHR',
        departTime: '05:30',
        arriveTime: '10:20',
        duration: '7h 50m',
        price: 230),
    Ticket(
        airline: 'Qatar',
        flightNumber: 'QR‑102',
        fromCode: 'DXB',
        toCode: 'LHR',
        departTime: '11:15',
        arriveTime: '16:05',
        duration: '7h 50m',
        price: 255),
  ];

  // ───────────────────────── date pickers
  Future<void> _pickDepartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _departDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _departDate = picked);
  }

  Future<void> _pickReturnDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _returnDate ?? _departDate.add(const Duration(days: 3)),
      firstDate: _departDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _returnDate = picked);
  }

  void _search() {
    if (_fromCtrl.text.isEmpty || _toCtrl.text.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultScreen(
          from: _fromCtrl.text,
          to: _toCtrl.text,
          departDate: _departDate,
          returnDate: _returnDate,
          passengers: _passengers,
          travelClass: _travelClass,
          tickets: _sampleTickets,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Flight'),
        elevation: 0,
        // the default menu icon will appear on the right because we use endDrawer
      ),

      // NEW: use shared drawer; highlight “flight”
      endDrawer: const AppDrawer(selected: 'flight'),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationPickerField(
              label: 'From',
              controller: _fromCtrl,
              onSelected: (_, __) => setState(() {}),
            ),
            const SizedBox(height: 16),
            LocationPickerField(
              label: 'To',
              controller: _toCtrl,
              onSelected: (_, __) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DateBox(
                    label: 'Departure',
                    date: _departDate,
                    onTap: _pickDepartDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateBox(
                    label: 'Return',
                    date: _returnDate,
                    onTap: _pickReturnDate,
                    placeholder: 'One‑way',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DropdownBox<int>(
                    label: 'Passengers',
                    value: _passengers,
                    items: List.generate(9, (i) => i + 1),
                    stringify: (v) => v.toString(),
                    onChanged: (v) => setState(() => _passengers = v!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DropdownBox<String>(
                    label: 'Class',
                    value: _travelClass,
                    items: const ['Economy', 'Business', 'First'],
                    stringify: (v) => v,
                    onChanged: (v) => setState(() => _travelClass = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _search,
                child: const Text('Search',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────── helper widgets — unchanged
class _DateBox extends StatelessWidget {
  const _DateBox({
    required this.label,
    required this.onTap,
    required this.date,
    this.placeholder,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM');
    return GestureDetector(
      onTap: onTap,
      child: _boxed(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date != null ? df.format(date!) : (placeholder ?? ''),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        label,
      ),
    );
  }

  Widget _boxed(Widget child, String label) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(fontSize: 13, color: Colors.grey)),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: child,
      ),
    ],
  );
}

class _DropdownBox<T> extends StatelessWidget {
  const _DropdownBox({
    required this.label,
    required this.value,
    required this.items,
    required this.stringify,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T) stringify;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return _boxed(
      DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          items: items
              .map(
                (e) => DropdownMenuItem(
              value: e,
              child: Text(stringify(e)),
            ),
          )
              .toList(),
        ),
      ),
      label,
    );
  }

  Widget _boxed(Widget child, String label) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(fontSize: 13, color: Colors.grey)),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: child,
      ),
    ],
  );
}
