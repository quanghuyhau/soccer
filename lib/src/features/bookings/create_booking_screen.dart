import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../app/session/app_session.dart';
import '../../core/error/app_exception.dart';
import '../../core/utils/app_formatters.dart';
import '../../core/widgets/app_button.dart';
import 'bookings_controller.dart';

class CreateBookingScreen extends ConsumerStatefulWidget {
  const CreateBookingScreen({
    super.key,
    required this.venue,
    required this.pitch,
  });

  final Venue venue;
  final Pitch pitch;

  @override
  ConsumerState<CreateBookingScreen> createState() =>
      _CreateBookingScreenState();
}

class _CreateBookingScreenState extends ConsumerState<CreateBookingScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final _dateController = TextEditingController(
    text: AppFormatters.date(DateTime.now()),
  );
  final _startController = TextEditingController(text: '18:00');
  final _endController = TextEditingController(text: '19:30');
  final _priceController = TextEditingController(text: '300000');
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = ref.read(appSessionProvider)?.user;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _startController.dispose();
    _endController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createBookingControllerProvider);

    ref.listen(createBookingControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (booking) {
          if (booking == null || previous?.isLoading != true) {
            return;
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Đặt sân thành công')));
          Navigator.of(context).pop();
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(_errorMessage(error))));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Tạo booking')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              widget.pitch.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(widget.venue.name),
            const SizedBox(height: 20),
            _field(_nameController, 'Tên khách hàng', Icons.person),
            _field(_phoneController, 'Số điện thoại', Icons.phone),
            Row(
              children: [
                Expanded(child: _field(_dateController, 'Ngày', Icons.today)),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(_startController, 'Bắt đầu', Icons.schedule),
                ),
              ],
            ),
            _field(_endController, 'Kết thúc', Icons.schedule_send),
            _field(
              _priceController,
              'Tổng tiền',
              Icons.payments_outlined,
              keyboardType: TextInputType.number,
            ),
            _field(_noteController, 'Ghi chú', Icons.notes, maxLines: 3),
            const SizedBox(height: 12),
            AppButton.primary(
              label: 'Xác nhận đặt sân',
              icon: const Icon(Icons.check_circle_outline),
              isLoading: createState.isLoading,
              isExpanded: true,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _submit() {
    final date = _dateController.text.trim();
    final start = _startController.text.trim();
    final end = _endController.text.trim();
    final startTime = DateTime.tryParse('${date}T$start:00');
    final endTime = DateTime.tryParse('${date}T$end:00');

    if (startTime == null || endTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Thời gian không hợp lệ')));
      return;
    }

    ref
        .read(createBookingControllerProvider.notifier)
        .create(
          CreateBookingRequest(
            pitchId: widget.pitch.id,
            customerName: _nameController.text.trim(),
            customerPhone: _phoneController.text.trim(),
            startTime: startTime,
            endTime: endTime,
            totalPrice: num.tryParse(_priceController.text.trim()) ?? 0,
            note: _noteController.text.trim(),
          ),
        );
  }

  String _errorMessage(Object error) {
    if (error is AppException) {
      return error.message;
    }

    return 'Không tạo được booking';
  }
}
