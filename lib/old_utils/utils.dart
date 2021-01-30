import 'dart:async';
import 'package:flutter/material.dart';

class Utils {
  static Timer toastTimer;
  static OverlayEntry _overlayEntry;

  static void showToast(BuildContext context, String message) {
    if (toastTimer == null || !toastTimer.isActive) {
      _overlayEntry = createOverlayEntry(context, message);
      Overlay.of(context).insert(_overlayEntry);
      toastTimer = Timer(Duration(milliseconds: 600), () {
        if (_overlayEntry != null) {
          _overlayEntry.remove();
        }
      });
    }
  }

  static OverlayEntry createOverlayEntry(BuildContext context, String message) {
    return OverlayEntry(
        builder: (context) => Center(
            child: Align(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        color: Colors.black12,
                        child: Material(
                            color: Colors.transparent,
                            elevation: 0,
                            child: Text(message)))))));
  }
}
