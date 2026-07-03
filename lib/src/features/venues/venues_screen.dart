import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models/app_models.dart';
import '../../core/widgets/app_state_views.dart';
import 'venue_detail_screen.dart';
import 'venues_controller.dart';

class VenuesScreen extends ConsumerWidget {
  const VenuesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venuesState = ref.watch(venuesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cụm sân'),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            onPressed: () => ref.invalidate(venuesControllerProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: venuesState.when(
          data: (venues) {
            if (venues.isEmpty) {
              return const _EmptyVenues();
            }

            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(venuesControllerProvider),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: venues.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _VenueCard(venue: venues[index]);
                },
              ),
            );
          },
          error: (error, stackTrace) => AppErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(venuesControllerProvider),
          ),
          loading: () => const AppLoadingView(),
        ),
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({required this.venue});

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => VenueDetailScreen(venueId: venue.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      venue.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 8),
              Text(venue.address),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(Icons.schedule, size: 18),
                    label: Text('${venue.openTime} - ${venue.closeTime}'),
                  ),
                  Chip(
                    avatar: const Icon(Icons.phone, size: 18),
                    label: Text(venue.phone),
                  ),
                  Chip(label: Text(venue.status)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyVenues extends StatelessWidget {
  const _EmptyVenues();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Chưa có cụm sân'));
  }
}
