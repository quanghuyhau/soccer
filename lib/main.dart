import 'package:flutter/material.dart';

import 'package:soccer/di/di.dart';
import 'package:soccer/presentation/application/application.dart';

void main() {
  configureDependencies();
  runApp(const SoccerApp());
}
