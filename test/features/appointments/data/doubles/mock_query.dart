// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';

/// Firestore query boundary for provider stream failures.
final class MockQuery extends Mock implements Query<Map<String, dynamic>> {}
