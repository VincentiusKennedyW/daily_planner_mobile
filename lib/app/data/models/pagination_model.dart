class Pagination {
  final int? total;
  final int? page;
  final int? totalPages;
  final int? limit;

  Pagination({
    this.total,
    this.page,
    this.totalPages,
    this.limit,
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
