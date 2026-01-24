import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final Color? colorTheme;

  const CustomDatePicker({
    super.key,
    required this.date,
    required this.onChanged,
    this.colorTheme,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late TextEditingController _controller;
  bool _enabled = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.date));
  }

  @override
  void didUpdateWidget(covariant CustomDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date != widget.date) {
      _controller.text = _format(widget.date);
      _enabled = false;
      _errorText = null;
    }
  }

  String _format(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  Future<void> _showCalendar(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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
      _errorText = null;
      setState(() {});
      return;
    }

    if (digits.length <= 4) {
      final formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      return;
    }

    if (digits.length <= 8) {
      final formatted =
          '${digits.substring(0, 2)}/${digits.substring(2, 4)}/${digits.substring(4)}';

      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    if (digits.length == 8) {
      final day = int.parse(digits.substring(0, 2));
      final month = int.parse(digits.substring(2, 4));
      final year = int.parse(digits.substring(4, 8));

      if (month < 1 || month > 12) {
        setState(() => _errorText = 'Bulan harus antara 01–12');
        return;
      }

      if (day < 1 || day > 31) {
        setState(() => _errorText = 'Tanggal harus antara 01–31');
        return;
      }

      final date = DateTime.tryParse(
        '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
      );

      if (date == null ||
          date.day != day ||
          date.month != month ||
          date.year != year) {
        setState(() => _errorText = 'Tanggal tidak valid');
        return;
      }

      widget.onChanged(date);
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

    Color textColor() {
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
              MaterialButton(
                height: double.infinity,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(15),
                  ),
                ),
                color: widget.colorTheme ?? Colors.green.shade400,
                onPressed: () {
                  setState(() => _enabled = true);
                  _showCalendar(context);
                },
                child: const HeroIcon(HeroIcons.calendar, color: Colors.white),
              ),

              Expanded(
                child: TextFormField(
                  controller: _controller,
                  enabled: _enabled,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  onChanged: _handleInput,
                  decoration: const InputDecoration(
                    hintText: 'format dd/MM/yyyy',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  style: TextStyle(fontSize: 16, color: textColor()),
                ),
              ),

              if (!_enabled)
                IconButton(
                  icon: const HeroIcon(HeroIcons.pencil, size: 16),
                  color: widget.colorTheme ?? Colors.green,
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
