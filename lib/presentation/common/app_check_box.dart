import 'package:flutter/material.dart';
import 'package:atm_soundbox/utilities/style/style.dart';

class AppCheckBox extends StatefulWidget {
  final String? title;
  final bool? initValue;
  final ValueChanged<bool>? onChanged;

  const AppCheckBox({
    super.key,
    this.title,
    this.initValue,
    this.onChanged,
  });

  @override
  State<AppCheckBox> createState() => _AppCheckBoxState();
}

class _AppCheckBoxState extends State<AppCheckBox> {
  bool _check = false;

  @override
  void initState() {
    super.initState();
    _check = widget.initValue ?? false;
  }

  @override
  Widget build(BuildContext context) {
    theme.registerNotifyUpdated(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _check = !_check;
        widget.onChanged?.call(_check);
        setState(() {});
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            _check
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            size: 20,
            color: _check ? theme.color.c1 : null,
          ),
          const SizedBox(width: 8),
          Text(
            widget.title ?? '',
            style: theme.font.body.copyWith(color: theme.color.b20),
          ),
        ],
      ),
    );
  }
}
