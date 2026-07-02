import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/app_exception.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_state_views.dart';
import '../login/login_screen.dart';
import 'home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(homeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Soccer')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clean Architecture Base',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Feature only keeps controller and screen.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              AppButton.outlined(
                label: 'Open login flow',
                icon: const Icon(Icons.login),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: itemState.when(
                    data: (item) => _SampleItemView(
                      title: item.title,
                      completed: item.completed,
                    ),
                    error: (error, stackTrace) => AppErrorView(
                      message: _errorMessage(error),
                      onRetry: () => ref.invalidate(homeControllerProvider),
                    ),
                    loading: () => const AppLoadingView(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _errorMessage(Object error) {
    if (error is AppException) {
      return error.message;
    }

    return 'Something went wrong.';
  }
}

class _SampleItemView extends StatelessWidget {
  const _SampleItemView({required this.title, required this.completed});

  final String title;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  completed ? Icons.check_circle : Icons.pending,
                  color: completed ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(completed ? 'Completed' : 'In progress'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
