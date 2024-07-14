import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:scaffold_messender_key_sample/mixin/runner_mixin.dart';
import 'package:scaffold_messender_key_sample/provider/navigator_key.dart';
import 'package:scaffold_messender_key_sample/provider/scaffold_messenger_key_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'ScaffoldMessengerState',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                return Scaffold(
                  body: child,
                );
              },
            ),
          ],
        );
      },
      scaffoldMessengerKey: ref.watch(scaffoldMessengerProvider),
      navigatorKey: ref.watch(navigatorKeyProvider),
      home: const LoaderOverlay(child: HomePage()),
    );
  }
}

class HomePage extends HookConsumerWidget with RunnerMixin {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          ElevatedButton(
            child: const Text('Run'),
            onPressed: () async {
              await run(
                ref,
                f: () async {
                  await Future.delayed(const Duration(seconds: 1));
                },
              );
            },
          ),
          ElevatedButton(
            child: const Text('Oops'),
            onPressed: () async {
              await run(
                ref,
                f: () async {
                  throw Exception('Oops');
                },
              );
            },
          )
        ]));
  }
}
