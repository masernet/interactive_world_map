import 'package:flutter/material.dart';
import 'package:interactive_world_map/interactive_world_map.dart';

int _alpha(double opacity) => (opacity * 255).round();
Color _withOpacity(Color color, double opacity) =>
    color.withAlpha(_alpha(opacity));

class IconExamplesPage extends StatelessWidget {
  const IconExamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final auNzCore = UnSubregion.australiaAndNewZealand.mapIds().difference(
      {
        CountryCode.CC,
        CountryCode.CX,
        CountryCode.HM,
        CountryCode.NF,
      }.toMapIds(),
    );

    final examples = <_IconExample>[
      _IconExample(
        title: 'DE (single)',
        ids: {CountryCode.DE}.toMapIds(),
        style: const WorldIconStyle(
          fillColor: Color(0xFF6FA8FF),
          borderColor: Color(0xFF2F4B7C),
        ),
      ),
      _IconExample(
        title: 'US (mainland only)',
        ids: {CountryCode.US}.toMapIds(),
        islandOptions: const IslandFilterOptions(
          excludeRemoteIslands: true,
          remoteIslandLevel: RemoteIslandLevel.main,
          presetOverrides: {
            'US': {
              RemoteIslandLevel.main: RemoteIslandPreset(
                minClusterDensityRatio: 0.6,
                maxClustersToKeep: 1,
              ),
            },
          },
        ),
      ),
      _IconExample(
        title: 'NO (mainland only)',
        ids: {CountryCode.NO}.toMapIds(),
        islandOptions: const IslandFilterOptions(
          excludeRemoteIslands: true,
          remoteIslandLevel: RemoteIslandLevel.main,
          presetOverrides: {
            'NO': {
              RemoteIslandLevel.main: RemoteIslandPreset(
                minClusterDensityRatio: 0.76,
              ),
            },
          },
        ),
      ),
      _IconExample(
        title: 'DK (include Greenland)',
        ids: {CountryCode.DK}.toMapIds(),
        islandOptions: const IslandFilterOptions(
          excludeRemoteIslands: true,
          remoteIslandLevel: RemoteIslandLevel.main,
          presetOverrides: {
            'DK': {
              RemoteIslandLevel.allParts: RemoteIslandPreset(),
            },
          },
        ),
      ),
      _IconExample(
        title: 'Region: Africa',
        ids: UnRegion.africa.mapIds(),
      ),
      _IconExample(
        title: 'Subregion: South‑eastern Asia',
        ids: UnSubregion.southEasternAsia.mapIds(),
      ),
      _IconExample(
        title: 'Subregion: Australia & New Zealand (core)',
        ids: auNzCore,
        islandOptions: const IslandFilterOptions(
          excludeRemoteIslands: true,
          remoteIslandLevel: RemoteIslandLevel.main,
        ),
      ),
      _IconExample(
        title: 'Intermediate: Caribbean',
        ids: UnIntermediateRegion.caribbean.mapIds(),
      ),
      _IconExample(
        title: 'Custom: DE, FR, ES',
        ids: {'DE', 'FR', 'ES'},
        islandOptions: const IslandFilterOptions(
          excludeRemoteIslands: true,
          remoteIslandLevel: RemoteIslandLevel.main,
          presetOverrides: {
            'ES': {
              RemoteIslandLevel.main: RemoteIslandPreset(
                minClusterDensityRatio: 0.6,
                maxClustersToKeep: 1,
              ),
            },
            'FR': {
              RemoteIslandLevel.main: RemoteIslandPreset(
                minClusterDensityRatio: 0.6,
                maxClustersToKeep: 1,
              ),
            },
          },
        ),
      ),
      _IconExample(
        title: 'Custom: Nordics',
        ids: {CountryCode.SE, CountryCode.NO, CountryCode.FI}.toMapIds(),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _withOpacity(scheme.primary, 0.08),
            _withOpacity(scheme.surface, 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'World Icon Recipes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                'Use the same geometry to render icons for countries, regions, '
                'and custom sets without runtime SVG.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: examples
                    .map(
                      (e) => _IconExampleCard(
                        example: e,
                        wide: wide,
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _IconExample {
  _IconExample({
    required this.title,
    required this.ids,
    this.style = const WorldIconStyle(),
    this.islandOptions = const IslandFilterOptions(),
  });

  final String title;
  final Set<String> ids;
  final WorldIconStyle style;
  final IslandFilterOptions islandOptions;
}

class _IconExampleCard extends StatelessWidget {
  const _IconExampleCard({
    required this.example,
    required this.wide,
  });

  final _IconExample example;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = wide ? 96.0 : 80.0;
    return SizedBox(
      width: wide ? 230 : 180,
      child: Card(
        elevation: 0,
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: _withOpacity(scheme.outlineVariant, 0.6)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                example.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              WorldIcon(
                ids: example.ids,
                size: size,
                style: example.style,
                islandOptions: example.islandOptions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
