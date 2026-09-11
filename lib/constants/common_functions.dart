import 'dart:async';

import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

import '../utils/colors.dart';

class CommonFunctions {
  static blankSpace(double? height, double? width) {
    return SizedBox(
      height: height ?? 0,
      width: width ?? 0,
    );
  }

  static divider() {
    return Divider(
      color: greyShade3,
      height: 0,
      thickness: 3,
    );
  }

  static showSuccessToast(
      {required BuildContext context, required String message}) {
    return MotionToast.success(
      title: const Text('Success'),
      description: Text(message),
      toastAlignment: Alignment.topCenter,
    ).show(context);
  }

  static showErrorToast(
      {required BuildContext context, required String message}) {
    return MotionToast.error(
      title: const Text('Error'),
      description: Text(message),
      toastAlignment: Alignment.topCenter,
    ).show(context);
  }

  static showWarningToast(
      {required BuildContext context, required String message}) {
    return MotionToast.warning(
      title: const Text('Opps!'),
      description: Text(message),
      toastAlignment: Alignment.topCenter,
    ).show(context);
  }

  // Manually-pasted product/review image URLs are rendered with
  // Image.network / NetworkImage. On native Android and iOS that fetches
  // the bytes directly and always works, but on Flutter Web it goes
  // through the browser's <img>/fetch pipeline, which enforces CORS. Many
  // sites (e.g. random storefronts) don't send an
  // Access-Control-Allow-Origin header, so the same URL that looks fine
  // when the seller pastes it on Android silently renders as a broken
  // image for web customers, with no exception the seller ever sees. This
  // check loads the URL through the same Image.network pipeline *before*
  // it's accepted, so a CORS-blocked (or otherwise broken) host is caught
  // and surfaced up front instead of being discovered later in
  // production. ImgBB-style hosts (ibb.co) are known to send permissive
  // CORS headers, which is why they're recommended in the UI.
  static Future<bool> canLoadNetworkImage(
    BuildContext context,
    String url,
  ) {
    final completer = Completer<bool>();
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Offstage(
        child: Image.network(
          url,
          errorBuilder: (context, error, stackTrace) {
            if (!completer.isCompleted) completer.complete(false);
            return const SizedBox.shrink();
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (frame != null && !completer.isCompleted) {
              completer.complete(true);
            }
            return child;
          },
        ),
      ),
    );
    Overlay.of(context).insert(entry);
    return completer.future
        .timeout(const Duration(seconds: 8), onTimeout: () => false)
        .whenComplete(() => entry.remove());
  }

  /// Shows the "couldn't load" warning for a pasted image URL and returns
  /// true if the seller chose to add it anyway.
  static Future<bool> showBrokenImageUrlWarning(BuildContext context) async {
    final addAnyway = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Image may not display'),
        content: const Text(
          "This image couldn't be loaded — it may not display correctly, "
          'especially on web. Try a different source or upload the file '
          'directly instead.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Choose Different URL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Add Anyway'),
          ),
        ],
      ),
    );
    return addAnyway ?? false;
  }
}
