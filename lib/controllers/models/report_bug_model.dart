class BugReport {
  final String userId;
  final String bug;

  BugReport({required this.userId, required this.bug});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bug': bug,
    };
  }
}
