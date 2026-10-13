// Viggu Audio app entry point
import 'package:flutter/material.dart';

void main() => runApp(const VigguAudioApp());

class VigguAudioApp extends StatelessWidget {
  const VigguAudioApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Viggu Audio',
    theme: ThemeData(colorSchemeSeed: const Color(0xFF8174F7), useMaterial3: true),
    home: const AudioHome(),
  );
}

class AudioHome extends StatefulWidget {
  const AudioHome({super.key});
  @override
  State<AudioHome> createState() => _AudioHomeState();
}

class _AudioHomeState extends State<AudioHome> {
  int tab = 0;
  String theme = 'System';
  String season = 'Aurora';
  final List<String> imported = [];
  @override
  Widget build(BuildContext context) {
    final pages = [
      _home(),
      _library(),
      _settings(),
    ];
    return Scaffold(
      body: SafeArea(child: AnimatedSwitcher(duration: const Duration(milliseconds: 180), child: pages[tab])),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => _showPlayer(),
        tooltip: 'Resume recently played audio',
        child: const Icon(Icons.play_arrow_rounded, size: 38),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.library_music_outlined), selectedIcon: Icon(Icons.library_music), label: 'Library'),
          NavigationDestination(icon: Icon(Icons.tune), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _home() => ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 100), children: [
    Row(children: [const Icon(Icons.graphic_eq_rounded, size: 32), const SizedBox(width: 10), const Expanded(child: Text('Viggu Audio', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))), IconButton(onPressed: () {}, icon: const Icon(Icons.rocket_launch_rounded))]),
    const SizedBox(height: 18),
    Text('YOUR SOUND, YOUR SPACE', style: TextStyle(color: Theme.of(context).colorScheme.primary, letterSpacing: 1.4, fontSize: 11, fontWeight: FontWeight.bold)),
    const SizedBox(height: 6),
    const Text('Good listening.', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
    const SizedBox(height: 18),
    _gradientCard(height: 210, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Icon(Icons.album_rounded, size: 44), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('CONTINUE LISTENING', style: TextStyle(fontSize: 11, letterSpacing: 1.2)), SizedBox(height: 5), Text('Pick up where you left off', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))]), Align(alignment: Alignment.bottomRight, child: FilledButton.tonalIcon(onPressed: _showPlayer, icon: const Icon(Icons.play_arrow_rounded), label: const Text('Resume')))])),
    const SizedBox(height: 26),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Your library', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), TextButton(onPressed: () => setState(() => tab = 1), child: const Text('See all'))]),
    const SizedBox(height: 8),
    if (imported.isEmpty) _emptyCard() else ...imported.take(4).map(_trackTile),
  ]);

  Widget _library() => ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), children: [
    const Text('COLLECTION', style: TextStyle(letterSpacing: 1.4, fontSize: 11)),
    const SizedBox(height: 6),
    const Text('Your library', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    const SizedBox(height: 18),
    TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Search your music', border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)))),
    const SizedBox(height: 18),
    Wrap(spacing: 8, children: ['Songs', 'Albums', 'Artists', 'Folders'].map((e) => Chip(label: Text(e))).toList()),
    const SizedBox(height: 14),
    if (imported.isEmpty) _emptyCard() else ...imported.map(_trackTile),
    const SizedBox(height: 12),
    FilledButton.icon(onPressed: _importDemo, icon: const Icon(Icons.add), label: const Text('Import audio')),
    const SizedBox(height: 8),
    const Text('This UI scaffold is ready to connect to the Android file picker and audio engine.', style: TextStyle(fontSize: 12)),
  ]);

  Widget _settings() => ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), children: [
    const Text('MAKE IT YOURS', style: TextStyle(letterSpacing: 1.4, fontSize: 11)),
    const SizedBox(height: 6),
    const Text('Appearance', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    const SizedBox(height: 20),
    Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Theme', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      SegmentedButton<String>(segments: const [ButtonSegment(value: 'System', label: Text('System'), icon: Icon(Icons.settings_suggest)), ButtonSegment(value: 'Light', label: Text('Light'), icon: Icon(Icons.light_mode)), ButtonSegment(value: 'Dark', label: Text('Dark'), icon: Icon(Icons.dark_mode))], selected: {theme}, onSelectionChanged: (v) => setState(() => theme = v.first)),
      const SizedBox(height: 24),
      const Text('Seasonal gradients', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: ['Aurora', 'Spring', 'Summer', 'Autumn', 'Winter'].map((v) => ChoiceChip(label: Text(v), selected: season == v, onSelected: (_) => setState(() => season = v), avatar: CircleAvatar(backgroundColor: _seasonColor(v), radius: 7))).toList()),
    ]))),
    Card(child: Column(children: const [ListTile(leading: Icon(Icons.headphones), title: Text('Audio output'), subtitle: Text('Uses Android audio output and phone sound settings')), Divider(height: 1), ListTile(leading: Icon(Icons.history), title: Text('Remember playback position'), subtitle: Text('Resume where you stopped')), Divider(height: 1), ListTile(leading: Icon(Icons.share_rounded), title: Text('Share Viggu Audio'))])),
    const SizedBox(height: 12),
    const Text('Personal music player · Local audio only', textAlign: TextAlign.center),
  ]);

  Widget _emptyCard() => Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [Container(width: 72, height: 72, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [_seasonColor(season), _seasonColor(season).withOpacity(.45)])), child: const Icon(Icons.music_note_rounded, size: 36, color: Colors.white)), const SizedBox(height: 14), const Text('Your music lives here', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 6), const Text('Add audio from your phone to start building your collection.', textAlign: TextAlign.center), const SizedBox(height: 16), FilledButton.icon(onPressed: _importDemo, icon: const Icon(Icons.add), label: const Text('Import audio'))])));
  Widget _gradientCard({required double height, required Widget child}) => Container(height: height, padding: const EdgeInsets.all(20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_seasonColor(season), _seasonColor(season).withOpacity(.4), Theme.of(context).colorScheme.surfaceContainerHighest])), child: child);
  Widget _trackTile(String name) => ListTile(leading: Container(width: 48, height: 48, decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: LinearGradient(colors: [_seasonColor(season), _seasonColor(season).withOpacity(.45)])), child: const Icon(Icons.music_note, color: Colors.white)), title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis), subtitle: const Text('Local audio'), trailing: IconButton(onPressed: _showPlayer, icon: const Icon(Icons.play_circle_fill_rounded, size: 32)));
  Color _seasonColor(String v) => switch (v) {'Spring' => const Color(0xFF43B581), 'Summer' => const Color(0xFFFF8A45), 'Autumn' => const Color(0xFFB66532), 'Winter' => const Color(0xFF4386E8), _ => const Color(0xFF8174F7)};
  void _importDemo() => setState(() { if (!imported.contains('Imported music will appear here')) imported.add('Imported music will appear here'); });
  void _showPlayer() => showModalBottomSheet(context: context, isScrollControlled: true, showDragHandle: true, builder: (context) => Padding(padding: const EdgeInsets.fromLTRB(24, 12, 24, 36), child: Column(mainAxisSize: MainAxisSize.min, children: [ _gradientCard(height: 220, child: const Center(child: Icon(Icons.album_rounded, size: 94, color: Colors.white))), const SizedBox(height: 20), const Text('Ready when you are', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 4), const Text('Choose a track from your local library'), const SizedBox(height: 24), const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Icon(Icons.skip_previous_rounded, size: 36), Icon(Icons.play_circle_fill_rounded, size: 66), Icon(Icons.skip_next_rounded, size: 36)]), const SizedBox(height: 18)])));
}
