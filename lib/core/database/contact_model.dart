class ContactModel {
  final int? id;
  final String name;
  final String phone;
  final String? lastFollowUpNotes;
  final String? priority;
  final String? stage;

  ContactModel({
    this.id,
    required this.name,
    required this.phone,
    this.lastFollowUpNotes,
    this.priority,
    this.stage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'last_follow_up_notes': lastFollowUpNotes,
      'priority': priority,
      'stage': stage,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'],
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      lastFollowUpNotes: map['last_follow_up_notes'],
      priority: map['priority'],
      stage: map['stage'],
    );
  }
}