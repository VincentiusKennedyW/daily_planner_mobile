class Period {
  final int year;
  final int month;
  final String startDate;
  final String endDate;

  Period({
    required this.year,
    required this.month,
    required this.startDate,
    required this.endDate,
  });

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      year: json['year'],
      month: json['month'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
