import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soccer/presentation/application/app_session.dart';
import 'package:soccer/presentation/common/widgets/app_button.dart';
import 'package:soccer/presentation/common/widgets/app_design.dart';
import 'package:soccer/presentation/common/widgets/base_screen.dart';
import 'package:soccer/presentation/screens/bookings/ui/my_bookings_screen.dart';
import 'package:soccer/presentation/screens/owner/ui/owner_screen.dart';
import 'package:soccer/presentation/screens/venues/ui/venues_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppSessionCubit>().state;
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

    return BaseScreen(
      padding: EdgeInsets.zero,
      useSafeArea: false,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.line),
          ),
          child: NavigationBar(
            height: 64,
            backgroundColor: Colors.transparent,
            elevation: 0,
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
        ),
      ),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppSessionCubit>().state;
    final user = session?.user;

    return BaseScrollScreen(
      title: 'Tài khoản',
      padding: const EdgeInsets.all(16),
      children: [
        AppHeroPanel(
          title: user?.fullName ?? 'Tài khoản',
          subtitle: user?.roles.join(', ') ?? '',
          icon: Icons.person,
        ),
        const SizedBox(height: 16),
        AppSurface(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.alternate_email),
                title: Text(user?.username ?? ''),
                subtitle: Text(user?.email ?? ''),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.phone),
                title: Text(user?.phone ?? ''),
                subtitle: Text(user?.address ?? ''),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppButton.primary(
          label: 'Đăng xuất',
          icon: const Icon(Icons.logout),
          isExpanded: true,
          onPressed: () => context.read<AppSessionCubit>().clear(),
        ),
      ],
    );
  }
}
