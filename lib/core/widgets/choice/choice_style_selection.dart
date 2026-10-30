import 'package:clinic_appointment_system/core/widgets/choice/choice_style.dart';

/// Picks the [ChoiceStyle] for a selection state.
extension ChoiceStyleSelection on bool {
  /// The choice style for this selection state.
  ChoiceStyle get choiceStyle {
    if (this) return ChoiceStyle.selected;
    return ChoiceStyle.unselected;
  }
}
