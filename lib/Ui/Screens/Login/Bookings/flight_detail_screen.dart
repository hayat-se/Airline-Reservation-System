import 'package:flutter/material.dart';
import '../../../../Data/Providers/Models/ticket.dart';
import 'seat_selection_screen.dart';

class FlightDetailScreen extends StatelessWidget {
  final Ticket ticket;

  const FlightDetailScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Flight Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Airline Header
                  Column(
                    children: [
                      const Icon(Icons.flight, size: 48, color: Colors.orange),
                      const SizedBox(height: 8),
                      Text(
                        ticket.airline,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ticket.flightNumber,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),

                  // Flight times
                  _infoRow('Departure', ticket.departTime, ticket.fromCode),
                  _infoRow('Arrival', ticket.arriveTime, ticket.toCode),
                  _infoRow('Duration', ticket.duration, ''),

                  const Divider(height: 32),

                  // Price section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Price Details',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const Text('Total Price',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            SizedBox(width: 150,),
                            const Icon(Icons.attach_money,
                                size: 50, color: Colors.black),
                            Text(
                              ticket.price.toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () async {
                      final selectedSeat = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SeatSelectionScreen(),
                        ),
                      );
                      // You can handle the selected seat here if needed
                    },
                    child: const Text('Confirm',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String time, String code) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Row(
            children: [
              Text(
                time,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (code.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(code, style: const TextStyle(color: Colors.grey)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
