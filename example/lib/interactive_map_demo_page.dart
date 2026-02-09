import 'package:flutter/material.dart';
import 'package:interactive_world_map/interactive_world_map.dart';

enum _Mode { world, region, subregion, custom }

class InteractiveMapDemoPage extends StatefulWidget {
  const InteractiveMapDemoPage({super.key});

  @override
  State<InteractiveMapDemoPage> createState() => _InteractiveMapDemoPageState();
}

class _InteractiveMapDemoPageState extends State<InteractiveMapDemoPage> {
  final _controller = WorldMapController();

  _Mode _mode = _Mode.world;
  late final List<UnRegion> _regions = UnRegion.values;
  UnRegion _selectedRegion = UnRegion.values.first;

  List<UnSubregion> _subregions = const [];
  UnSubregion? _selectedSubregion;

  final TextEditingController _customIdsController =
      TextEditingController(text: 'DE, FR, ES');

  bool _excludeRemoteIslands = true;
  RemoteIslandLevel _remoteIslandLevel = RemoteIslandLevel.main;

  bool _autoFit = true;
  bool _allowPan = true;
  bool _allowZoom = true;

  bool _showBorders = true;
  double _borderWidth = 0.8;
  BorderWidthMode _borderWidthMode = BorderWidthMode.screenSpace;

  @override
  void initState() {
    super.initState();
    _refreshSubregions();
    _updateHighlights();
  }

  @override
  void dispose() {
    _customIdsController.dispose();
    _controller.dispose();
    super.dispose();
  }

  UnSubregion? _subregionFromLabel(String label) {
    return UnSubregion.values
        .cast<UnSubregion?>()
        .firstWhere((s) => s!.label == label, orElse: () => null);
  }

  void _refreshSubregions() {
    final labels = UnGeoscheme.subregions(region: _selectedRegion.label)
        .where((e) => e.trim().isNotEmpty);
    _subregions = [
      for (final l in labels)
        if (_subregionFromLabel(l) != null) _subregionFromLabel(l)!,
    ];
    _selectedSubregion = _subregions.isNotEmpty ? _subregions.first : null;
  }

  void _updateHighlights() {
    if (_mode == _Mode.world) {
      _controller.highlightedIds = {};
      return;
    }
    _controller.highlightedIds = _currentIds();
  }

  void _scheduleAutoFit() {
    if (!_autoFit) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fitToScope();
    });
  }

  void _setMode(_Mode next) {
    if (_mode == next) return;
    setState(() {
      _mode = next;
      if (_mode == _Mode.subregion) {
        _refreshSubregions();
      }
      _updateHighlights();
    });
    _scheduleAutoFit();
  }

  void _setRegion(UnRegion next) {
    if (_selectedRegion == next) return;
    setState(() {
      _selectedRegion = next;
      _refreshSubregions();
      _updateHighlights();
    });
    _scheduleAutoFit();
  }

  void _setSubregion(UnSubregion next) {
    if (_selectedSubregion == next) return;
    setState(() {
      _selectedSubregion = next;
      _updateHighlights();
    });
    _scheduleAutoFit();
  }

  Set<String> _currentIds() {
    switch (_mode) {
      case _Mode.world:
        return const <String>{};
      case _Mode.region:
        return _selectedRegion.mapIds();
      case _Mode.subregion:
        return _selectedSubregion?.mapIds() ?? {};
      case _Mode.custom:
        return _parseCustomIds(_customIdsController.text);
    }
  }

  Set<String>? _visibleIds() {
    if (_mode == _Mode.world) return null;
    final ids = _currentIds();
    return ids.isEmpty ? null : ids;
  }

  static Set<String> _parseCustomIds(String raw) {
    final out = <String>{};
    final parts = raw
        .split(RegExp(r'[\s,;]+'))
        .map((e) => e.trim().toUpperCase())
        .where((e) => e.isNotEmpty);
    out.addAll(parts);
    return out;
  }

  FitOptions _currentFitOptions() {
    return FitOptions(
      padding: 12,
      excludeRemoteIslands: _excludeRemoteIslands,
      remoteIslandLevel: _remoteIslandLevel,
    );
  }

  void _fitToScope() {
    final ids = _currentIds();
    if (ids.isEmpty) return;
    _controller.fitToCountries(ids, options: _currentFitOptions());
  }

  void _fitToSelected() {
    final selected = _controller.selectedId;
    if (selected == null) return;
    _controller.fitToCountries({selected}, options: _currentFitOptions());
  }

  WorldMapStyle _currentStyle(ColorScheme scheme) {
    return WorldMapStyle(
      landFillColor: scheme.surface,
      selectedFillColor: scheme.primary,
      highlightedFillColor: scheme.secondaryContainer,
      borderColor: scheme.outlineVariant,
      showBorders: _showBorders,
      borderWidth: _borderWidth,
      borderWidthMode: _borderWidthMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ids = _currentIds();
    final visibleIds = _visibleIds();
    final scheme = Theme.of(context).colorScheme;

    final map = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withOpacity(0.08),
            scheme.surface.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.6)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveWorldMap(
                controller: _controller,
                style: _currentStyle(scheme),
                allowPan: _allowPan,
                allowZoom: _allowZoom,
                visibleCountryIds: visibleIds,
                excludeRemoteIslandsInRender: false,
                selectOnTap: true,
                toggleSelectionOnTap: true,
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: _InfoPill(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final value = _controller.selectedId ?? 'None';
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.place, size: 16),
                        const SizedBox(width: 8),
                        Text('Selected: $value'),
                      ],
                    );
                  },
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: _InfoPill(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.layers, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      _mode == _Mode.world
                          ? 'World view'
                          : '${ids.length} countries',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final controls = Card(
      elevation: 0,
      color: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant.withOpacity(0.5)),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(
            title: 'Scope',
            subtitle: 'Choose the country set that is visible and used for fit.',
          ),
          const SizedBox(height: 8),
          SegmentedButton<_Mode>(
            segments: const [
              ButtonSegment(
                value: _Mode.world,
                label: Text('World'),
                icon: Icon(Icons.public),
              ),
              ButtonSegment(
                value: _Mode.region,
                label: Text('Region'),
                icon: Icon(Icons.map),
              ),
              ButtonSegment(
                value: _Mode.subregion,
                label: Text('Subregion'),
                icon: Icon(Icons.grid_view),
              ),
              ButtonSegment(
                value: _Mode.custom,
                label: Text('Custom'),
                icon: Icon(Icons.edit),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (selection) => _setMode(selection.first),
          ),
          const SizedBox(height: 12),
          if (_mode == _Mode.region)
            DropdownButtonFormField<UnRegion>(
              value: _selectedRegion,
              items: _regions
                  .map(
                    (r) => DropdownMenuItem(
                      value: r,
                      child: Text(r.label),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                _setRegion(v);
              },
              decoration: const InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
              ),
            ),
          if (_mode == _Mode.subregion) ...[
            DropdownButtonFormField<UnRegion>(
              value: _selectedRegion,
              items: _regions
                  .map(
                    (r) => DropdownMenuItem(
                      value: r,
                      child: Text(r.label),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                _setRegion(v);
              },
              decoration: const InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<UnSubregion>(
              value: _selectedSubregion,
              items: _subregions
                  .map(
                    (r) => DropdownMenuItem(
                      value: r,
                      child: Text(r.label),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                _setSubregion(v);
              },
              decoration: const InputDecoration(
                labelText: 'Subregion',
                border: OutlineInputBorder(),
              ),
            ),
          ],
          if (_mode == _Mode.custom) ...[
            TextField(
              controller: _customIdsController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Country IDs',
                border: OutlineInputBorder(),
                helperText: 'Comma or space separated (e.g., DE, FR, ES).',
              ),
              onChanged: (_) {
                setState(_updateHighlights);
              },
              onSubmitted: (_) => _scheduleAutoFit(),
            ),
          ],
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final hasSelection = _controller.selectedId != null;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton.icon(
                    onPressed: ids.isEmpty ? null : _fitToScope,
                    icon: const Icon(Icons.center_focus_strong),
                    label: const Text('Fit to scope'),
                  ),
                  OutlinedButton.icon(
                    onPressed: hasSelection ? _fitToSelected : null,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Fit to selected'),
                  ),
                ],
              );
            },
          ),
          SwitchListTile(
            title: const Text('Auto-fit when scope changes'),
            subtitle: const Text('Keeps the map centered on the active set.'),
            value: _autoFit,
            onChanged: (v) => setState(() => _autoFit = v),
          ),
          const Divider(height: 32),
          _SectionHeader(
            title: 'Remote Islands',
            subtitle:
                'Control whether far-away islands are excluded when fitting.',
          ),
          SwitchListTile(
            title: const Text('Exclude remote islands'),
            subtitle: const Text('Helps focus on the main landmass.'),
            value: _excludeRemoteIslands,
            onChanged: (v) => setState(() => _excludeRemoteIslands = v),
          ),
          if (_excludeRemoteIslands) ...[
            const SizedBox(height: 8),
            SegmentedButton<RemoteIslandLevel>(
              segments: const [
                ButtonSegment(
                  value: RemoteIslandLevel.main,
                  label: Text('Main'),
                  icon: Icon(Icons.crop_square),
                ),
                ButtonSegment(
                  value: RemoteIslandLevel.mainPlus,
                  label: Text('Main+'),
                  icon: Icon(Icons.dashboard_customize),
                ),
                ButtonSegment(
                  value: RemoteIslandLevel.allParts,
                  label: Text('All'),
                  icon: Icon(Icons.layers),
                ),
              ],
              selected: {_remoteIslandLevel},
              onSelectionChanged: (selection) =>
                  setState(() => _remoteIslandLevel = selection.first),
            ),
            const SizedBox(height: 6),
            Text(
              _remoteIslandLevel == RemoteIslandLevel.main
                  ? 'Main keeps only the largest mainland cluster.'
                  : _remoteIslandLevel == RemoteIslandLevel.mainPlus
                      ? 'Main+ keeps the top two clusters for split countries.'
                      : 'All keeps all parts and islands for fitting.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const Divider(height: 32),
          _SectionHeader(
            title: 'Interaction',
            subtitle: 'Tweak how the map behaves during exploration.',
          ),
          SwitchListTile(
            title: const Text('Allow pan'),
            subtitle: const Text('Drag the map to inspect local areas.'),
            value: _allowPan,
            onChanged: (v) => setState(() => _allowPan = v),
          ),
          SwitchListTile(
            title: const Text('Allow zoom'),
            subtitle: const Text('Pinch or scroll to zoom in and out.'),
            value: _allowZoom,
            onChanged: (v) => setState(() => _allowZoom = v),
          ),
          const Divider(height: 32),
          _SectionHeader(
            title: 'Style',
            subtitle: 'Adjust borders and visual emphasis.',
          ),
          SwitchListTile(
            title: const Text('Show borders'),
            subtitle: const Text('Outline countries for clearer separation.'),
            value: _showBorders,
            onChanged: (v) => setState(() => _showBorders = v),
          ),
          const SizedBox(height: 8),
          Text('Border width: ${_borderWidth.toStringAsFixed(2)}'),
          Slider(
            value: _borderWidth,
            min: 0.2,
            max: 2.4,
            onChanged: (v) => setState(() => _borderWidth = v),
          ),
          Text(
            'Controls how thick country outlines appear on the map.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          SegmentedButton<BorderWidthMode>(
            segments: const [
              ButtonSegment(
                value: BorderWidthMode.screenSpace,
                label: Text('Screen'),
                icon: Icon(Icons.fit_screen),
              ),
              ButtonSegment(
                value: BorderWidthMode.mapSpace,
                label: Text('Map'),
                icon: Icon(Icons.zoom_in),
              ),
            ],
            selected: {_borderWidthMode},
            onSelectionChanged: (selection) =>
                setState(() => _borderWidthMode = selection.first),
          ),
          const SizedBox(height: 6),
          Text(
            _borderWidthMode == BorderWidthMode.screenSpace
                ? 'Screen keeps borders a constant pixel width while zooming.'
                : 'Map scales borders with the map zoom level.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 980;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: wide
              ? Row(
                  children: [
                    Expanded(child: map),
                    const SizedBox(width: 16),
                    SizedBox(width: 380, child: controls),
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: map),
                    const SizedBox(height: 12),
                    SizedBox(height: 360, child: controls),
                  ],
                ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(subtitle, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodySmall ?? const TextStyle(),
          child: child,
        ),
      ),
    );
  }
}
