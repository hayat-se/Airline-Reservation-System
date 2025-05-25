import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  final String seat;
  const TicketScreen({super.key, required this.seat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Your Ticket'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // ✈️ Flight Ticket UI
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: const [
                            Text('From',
                                style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Spacer(),
                            Text('To',
                                style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: const [
                            Text('LHE',
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold)),
                            Spacer(),
                            Icon(Icons.flight_takeoff, color: Colors.orange),
                            Spacer(),
                            Text('DXB',
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ticketDetail(label: 'Passenger', value: 'John Doe'),
                            _ticketDetail(label: 'Seat', value: seat),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ticketDetail(label: 'Date', value: '21 May 2025'),
                            _ticketDetail(label: 'Time', value: '12:30 PM'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/bar-code.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Booking ID: ABC12345',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Done'),
            )
          ],
        ),
      ),
    );
  }

  static Widget _ticketDetail({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}


