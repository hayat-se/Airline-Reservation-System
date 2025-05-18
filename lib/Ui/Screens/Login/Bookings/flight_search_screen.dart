import 'package:flutter/material.dart';

import '../../../../app_colors.dart';
import '../../../Widgets/app_drawer.dart';
import '../../../Widgets/form_tile.dart';


class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  String from = '';
  String to = '';
  DateTime? depart;
  int pax = 1;
  String cabin = 'Economy';

  Future<void> _selectAirport(bool isFrom) async {
    final list = ['DEL • Delhi', 'BOM • Mumbai', 'BLR • Bengaluru'];
    final picked = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => ListView(
        children: list
            .map((a) => ListTile(
          title: Text(a),
          onTap: () => Navigator.pop(context, a),
        ))
            .toList(),
      ),
    );
    if (picked != null) setState(() => isFrom ? from = picked : to = picked);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: depart ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (c, child) => Theme(
        data: Theme.of(c).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.orange),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => depart = picked);
  }

  void _pickCabin() {
    const classes = ['Economy', 'Premium Economy', 'Business', 'First'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => ListView(
        children: classes
            .map((c) => ListTile(
          title: Text(c),
          onTap: () {
            setState(() => cabin = c);
            Navigator.pop(context);
          },
        ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      drawer: const AppDrawer(selected: 'home'),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text('Book Flight',
            style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
        child: Column(
          children: [
            SizedBox(height: 50,),
            FormTile(
              icon: Icons.flight_takeoff,
              label: 'From',
              value: from,
              onTap: () => _selectAirport(true),
            ),
            FormTile(
              icon: Icons.flight_land,
              label: 'To',
              value: to,
              onTap: () => _selectAirport(false),
            ),
            FormTile(
              icon: Icons.calendar_today,
              label: 'Departure Date',
              value: depart == null
                  ? ''
                  : '${depart!.day}/${depart!.month}/${depart!.year}',
              onTap: _pickDate,
            ),
            FormTile(
              icon: Icons.event_seat,
              label: 'Class',
              value: cabin,
              onTap: _pickCabin,
            ),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.lightGrey,
                  child: const Icon(Icons.person, color: AppColors.orange),
                ),
                title: const Text('Passengers',
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                subtitle: Text('$pax',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: pax > 1 ? () => setState(() => pax--) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() => pax++),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: (from.isNotEmpty &&
                    to.isNotEmpty &&
                    depart != null)
                    ? () {
                  // TODO: Navigate to results screen
                }
                    : null,
                child: const Text('Search Flights',
                    style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
