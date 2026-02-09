import 'map_id_resolver.dart';
import 'un_geoscheme.dart';
import 'geoscheme_to_map.dart';

/// UN regions (typed enum).
enum UnRegion {
  africa,
  americas,
  asia,
  europe,
  oceania
}

extension UnRegionX on UnRegion {
  String get label {
    switch (this) {
      case UnRegion.africa: return 'Africa';
      case UnRegion.americas: return 'Americas';
      case UnRegion.asia: return 'Asia';
      case UnRegion.europe: return 'Europe';
      case UnRegion.oceania: return 'Oceania';
    }
  }

  Set<String> countriesAlpha2() => UnGeoscheme.countriesInRegion(label);

  Set<String> mapIds({MapIdResolver mapIdResolver = defaultMapIdResolver}) {
    return GeoschemeToMap.mapIdsForRegion(label, mapIdResolver: mapIdResolver);
  }
}

/// UN subregions (typed enum).
enum UnSubregion {
  australiaAndNewZealand,
  centralAsia,
  easternAsia,
  easternEurope,
  latinAmericaAndTheCaribbean,
  melanesia,
  micronesia,
  northernAfrica,
  northernAmerica,
  northernEurope,
  polynesia,
  southEasternAsia,
  southernAsia,
  southernEurope,
  subSaharanAfrica,
  westernAsia,
  westernEurope
}

extension UnSubregionX on UnSubregion {
  String get label {
    switch (this) {
      case UnSubregion.australiaAndNewZealand: return 'Australia and New Zealand';
      case UnSubregion.centralAsia: return 'Central Asia';
      case UnSubregion.easternAsia: return 'Eastern Asia';
      case UnSubregion.easternEurope: return 'Eastern Europe';
      case UnSubregion.latinAmericaAndTheCaribbean: return 'Latin America and the Caribbean';
      case UnSubregion.melanesia: return 'Melanesia';
      case UnSubregion.micronesia: return 'Micronesia';
      case UnSubregion.northernAfrica: return 'Northern Africa';
      case UnSubregion.northernAmerica: return 'Northern America';
      case UnSubregion.northernEurope: return 'Northern Europe';
      case UnSubregion.polynesia: return 'Polynesia';
      case UnSubregion.southEasternAsia: return 'South-eastern Asia';
      case UnSubregion.southernAsia: return 'Southern Asia';
      case UnSubregion.southernEurope: return 'Southern Europe';
      case UnSubregion.subSaharanAfrica: return 'Sub-Saharan Africa';
      case UnSubregion.westernAsia: return 'Western Asia';
      case UnSubregion.westernEurope: return 'Western Europe';
    }
  }

  Set<String> countriesAlpha2() => UnGeoscheme.countriesInSubregion(label);

  Set<String> mapIds({MapIdResolver mapIdResolver = defaultMapIdResolver}) {
    return GeoschemeToMap.mapIdsForSubregion(label, mapIdResolver: mapIdResolver);
  }
}

/// UN intermediate regions (typed enum).
enum UnIntermediateRegion {
  caribbean,
  centralAmerica,
  easternAfrica,
  middleAfrica,
  southAmerica,
  southernAfrica,
  westernAfrica
}

extension UnIntermediateRegionX on UnIntermediateRegion {
  String get label {
    switch (this) {
      case UnIntermediateRegion.caribbean: return 'Caribbean';
      case UnIntermediateRegion.centralAmerica: return 'Central America';
      case UnIntermediateRegion.easternAfrica: return 'Eastern Africa';
      case UnIntermediateRegion.middleAfrica: return 'Middle Africa';
      case UnIntermediateRegion.southAmerica: return 'South America';
      case UnIntermediateRegion.southernAfrica: return 'Southern Africa';
      case UnIntermediateRegion.westernAfrica: return 'Western Africa';
    }
  }

  Set<String> countriesAlpha2() =>
      UnGeoscheme.countriesInIntermediateRegion(label);

  Set<String> mapIds({MapIdResolver mapIdResolver = defaultMapIdResolver}) {
    return GeoschemeToMap.mapIdsForIntermediateRegion(
      label,
      mapIdResolver: mapIdResolver,
    );
  }
}
