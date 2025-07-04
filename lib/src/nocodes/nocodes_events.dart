/// Base class for all No-Codes events
abstract class NoCodesEvent {
  const NoCodesEvent();
}

/// Event when No-Codes screen is shown
class NoCodesScreenShownEvent extends NoCodesEvent {
  final Map<String, dynamic>? payload;

  const NoCodesScreenShownEvent({this.payload});

  factory NoCodesScreenShownEvent.fromMap(Map<String, dynamic> map) {
    return NoCodesScreenShownEvent(
      payload: map['payload'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': 'nocodes_screen_shown',
      'payload': payload,
    };
  }

  @override
  String toString() {
    return 'NoCodesScreenShownEvent(payload: $payload)';
  }
}

/// Event when NoCodes flow is finished
class NoCodesFinishedEvent extends NoCodesEvent {
  final Map<String, dynamic>? payload;

  const NoCodesFinishedEvent({this.payload});

  factory NoCodesFinishedEvent.fromMap(Map<String, dynamic> map) {
    return NoCodesFinishedEvent(
      payload: map['payload'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': 'nocodes_finished',
      'payload': payload,
    };
  }

  @override
  String toString() {
    return 'NoCodesFinishedEvent(payload: $payload)';
  }
}

/// Event when NoCodes action is started
class NoCodesActionStartedEvent extends NoCodesEvent {
  final Map<String, dynamic>? payload;

  const NoCodesActionStartedEvent({this.payload});

  factory NoCodesActionStartedEvent.fromMap(Map<String, dynamic> map) {
    return NoCodesActionStartedEvent(
      payload: map['payload'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': 'nocodes_action_started',
      'payload': payload,
    };
  }

  @override
  String toString() {
    return 'NoCodesActionStartedEvent(payload: $payload)';
  }
}

/// Event when NoCodes action failed
class NoCodesActionFailedEvent extends NoCodesEvent {
  final Map<String, dynamic>? payload;

  const NoCodesActionFailedEvent({this.payload});

  factory NoCodesActionFailedEvent.fromMap(Map<String, dynamic> map) {
    return NoCodesActionFailedEvent(
      payload: map['payload'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': 'nocodes_action_failed',
      'payload': payload,
    };
  }

  @override
  String toString() {
    return 'NoCodesActionFailedEvent(payload: $payload)';
  }
}

/// Event when NoCodes action is finished
class NoCodesActionFinishedEvent extends NoCodesEvent {
  final Map<String, dynamic>? payload;

  const NoCodesActionFinishedEvent({this.payload});

  factory NoCodesActionFinishedEvent.fromMap(Map<String, dynamic> map) {
    return NoCodesActionFinishedEvent(
      payload: map['payload'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': 'nocodes_action_finished',
      'payload': payload,
    };
  }

  @override
  String toString() {
    return 'NoCodesActionFinishedEvent(payload: $payload)';
  }
}

/// Event when NoCodes screen failed to load
class NoCodesScreenFailedToLoadEvent extends NoCodesEvent {
  final Map<String, dynamic>? payload;

  const NoCodesScreenFailedToLoadEvent({this.payload});

  factory NoCodesScreenFailedToLoadEvent.fromMap(Map<String, dynamic> map) {
    return NoCodesScreenFailedToLoadEvent(
      payload: map['payload'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': 'nocodes_screen_failed_to_load',
      'payload': payload,
    };
  }

  @override
  String toString() {
    return 'NoCodesScreenFailedToLoadEvent(payload: $payload)';
  }
} 