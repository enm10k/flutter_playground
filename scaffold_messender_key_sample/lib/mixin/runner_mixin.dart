import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:scaffold_messender_key_sample/provider/scaffold_messenger_key_provider.dart';

mixin RunnerMixin {
  _showMaterialBanner({
    required GlobalKey<ScaffoldMessengerState> messengerKey,
    required Widget content,
    Widget? leading,
    Color? backgroundColor,
    bool autoDispose = true,
  }) {
    final state = messengerKey.currentState;
    state?.showMaterialBanner(MaterialBanner(
      margin: const EdgeInsets.all(16),
      backgroundColor: backgroundColor,
      elevation: 1,
      leading: leading,
      content: content,
      actions: [
        IconButton(
            onPressed: () {
              state.removeCurrentMaterialBanner();
            },
            icon: const Icon(Icons.close))
      ],
      onVisible: () {
        if (!autoDispose) {
          return;
        }
        Future.delayed(
          const Duration(seconds: 1),
          () => state.removeCurrentMaterialBanner(),
        );
      },
    ));
  }

  _showSuccessBanner({
    required GlobalKey<ScaffoldMessengerState> messenger,
    required String message,
  }) {
    final colorScheme = Theme.of(messenger.currentContext!).colorScheme;
    _showMaterialBanner(
        messengerKey: messenger,
        content: Text(message,
            style: TextStyle(
              color: colorScheme.onPrimary,
            )),
        leading: Icon(Icons.check, color: colorScheme.onPrimary),
        backgroundColor: colorScheme.primary);
  }

  _showErrorBanner({
    required GlobalKey<ScaffoldMessengerState> messenger,
    required Object error,
    required StackTrace? stackTrace,
  }) {
    final colorScheme = Theme.of(messenger.currentContext!).colorScheme;
    _showMaterialBanner(
        messengerKey: messenger,
        // content: Text('$error\n$stackTrace',
        content: Text('$error', style: TextStyle(color: colorScheme.onError)),
        leading: Icon(Icons.bug_report, color: colorScheme.onError),
        backgroundColor: colorScheme.error);
  }

  Future<T1?> run<T1>(
    WidgetRef ref, {
    required Future<T1> Function() f,
    String? successMessage,
    String? errorMessage,
    showLoader = true,
  }) async {
    final messengerKey = ref.read(scaffoldMessengerProvider);
    final loaderOverlay = messengerKey.currentContext?.loaderOverlay;
    try {
      if (showLoader) {
        loaderOverlay?.show();
      }
      final result = await f();
      _showSuccessBanner(messenger: messengerKey, message: 'Succeeded');
      return result;
    } catch (e, s) {
      _showErrorBanner(messenger: messengerKey, error: e, stackTrace: s);
    } finally {
      if (loaderOverlay?.visible == true) {
        loaderOverlay?.hide();
      }
    }
    return null;
  }
}
