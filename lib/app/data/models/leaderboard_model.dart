class LeaderboardResponse {
  final String status;
  final String message;
  final LeaderboardData data;

  LeaderboardResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    return LeaderboardResponse(
      status: json['status'],
      message: json['message'],
      data: LeaderboardData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class LeaderboardData {
  final List<LeaderboardUser> leaderboard;
  final Pagination pagination;

  LeaderboardData({
    required this.leaderboard,
    required this.pagination,
  });

  factory LeaderboardData.fromJson(Map<String, dynamic> json) {
    return LeaderboardData(
      leaderboard: (json['leaderboard'] as List)
          .map((item) => LeaderboardUser.fromJson(item))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leaderboard': leaderboard.map((item) => item.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class LeaderboardUser {
  final int id;
  final String name;
  final String email;
  final int totalPoints;
  final int completedTasks;
  final int ongoingTasks;

  LeaderboardUser({
    required this.id,
    required this.name,
    required this.email,
    required this.totalPoints,
    required this.completedTasks,
    required this.ongoingTasks,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      totalPoints: json['totalPoints'],
      completedTasks: json['completedTasks'],
      ongoingTasks: json['ongoingTasks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'totalPoints': totalPoints,
      'completedTasks': completedTasks,
      'ongoingTasks': ongoingTasks,
    };
  }
}

class Pagination {
  final int total;
  final int page;
  final int totalPages;
  final int limit;

  Pagination({
    required this.total,
    required this.page,
    required this.totalPages,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      page: json['page'],
      totalPages: json['totalPages'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'totalPages': totalPages,
      'limit': limit,
    };
  }
}
