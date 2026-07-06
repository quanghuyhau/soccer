import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_design.dart';
import 'owner_controller.dart';

void showVenueDialog({required BuildContext context, Venue? venue}) {
  showDialog<void>(
    context: context,
    builder: (_) => _VenueDialog(venue: venue),
  );
}

Future<void> confirmDeleteVenue(
  BuildContext context,
  WidgetRef ref,
  Venue venue,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Xoá cụm sân?'),
      content: Text('Bạn muốn xoá "${venue.name}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Huỷ'),
        ),
        AppButton.destructive(
          label: 'Xoá',
          icon: const Icon(Icons.delete_outline),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    ref.read(venueMutationControllerProvider.notifier).delete(venue.id);
  }
}

class _VenueDialog extends ConsumerStatefulWidget {
  const _VenueDialog({this.venue});

  final Venue? venue;

  @override
  ConsumerState<_VenueDialog> createState() => _VenueDialogState();
}

class _VenueDialogState extends ConsumerState<_VenueDialog> {
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _openController;
  late final TextEditingController _closeController;

  @override
  void initState() {
    super.initState();
    final venue = widget.venue;
    _codeController = TextEditingController(text: venue?.code ?? 'VENUE001');
    _nameController = TextEditingController(text: venue?.name ?? '');
    _descriptionController = TextEditingController(
      text: venue?.description ?? '',
    );
    _phoneController = TextEditingController(text: venue?.phone ?? '');
    _addressController = TextEditingController(text: venue?.address ?? '');
    _openController = TextEditingController(
      text: venue?.openTime ?? '06:00:00',
    );
    _closeController = TextEditingController(
      text: venue?.closeTime ?? '23:00:00',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _openController.dispose();
    _closeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(venueMutationControllerProvider);
    final isEdit = widget.venue != null;

    return AlertDialog(
      title: Text(isEdit ? 'Sửa cụm sân' : 'Tạo cụm sân'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _codeController,
                label: 'Mã cụm sân',
                icon: Icons.qr_code_2,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _nameController,
                label: 'Tên cụm sân',
                icon: Icons.stadium,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _descriptionController,
                label: 'Mô tả',
                icon: Icons.notes,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _phoneController,
                label: 'Số điện thoại',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _addressController,
                label: 'Địa chỉ',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _openController,
                      label: 'Mở cửa',
                      icon: Icons.schedule,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      controller: _closeController,
                      label: 'Đóng cửa',
                      icon: Icons.schedule_send,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: state.isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Huỷ'),
        ),
        AppButton.primary(
          label: 'Lưu',
          isLoading: state.isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }

  void _submit() {
    final request = CreateVenueRequest(
      code: _codeController.text.trim(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      openTime: _normalizeTime(_openController.text),
      closeTime: _normalizeTime(_closeController.text),
    );
    final controller = ref.read(venueMutationControllerProvider.notifier);
    final venue = widget.venue;

    if (venue == null) {
      controller.create(request);
    } else {
      controller.update(venueId: venue.id, request: request);
    }

    Navigator.of(context).pop();
  }
}

String _normalizeTime(String value) {
  final trimmed = value.trim();
  return trimmed.length == 5 ? '$trimmed:00' : trimmed;
}
