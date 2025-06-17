class UserProfile {
  String name;
  String role;
  String avatar;
  List<String> skills;
  int totalPoints;
  int completedTasks;
  double productivity;

  UserProfile({
    required this.name,
    required this.role,
    this.avatar = '',
    this.skills = const [],
    this.totalPoints = 0,
    this.completedTasks = 0,
    this.productivity = 0.0,
  });
}
