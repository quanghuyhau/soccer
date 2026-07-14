import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

mixin DisposableNotifierMixin<State> on StateNotifier<State> {
  final List<Object> _disposables = [];

  /// Registers a disposable object (like [TextEditingController], [FocusNode], etc.)
  /// to be automatically disposed when this notifier is disposed.
  T registerDisposable<T extends Object>(T disposable) {
    _disposables.add(disposable);
    return disposable;
  }

  @override
  void dispose() {
    for (final disposable in _disposables) {
      try {
        if (disposable is ChangeNotifier) {
          disposable.dispose();
        } else {
          // Fallback for custom objects with a dispose method
          (disposable as dynamic).dispose();
        }
      } catch (_) {
        // Suppress errors during auto-disposal
      }
    }
    _disposables.clear();
    super.dispose();
  }
}
