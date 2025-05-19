import 'package:flutter/material.dart';

import '../../../../Data/Providers/Models/ticket.dart';

class FlightDetailScreen extends StatelessWidget {
  final Ticket ticket;

  const FlightDetailScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Airline “logo” placeholder
            Center(
              child: Column(
                children: [
                  const Icon(Icons.flight, size: 42, color: Colors.orange),
                  const SizedBox(height: 6),
                  Text(ticket.airline,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Times
            _timeRow('Departure', ticket.departTime, ticket.fromCode),
            _timeRow('Arrival', ticket.arriveTime, ticket.toCode),
            _timeRow('Duration', ticket.duration, ''),

            const Divider(height: 40),

            // Price
            Text('Price',
                style: TextStyle(
                    color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text('\$${ticket.price.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange)),
            const Spacer(),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      // TODO: continue to seat‑selection / payment
                    },
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _timeRow(String label, String time, String code) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          Row(
            children: [
              Text(time,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              if (code.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(code, style: const TextStyle(color: Colors.grey)),
              ]
            ],
          )
        ],
      ),
    );
  }
}
