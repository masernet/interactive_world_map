/// Mappt ISO-Alpha2 auf die tatsächliche ID im SVG.
/// Standard: defaultWithOverrides.
typedef MapIdResolver = String? Function(String alpha2);

String? identityMapIdResolver(String alpha2) => alpha2;

/// Beispiel für Sonderfälle (anpassen an deine echten IDs!)
String? defaultWithOverrides(String alpha2) {
  const overrides = <String, String>{
    'FR': 'X_FRA',
    'NO': "X_NOR"
    // 'XK': 'X_KOS',
  };
  return overrides[alpha2] ?? alpha2;
}

String? defaultMapIdResolver(String alpha2) => defaultWithOverrides(alpha2);
