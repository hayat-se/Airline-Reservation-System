import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchResultScreen extends StatelessWidget {
  final String from;
  final String to;
  final DateTime departDate;
  final DateTime? returnDate;
  final int passengers;
  final String travelClass;

  const SearchResultScreen({
    super.key,
    required this.from,
    required this.to,
    required this.departDate,
    this.returnDate,
    required this.passengers,
    required this.travelClass,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM yyyy');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Flights'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(from, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const Icon(Icons.flight_takeoff, color: Colors.orange),
                        Text(to, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${df.format(departDate)}${returnDate != null ? ' ↔ ${df.format(returnDate!)}' : ''}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$passengers passenger${passengers > 1 ? 's' : ''} • $travelClass',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Example flight result card
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Example count, replace with actual data count
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('5:50 AM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              Icon(Icons.arrow_forward, color: Colors.orange),
                              Text('7:30 AM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('DEL'),
                              Text('CCU'),
                              Text('\$230', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size.fromHeight(40),
                            ),
                            child: const Text('Check'),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
