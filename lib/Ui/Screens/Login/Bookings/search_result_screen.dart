import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Data/Providers/Models/ticket.dart';
import 'flight_detail_screen.dart';

class SearchResultScreen extends StatelessWidget {
  final String from;
  final String to;
  final DateTime departDate;
  final DateTime? returnDate;
  final int passengers;
  final String travelClass;
  final List<Ticket> tickets;

  const SearchResultScreen({
    super.key,
    required this.from,
    required this.to,
    required this.departDate,
    this.returnDate,
    required this.passengers,
    required this.travelClass,
    required this.tickets,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Search Result',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // ── summary tile on top ─────────────────────────────
          _SearchHeader(
            df: df,
            from: from,
            to: to,
            departDate: departDate,
            returnDate: returnDate,
            passengers: passengers,
            travelClass: travelClass,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              itemCount: tickets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _TicketCard(
                ticket: tickets[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FlightDetailScreen(ticket: tickets[i]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────── Search Header
class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.df,
    required this.from,
    required this.to,
    required this.departDate,
    required this.returnDate,
    required this.passengers,
    required this.travelClass,
  });

  final DateFormat df;
  final String from, to;
  final DateTime departDate;
  final DateTime? returnDate;
  final int passengers;
  final String travelClass;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(from,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
              const Spacer(),
              const Icon(Icons.flight_takeoff_rounded,
                  color: Colors.orange, size: 22),
              const Spacer(),
              Text(to,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${df.format(departDate)}'
                '${returnDate != null ? '  •  ${df.format(returnDate!)}' : ''}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            '$passengers Pax  •  $travelClass',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────── Ticket Card
class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.ticket,
    required this.onTap,
  });

  final Ticket ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(18),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // airline row
              Row(
                children: [
                  const Icon(Icons.flight, color: Colors.orange, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '${ticket.airline}  •  ${ticket.flightNumber}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // times row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _timeBlock(ticket.departTime, ticket.fromCode),
                  Column(
                    children: [
                      const Icon(Icons.linear_scale_rounded,
                          color: Colors.grey, size: 20),
                      Text(ticket.duration,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  _timeBlock(ticket.arriveTime, ticket.toCode),
                ],
              ),
              const SizedBox(height: 18),
              // price + CTA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${ticket.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.orange,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(100, 40),
                    ),
                    onPressed: onTap,
                    child: const Text('Check'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeBlock(String time, String code) => Column(
    children: [
      Text(time,
          style:
          const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const SizedBox(height: 2),
      Text(code,
          style: const TextStyle(fontSize: 14, color: Colors.grey)),
    ],
  );
}
