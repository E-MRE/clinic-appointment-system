import 'package:flutter/painting.dart';

/// Visual states of a day or slot cell on the booking page.
enum BookingCellStyle {
  /// Can be chosen.
  available(isEnabled: true),

  /// Currently chosen.
  selected(isEnabled: true),

  /// A closed, full or past day; outlined with dashes.
  unavailable(isEnabled: false, isDashed: true),

  /// A slot another appointment occupies; struck through.
  taken(isEnabled: false, decoration: TextDecoration.lineThrough);

  const BookingCellStyle({
    required this.isEnabled,
    this.isDashed = false,
    this.decoration = TextDecoration.none,
  });

  /// Whether the cell responds to taps.
  final bool isEnabled;

  /// Whether the outline is painted with dashes instead of a solid border.
  final bool isDashed;

  /// Decoration of the cell's text.
  final TextDecoration decoration;
}
