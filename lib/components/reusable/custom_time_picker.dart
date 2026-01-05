import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onChanged;

  const CustomTimePicker({
    super.key,
    required this.time,
    required this.onChanged,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late TextEditingController _controller;
  bool _enabled = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.time));
  }

  @override
  void didUpdateWidget(covariant CustomTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.time != widget.time) {
      _controller.text = _format(widget.time);
      _enabled = false;
      _errorText = null;
    }
  }

  String _format(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _showDial(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: widget.time,
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );

    if (picked != null) {
      widget.onChanged(picked);
      setState(() {
        _controller.text = _format(picked);
        _enabled = false;
        _errorText = null;
      });
    }
  }

  void _handleInput(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length <= 2) {
      _controller.value = TextEditingValue(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
      setState(() => _errorText = null);
      return;
    }

    if (digits.length <= 4) {
      final formatted = '${digits.substring(0, 2)}:${digits.substring(2)}';

      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    if (digits.length == 4) {
      final hour = int.parse(digits.substring(0, 2));
      final minute = int.parse(digits.substring(2, 4));

      if (hour > 23) {
        setState(() => _errorText = 'Jam harus antara 00–23');
        return;
      }

      if (minute > 59) {
        setState(() => _errorText = 'Menit harus antara 00–59');
        return;
      }

      widget.onChanged(TimeOfDay(hour: hour, minute: minute));
      setState(() {
        _enabled = false;
        _errorText = null;
      });
    }
  }

  void _enableEdit() {
    setState(() {
      _enabled = true;
      _errorText = null;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null;
    Color _textColor(bool hasError) {
      if (hasError) return Colors.red;
      if (_enabled) return Colors.green.shade700;
      return Colors.grey;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: hasError ? Colors.red : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: MaterialButton(
                  height: double.infinity,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(15),
                    ),
                  ),
                  color: Colors.green.shade400,
                  onPressed: () {
                    setState(() => _enabled = true);
                    _showDial(context);
                  },
                  child: HeroIcon(HeroIcons.clock, color: Colors.white),
                ),
              ),

              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _controller,
                  enabled: _enabled,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(5)],
                  onChanged: _handleInput,
                  decoration: InputDecoration(
                    hintText: 'format hh:mm',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  style: TextStyle(fontSize: 14, color: _textColor(hasError)),
                ),
              ),

              if (!_enabled)
                IconButton(
                  icon: const HeroIcon(HeroIcons.pencil, size: 16),
                  color: Colors.green,
                  onPressed: _enableEdit,
                ),
            ],
          ),
        ),

        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              _errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
