import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Data/Providers/Models/ticket.dart';
import '../Bookings/ticket_screen.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PaymentScreen extends StatefulWidget {
  final String resSeat;
  final Ticket ticket;

  const PaymentScreen({super.key, required this.resSeat, required this.ticket});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _saveCard = false;

  final _expiryFormatter = MaskTextInputFormatter(mask: '##/##');

  Future<void> saveBookingLocally(Ticket ticket, String selectedSeat) async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookingsJson = prefs.getString('my_bookings');

    List<dynamic> bookings = [];
    if (bookingsJson != null) {
      bookings = jsonDecode(bookingsJson);
    }

    bookings.add({
      'airline': ticket.airline,
      'fromCode': ticket.fromCode,
      'toCode': ticket.toCode,
      'fromAirport': ticket.fromAirport,
      'toAirport': ticket.toAirport,
      'departTime': ticket.departTime,
      'arriveTime': ticket.arriveTime,
      'duration': ticket.duration,
      'flightNo': ticket.flightNumber,
      'seat': selectedSeat,
      'class': ticket.flightClass,
      'gate': ticket.gate ?? '22',
      'price': ticket.price,
      'cardHolder': _cardNameController.text,
      'bookedAt': DateTime.now().toIso8601String(),
    });

    await prefs.setString('my_bookings', jsonEncode(bookings));
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Widget _buildField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
        int? maxLength,
        String? hint,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Required';
          if (label == 'Card Number' && value.length < 16) {
            return 'Card number must be 16 digits';
          }
          if (label == 'Expiry Date' &&
              !RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(value.trim())) {
            return 'Enter MM/YY format';
          }
          if (label == 'CVV' && value.length < 3) {
            return 'CVV must be 3 or 4 digits';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          counterText: '',
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Icon(Icons.credit_card_rounded,
                  size: 80, color: Colors.orange),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildField('Cardholder Name', _cardNameController),
                    _buildField(
                      'Card Number',
                      _cardNumberController,
                      hint: '1234 5678 9012 3456',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            'Expiry Date',
                            _expiryDateController,
                            hint: 'MM/YY',
                            keyboardType: TextInputType.datetime,
                            inputFormatters: [_expiryFormatter],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildField(
                            'CVV',
                            _cvvController,
                            hint: '123',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      value: _saveCard,
                      onChanged: (val) => setState(() => _saveCard = val!),
                      contentPadding: EdgeInsets.zero,
                      activeColor: Colors.orange,
                      title: const Text("Save this card for future"),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.lock_outline),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await saveBookingLocally(widget.ticket, widget.resSeat);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => TicketScreen(seat: widget.resSeat)),
                      );
                    }
                  },
                  label: const Text(
                    'Confirm Payment',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
