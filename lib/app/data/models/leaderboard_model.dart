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
  final DateTime? dateFilter;
  final Pagination pagination;

  LeaderboardData({
    required this.leaderboard,
    this.dateFilter,
    required this.pagination,
  });

  factory LeaderboardData.fromJson(Map<String, dynamic> json) {
    return LeaderboardData(
      leaderboard: (json['leaderboard'] as List)
          .map((item) => LeaderboardUser.fromJson(item))
          .toList(),
      dateFilter:
          json['filter'] != null ? DateTime.parse(json['filter']) : null,
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leaderboard': leaderboard.map((item) => item.toJson()).toList(),
      'dateFilter': dateFilter?.toIso8601String(),
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
  final List<ChartData>? chartData;

  LeaderboardUser({
    required this.id,
    required this.name,
    required this.email,
    required this.totalPoints,
    required this.completedTasks,
    required this.ongoingTasks,
    this.chartData,
  });

  LeaderboardUser copyWith({
    int? id,
    String? name,
    String? email,
    int? totalPoints,
    int? completedTasks,
    int? ongoingTasks,
    List<ChartData>? chartData,
  }) {
    return LeaderboardUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      totalPoints: totalPoints ?? this.totalPoints,
      completedTasks: completedTasks ?? this.completedTasks,
      ongoingTasks: ongoingTasks ?? this.ongoingTasks,
      chartData: chartData ?? this.chartData,
    );
  }

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      totalPoints: json['totalPoints'],
      completedTasks: json['completedTasks'],
      ongoingTasks: json['ongoingTasks'],
      chartData: (json['chartData'] as List<dynamic>?)
          ?.map((item) => ChartData.fromJson(item as Map<String, dynamic>))
          .toList(),
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
      'chartData': chartData,
    };
  }
}

class ChartData {
  final String date;
  final int points;

  ChartData({
    required this.date,
    required this.points,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      date: json['date'] ?? '',
      points: json['points'] ?? 0,
    );
  }
}

class ChartPoint {
  final String date;
  final int points;

  ChartPoint({
    required this.date,
    required this.points,
  });

  factory ChartPoint.fromJson(Map<String, dynamic> json) {
    return ChartPoint(
      date: json['date'],
      points: json['points'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'points': points,
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
