import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../Data/Providers/Models/ticket.dart';
import '../../../Widgets/location_picker_field.dart';
import 'search_result_screen.dart';
import '../../../Widgets/app_drawer.dart';

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

  final _df = DateFormat('dd/MM/yyyy');

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  List<Ticket> _generateTickets(String from, String to) {
    final airlines = ['PIA', 'Airblue', 'SereneAir', 'Airsial', 'Fly Jinnah'];
    final baseTimes = [
      {'depart': '05:00', 'arrive': '09:30'},
      {'depart': '08:45', 'arrive': '13:15'},
      {'depart': '12:30', 'arrive': '17:05'},
      {'depart': '15:15', 'arrive': '19:45'},
      {'depart': '19:00', 'arrive': '23:30'},
    ];

    final fromAirport = 'Allama Iqbal Intl';
    final toAirport = 'Jinnah Intl';

    return List.generate(5, (i) {
      final airline = airlines[i];
      final time = baseTimes[i];

      return Ticket(
        airline: airline,
        flightNumber: '${airline.substring(0, 2).toUpperCase()}-${100 + i}',
        fromCode: from.toUpperCase().substring(0, 3),
        toCode: to.toUpperCase().substring(0, 3),
        fromAirport: fromAirport,
        toAirport: toAirport,
        departTime: time['depart']!,
        arriveTime: time['arrive']!,
        duration: '4h 30m',
        flightClass: _travelClass,
        gate: 'G${i + 1}',
        price: 180 + (i * 25),
      );
    });
  }

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

    final dynamicTickets = _generateTickets(_fromCtrl.text, _toCtrl.text);

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
          tickets: dynamicTickets,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Book Flight'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      endDrawer: const AppDrawer(selected: 'flight'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChoiceChip(
                        label: const Text("One way"),
                        selected: true,
                        selectedColor: Colors.orange,
                        labelStyle: const TextStyle(color: Colors.white),
                        onSelected: (_) {},
                      ),
                      ChoiceChip(
                        label: const Text("Round"),
                        selected: false,
                        onSelected: (_) {},
                      ),
                      ChoiceChip(
                        label: const Text("Multicity"),
                        selected: false,
                        onSelected: (_) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                          placeholder: 'Add Return Date',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _DropdownBox<int>(
                          label: 'Traveller',
                          value: _passengers,
                          items: List.generate(3, (i) => i + 1),
                          stringify: (v) => '$v Adult',
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _search,
                      child: const Text('Search',
                          style:
                          TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Hot offer",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("15%OFF",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.orange)),
                        SizedBox(height: 8),
                        Text("15% discount\nwith mastercard"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("23%OFF",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.orange)),
                        SizedBox(height: 8),
                        Text("Visa card special\noffer for flights"),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

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
    final df = DateFormat('dd/MM/yyyy');
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
