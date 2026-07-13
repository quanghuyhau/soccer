import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import '../widgets/base_popup.dart';
import 'app_state.dart';

typedef AppFailureAction =
    void Function(BuildContext context, AppFailure<dynamic> failure);

class AppFailureRule {
  const AppFailureRule({this.codes = const {}, required this.action});

  final Set<int> codes;
  final AppFailureAction action;

  bool matches(AppFailure<dynamic> failure) {
    final code = failure.backendCode ?? failure.statusCode;
    return code != null && codes.contains(code);
  }
}

class AppStateListener {
  const AppStateListener._();

  static void listen<T>(
    WidgetRef ref,
    ProviderListenable<AppState<T>> provider,
    BuildContext context, {
    void Function(T? data)? onSuccess,
    List<AppFailureRule> failureRules = const [],
    bool showDefaultFailurePopup = true,
  }) {
    ref.listen<AppState<T>>(provider, (previous, next) {
      if (previous?.isLoading == true && next.isSuccess) {
        onSuccess?.call(next.dataOrNull);
      }

      final failure = next.failureOrNull;
      if (failure == null) {
        return;
      }

      for (final rule in failureRules) {
        if (rule.matches(failure)) {
          rule.action(context, failure);
          return;
        }
      }

      if (showDefaultFailurePopup) {
        BasePopup.showFailure(failure, context: context);
      }
    });
  }
}
