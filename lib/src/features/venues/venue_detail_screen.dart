import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../core/widgets/app_design.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/base_screen.dart';
import '../bookings/create_booking_screen.dart';
import 'venues_controller.dart';

class VenueDetailScreen extends ConsumerWidget {
  const VenueDetailScreen({super.key, required this.venueId});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(venueDetailControllerProvider(venueId));

    return BaseAsyncScreen<VenueDetailData>(
      title: 'Chi tiết sân',
      value: detailState,
      onRetry: () => ref.invalidate(venueDetailControllerProvider(venueId)),
      onRefresh: () async =>
          ref.invalidate(venueDetailControllerProvider(venueId)),
      actions: [
        IconButton(
          tooltip: 'Tải lại',
          onPressed: () {
            ref.invalidate(venueDetailControllerProvider(venueId));
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
      data: (detail) => _VenueDetail(detail: detail),
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
        AppHeroPanel(
          title: venue.name,
          subtitle: venue.address,
          icon: Icons.stadium,
        ),
        if (venue.description.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(venue.description),
        ],
        const SizedBox(height: 12),
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
        const SizedBox(height: 16),
        AppMetricBubble(
          icon: Icons.sports_soccer,
          label: 'Sân con',
          value: detail.pitches.length.toString(),
          color: AppColors.coral,
        ),
        const SizedBox(height: 20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.grass,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    pitch.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                AppStatusPill(label: pitch.type, color: AppColors.teal),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.straighten, size: 18),
                  label: Text(pitch.size),
                ),
                Chip(
                  avatar: const Icon(Icons.eco_outlined, size: 18),
                  label: Text(pitch.surface),
                ),
              ],
            ),
            if (pitch.description.isNotEmpty) ...[
              const SizedBox(height: 8),
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
