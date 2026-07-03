import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session/app_session.dart';
import '../bookings/my_bookings_screen.dart';
import '../owner/owner_screen.dart';
import '../venues/venues_screen.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(appSessionProvider);
    final user = session?.user;
    final isOwner = user?.isOwner == true || user?.isAdmin == true;
    final pages = [
      const VenuesScreen(),
      const MyBookingsScreen(),
      if (isOwner) const OwnerScreen(),
      const _ProfileScreen(),
    ];

    if (_index >= pages.length) {
      _index = pages.length - 1;
    }

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.stadium_outlined),
            selectedIcon: Icon(Icons.stadium),
            label: 'Sân',
          ),
          const NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Lịch đặt',
          ),
          if (isOwner)
            const NavigationDestination(
              icon: Icon(Icons.admin_panel_settings_outlined),
              selectedIcon: Icon(Icons.admin_panel_settings),
              label: 'Quản lý',
            ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}

class _ProfileScreen extends ConsumerWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(appSessionProvider);
    final user = session?.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            CircleAvatar(
              radius: 36,
              child: Text(
                (user?.fullName.isNotEmpty == true
                        ? user!.fullName[0]
                        : (user?.username.isNotEmpty == true
                              ? user!.username[0]
                              : 'U'))
                    .toUpperCase(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.fullName ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              user?.roles.join(', ') ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.alternate_email),
              title: Text(user?.username ?? ''),
              subtitle: Text(user?.email ?? ''),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(user?.phone ?? ''),
              subtitle: Text(user?.address ?? ''),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => ref.read(appSessionProvider.notifier).clear(),
              icon: const Icon(Icons.logout),
              label: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
