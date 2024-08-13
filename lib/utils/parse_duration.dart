String parseDuration(String duration) {
  final hours = RegExp(r'(\d+)H').firstMatch(duration)?.group(1);
  final minutes = RegExp(r'(\d+)M').firstMatch(duration)?.group(1);
  final seconds = RegExp(r'(\d+)S').firstMatch(duration)?.group(1);

  final parts = <String>[];
  if (hours != null) parts.add('${hours}h');
  if (minutes != null) parts.add('${minutes}m');
  if (seconds != null) parts.add('${seconds}s');

  return parts.join(' ');
}
