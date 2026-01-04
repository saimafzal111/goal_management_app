class Milestone {
  String id;
  String title;
  bool isCompleted;

  Milestone({
    String? id,
    required this.title,
    this.isCompleted = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Convert to Appwrite-compatible Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  /// Create from Appwrite document data
  factory Milestone.fromMap(Map<String, dynamic> map) {
    return Milestone(
      id: map['id'],
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}

class Goal {
  String id;
  String title;
  String description;
  String category;
  DateTime deadline;
  List<Milestone> milestones;

  Goal({
    String? id,
    required this.title,
    required this.description,
    required this.category,
    required this.deadline,
    List<Milestone>? milestones,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        milestones = milestones ?? [];

  /// Progress between 0.0 and 1.0
  double get progress {
    if (milestones.isEmpty) return 0.0;
    final completed = milestones.where((m) => m.isCompleted).length;
    return completed / milestones.length;
  }

  bool get isCompleted => progress >= 1.0;

  /// Convert Goal to Appwrite Map
  Map<String, dynamic> toMap(String userId) {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'category': category,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted,
      'milestones': milestones.map((m) => m.toMap()).toList(),
    };
  }

  /// Create Goal from Appwrite document
  factory Goal.fromMap(String id, Map<String, dynamic> map) {
    return Goal(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      deadline: DateTime.parse(map['deadline']),
      milestones: (map['milestones'] as List<dynamic>? ?? [])
          .map((m) => Milestone.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }
}
