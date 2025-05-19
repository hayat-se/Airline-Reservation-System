class Ticket {
  final String airline;          // e.g. “IndiGo”
  final String flightNumber;     // e.g. “6E‑329”
  final String fromCode;         // “DEL”
  final String toCode;           // “CCU”
  final String departTime;       // “05:50”
  final String arriveTime;       // “07:30”
  final String duration;         // “1h 40m”
  final double price;            // 230.0

  const Ticket({
    required this.airline,
    required this.flightNumber,
    required this.fromCode,
    required this.toCode,
    required this.departTime,
    required this.arriveTime,
    required this.duration,
    required this.price,
  });
}
