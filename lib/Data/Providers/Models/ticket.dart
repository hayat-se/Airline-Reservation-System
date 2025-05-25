class Ticket {
  final String airline;          // e.g. “IndiGo”
  final String flightNumber;     // e.g. “6E‑329”
  final String fromCode;         // “DEL”
  final String toCode;           // “CCU”
  final String fromAirport;      // “Indira Gandhi Intl”
  final String toAirport;        // “Netaji Subhas Intl”
  final String departTime;       // “05:50”
  final String arriveTime;       // “07:30”
  final String duration;         // “1h 40m”
  final String flightClass;      // “Economy”
  final String? gate;            // Optional gate info
  final double price;            // 230.0

  const Ticket({
    required this.airline,
    required this.flightNumber,
    required this.fromCode,
    required this.toCode,
    required this.fromAirport,
    required this.toAirport,
    required this.departTime,
    required this.arriveTime,
    required this.duration,
    required this.flightClass,
    this.gate,
    required this.price,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      airline: json['airline'],
      flightNumber: json['flightNumber'],
      fromCode: json['fromCode'],
      toCode: json['toCode'],
      fromAirport: json['fromAirport'],
      toAirport: json['toAirport'],
      departTime: json['departTime'],
      arriveTime: json['arriveTime'],
      duration: json['duration'],
      flightClass: json['flightClass'],
      gate: json['gate'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airline': airline,
      'flightNumber': flightNumber,
      'fromCode': fromCode,
      'toCode': toCode,
      'fromAirport': fromAirport,
      'toAirport': toAirport,
      'departTime': departTime,
      'arriveTime': arriveTime,
      'duration': duration,
      'flightClass': flightClass,
      'gate': gate,
      'price': price,
    };
  }
}
