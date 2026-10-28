import 'package:flutter/foundation.dart';

/// Keeps the selected clinic and branch while institution routes change.
final class InstitutionSelection extends ChangeNotifier {
  String? _clinicId;
  String? _branchId;

  String? get clinicId => _clinicId;
  String? get branchId => _branchId;

  void selectClinic(String id) {
    if (_clinicId == id) return;
    _clinicId = id;
    _branchId = null;
    notifyListeners();
  }

  void selectBranch(String id) {
    if (_branchId == id) return;
    _branchId = id;
    notifyListeners();
  }

  void clearBranch() {
    if (_branchId == null) return;
    _branchId = null;
    notifyListeners();
  }
}
