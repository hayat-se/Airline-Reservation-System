import 'package:flutter/material.dart';
import '../../../../app_colors.dart';

class PassengerPicker extends StatefulWidget {
  final int passengers;
  final String travelClass;
  const PassengerPicker({
    super.key,
    required this.passengers,
    required this.travelClass,
  });

  @override
  State<PassengerPicker> createState() => _PassengerPickerState();
}

class _PassengerPickerState extends State<PassengerPicker> {
  late int _passengers;
  late String _class;
  final classes = ['Economy', 'Business', 'First'];

  @override
  void initState() {
    super.initState();
    _passengers = widget.passengers;
    _class      = widget.travelClass;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text('Passengers & Class',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),

                /* ─── Passengers ─── */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Passengers', style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        _CircleBtn(
                          icon: Icons.remove,
                          onTap: _passengers > 1
                              ? () => setState(() => _passengers--)
                              : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('$_passengers',
                              style: const TextStyle(fontSize: 18)),
                        ),
                        _CircleBtn(
                          icon: Icons.add,
                          onTap: () => setState(() => _passengers++),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 30),

                /* ─── Class ─── */
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: classes
                      .map(
                        (c) => RadioListTile<String>(
                      value: c,
                      groupValue: _class,
                      activeColor: AppColors.primary,
                      title: Text(c),
                      onChanged: (v) => setState(() => _class = v!),
                    ),
                  )
                      .toList(),
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(45),
                  ),
                  onPressed: () => Navigator.pop(context, {
                    'passengers': _passengers,
                    'class': _class,
                  }),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CircleBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Ink(
        width: 32, height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap == null ? Colors.grey.shade300 : AppColors.primary,
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}
