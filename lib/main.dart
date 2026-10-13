// Placeholder while uploading complete Flutter UI source.
import 'package:flutter/material.dart';

void main() => runApp(const VigguAudioApp());

class VigguAudioApp extends StatelessWidget {
  const VigguAudioApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Viggu Audio',
    theme: ThemeData(colorSchemeSeed: const Color(0xFF8174F7), useMaterial3: true),
    darkTheme: ThemeData(colorSchemeSeed: const Color(0xFF8174F7), brightness: Brightness.dark, useMaterial3: true),
    home: const Scaffold(body: Center(child: Text('Viggu Audio source setup'))),
  );
}
