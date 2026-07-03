import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_state_views.dart';
import '../bookings/create_booking_screen.dart';
import 'venues_controller.dart';

class VenueDetailScreen extends ConsumerWidget {
  const VenueDetailScreen({super.key, required this.venueId});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(venueDetailControllerProvider(venueId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sân'),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            onPressed: () {
              ref.invalidate(venueDetailControllerProvider(venueId));
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: detailState.when(
          data: (detail) => _VenueDetail(detail: detail),
          error: (error, stackTrace) => AppErrorView(
            message: error.toString(),
            onRetry: () =>
                ref.invalidate(venueDetailControllerProvider(venueId)),
          ),
          loading: () => const AppLoadingView(),
        ),
      ),
    );
  }
}

class _VenueDetail extends StatelessWidget {
  const _VenueDetail({required this.detail});

  final VenueDetailData detail;

  @override
  Widget build(BuildContext context) {
    final venue = detail.venue;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(venue.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(venue.description),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              avatar: const Icon(Icons.location_on_outlined, size: 18),
              label: Text(venue.address),
            ),
            Chip(
              avatar: const Icon(Icons.schedule, size: 18),
              label: Text('${venue.openTime} - ${venue.closeTime}'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Sân con', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (detail.pitches.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Chưa có sân con'),
            ),
          )
        else
          ...detail.pitches.map((pitch) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PitchCard(venue: venue, pitch: pitch),
            );
          }),
      ],
    );
  }
}

class _PitchCard extends StatelessWidget {
  const _PitchCard({required this.venue, required this.pitch});

  final Venue venue;
  final Pitch pitch;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    pitch.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(label: Text(pitch.type)),
              ],
            ),
            const SizedBox(height: 8),
            Text('${pitch.size} - ${pitch.surface}'),
            if (pitch.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(pitch.description),
            ],
            const SizedBox(height: 12),
            AppButton.primary(
              label: 'Đặt sân',
              icon: const Icon(Icons.add_task),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        CreateBookingScreen(venue: venue, pitch: pitch),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
