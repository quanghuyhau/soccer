import 'package:flutter/widgets.dart';

import 'package:soccer/presentation/common/widgets/base_popup.dart';
import 'package:soccer/presentation/common/base_state.dart';

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

  static void handleChange<T>(
    BuildContext context, {
    required AppState<T>? previous,
    required AppState<T> current,
    void Function(T? data)? onSuccess,
    List<AppFailureRule> failureRules = const [],
    bool showDefaultFailurePopup = true,
  }) {
    if (current.isSuccess && previous?.isSuccess != true) {
      onSuccess?.call(current.dataOrNull);
    }

    final failure = current.failureOrNull;
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
  }
}
