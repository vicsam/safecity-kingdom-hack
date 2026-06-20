/// Incident categories and types
class IncidentCategories {
  IncidentCategories._();

  static const String traffic = 'Traffic';
  static const String accident = 'Accident';
  static const String crime = 'Crime';
  static const String fire = 'Fire';
  static const String flooding = 'Flooding';
  static const String infrastructure = 'Infrastructure';
  static const String health = 'Health Emergency';
  static const String utility = 'Utility Issue';
  static const String other = 'Other';

  static const List<String> allCategories = [
    traffic,
    accident,
    crime,
    fire,
    flooding,
    infrastructure,
    health,
    utility,
    other,
  ];

  static const Map<String, String> categoryDescriptions = {
    traffic: 'Traffic congestion or road obstruction',
    accident: 'Vehicle or pedestrian accident',
    crime: 'Criminal activity or security concern',
    fire: 'Fire outbreak or fire hazard',
    flooding: 'Water overflow or flooding',
    infrastructure: 'Damaged roads, bridges, or public infrastructure',
    health: 'Medical emergency or health crisis',
    utility: 'Power outage, water, or gas issues',
    other: 'Other incident type',
  };

  static const Map<String, String> categoryEmojis = {
    traffic: '🚗',
    accident: '⚠️',
    crime: '🚔',
    fire: '🔥',
    flooding: '💧',
    infrastructure: '🏗️',
    health: '🏥',
    utility: '⚡',
    other: '📍',
  };
}

/// Incident severity levels
class IncidentSeverity {
  IncidentSeverity._();

  static const String low = 'Low';
  static const String medium = 'Medium';
  static const String high = 'High';
  static const String critical = 'Critical';

  static const List<String> allSeverities = [low, medium, high, critical];
}

/// Incident status
class IncidentStatus {
  IncidentStatus._();

  static const String reported = 'Reported';
  static const String acknowledged = 'Acknowledged';
  static const String inProgress = 'In Progress';
  static const String escalated = 'Escalated';
  static const String resolved = 'Resolved';
  static const String closed = 'Closed';

  static const List<String> allStatuses = [
    reported,
    acknowledged,
    inProgress,
    escalated,
    resolved,
    closed,
  ];
}
