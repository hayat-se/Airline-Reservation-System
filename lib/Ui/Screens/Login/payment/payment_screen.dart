import 'package:flutter/material.dart';
import '../Bookings/ticket_screen.dart';


class PaymentScreen extends StatefulWidget {
  final String resSeat;
  const PaymentScreen({super.key , required this.resSeat});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _confirmPayment() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TicketScreen(seat: widget.resSeat,)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.credit_card, size: 80, color: Colors.orange),
              const SizedBox(height: 24),

              _buildField('Cardholder Name', _cardNameController),
              _buildField('Card Number', _cardNumberController,
                  keyboardType: TextInputType.number),
              Row(
                children: [
                  Expanded(
                      child: _buildField('Expiry Date', _expiryDateController,
                          hint: 'MM/YY')),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildField('CVV', _cvvController,
                          keyboardType: TextInputType.number)),
                ],
              ),

              const Spacer(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TicketScreen(seat: widget.resSeat,)),
                  );
                },
                child: const Text('Confirm Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) =>
        value == null || value.trim().isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange.shade100)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
