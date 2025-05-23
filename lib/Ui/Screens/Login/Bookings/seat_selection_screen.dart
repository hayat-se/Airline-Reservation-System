import 'package:airline_reservation_system/Ui/Screens/Login/Bookings/ticket_screen.dart';
import 'package:flutter/material.dart';

import '../payment/payment_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  String? selectedSeat;

  final List<String> seats = [
    '1A', '1B', '1C', '1D',
    '2A', '2B', '2C', '2D',
    '3A', '3B', '3C', '3D',
    '4A', '4B', '4C', '4D',
    '5A', '5B', '5C', '5D',
    '6A', '6B', '6C', '6D',
  ];

  final List<String> reservedSeats = ['2C', '3D', '4C'];
  final List<String> emergencyExitSeats = ['5A', '5B', '5C', '5D'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Seat'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),

          // ✈️ Plane nose icon
          const Icon(Icons.airplanemode_active, size: 40, color: Colors.grey),

          const SizedBox(height: 16),

          _legend(),

          const SizedBox(height: 16),

          // ✈️ Seat grid with aisle gap
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, rowIndex) {
                  final rowSeats = [
                    seats[rowIndex * 4],
                    seats[rowIndex * 4 + 1],
                    seats[rowIndex * 4 + 2],
                    seats[rowIndex * 4 + 3],
                  ];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // First 2 seats
                        for (int i = 0; i < 2; i++)
                          _buildSeatBox(rowSeats[i]),

                        // Aisle gap
                        const SizedBox(width: 24),

                        // Last 2 seats
                        for (int i = 2; i < 4; i++)
                          _buildSeatBox(rowSeats[i]),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Confirm Button
          Padding(
            padding: const EdgeInsets.all(30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: selectedSeat == null
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(resSeat: selectedSeat!,),
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatBox(String seat) {
    final isSelected = selectedSeat == seat;
    final isReserved = reservedSeats.contains(seat);
    final isEmergency = emergencyExitSeats.contains(seat);

    Color color;
    if (isReserved) {
      color = Colors.grey.shade300;
    } else if (isEmergency) {
      color = Colors.brown.shade400;
    } else if (isSelected) {
      color = Colors.red;
    } else {
      color = Colors.white;
    }

    return GestureDetector(
      onTap: isReserved
          ? null
          : () {
        setState(() {
          selectedSeat = seat;
        });
      },
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          seat,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isReserved ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _legend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.red, 'Selected'),
        const SizedBox(width: 16),
        _legendItem(Colors.brown, 'Emergency exit'),
        const SizedBox(width: 16),
        _legendItem(Colors.grey.shade300, 'Reserved'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
