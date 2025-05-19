// lib/widgets/location_picker_field.dart
import 'package:flutter/material.dart';

typedef OnLocationSelected = void Function(String code, String city);

class LocationPickerField extends StatelessWidget {
  const LocationPickerField({
    super.key,
    required this.label,
    required this.controller,
    required this.onSelected,
  });

  final String label;
  final TextEditingController controller;
  final OnLocationSelected onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await showModalBottomSheet<_Airport>(
          context: context,
          isScrollControlled: true,
          builder: (_) => const _AirportPickerSheet(),
        );
        if (result != null) {
          controller.text = result.code;         // show IATA code in field
          onSelected(result.code, result.city);  // let parent know
        }
      },
      child: IgnorePointer(            // so TextField doesn’t grab focus
        child: _boxed(
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Select location',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _boxed(Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(fontSize: 13, color: Colors.grey)),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
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

// ───────────────────────────────────────── modal sheet  + simple data
class _AirportPickerSheet extends StatefulWidget {
  const _AirportPickerSheet();

  @override
  State<_AirportPickerSheet> createState() => _AirportPickerSheetState();
}

class _AirportPickerSheetState extends State<_AirportPickerSheet> {
  final _searchCtrl = TextEditingController();
  late List<_Airport> _filtered = _allAirports;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_filter);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filter() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _allAirports
          .where((a) =>
      a.code.toLowerCase().contains(q) ||
          a.city.toLowerCase().contains(q) ||
          a.name.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (_, controller) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12 + 16),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search city or airport',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final a = _filtered[i];
                  return ListTile(
                    title: Text('${a.city} • ${a.code}'),
                    subtitle: Text(a.name),
                    onTap: () => Navigator.pop(context, a),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Airport {
  final String code, city, name;
  const _Airport(this.code, this.city, this.name);
}

// very small starter list – extend or load from JSON / API
const _allAirports = [
  _Airport('KHI', 'Karachi', 'Jinnah Int’l Airport'),
  _Airport('LHE', 'Lahore',  'Allama Iqbal Int’l Airport'),
  _Airport('ISB', 'Islamabad', 'Islamabad Int’l Airport'),
  _Airport('DXB', 'Dubai',  'Dubai Int’l Airport'),
  _Airport('DOH', 'Doha',   'Hamad Int’l Airport'),
  _Airport('LHR', 'London', 'Heathrow Airport'),
];
