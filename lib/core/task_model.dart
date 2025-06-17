class TaskCategory {
  final int riset;
  final int boq;
  final int development;
  final int implementation;
  final int maintenance;
  final int assembly;
  final int systemDocumentation;
  final int optimationServer;
  final int deploymentServer;
  final int troubleshootServer;

  TaskCategory({
    required this.riset,
    required this.boq,
    required this.development,
    required this.implementation,
    required this.maintenance,
    required this.assembly,
    required this.systemDocumentation,
    required this.optimationServer,
    required this.deploymentServer,
    required this.troubleshootServer,
  });

  factory TaskCategory.fromJson(Map<String, dynamic> json) {
    return TaskCategory(
      riset: json['RISET'],
      boq: json['BOQ'],
      development: json['DEVELOPMENT'],
      implementation: json['IMPLEMENTATION'],
      maintenance: json['MAINTENANCE'],
      assembly: json['ASSEMBLY'],
      systemDocumentation: json['SYSTEM_DOCUMENTATION'],
      optimationServer: json['OPTIMATION_SERVER'],
      deploymentServer: json['DEPLOYMENT_SERVER'],
      troubleshootServer: json['TROUBLESHOOT_SERVER'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RISET': riset,
      'BOQ': boq,
      'DEVELOPMENT': development,
      'IMPLEMENTATION': implementation,
      'MAINTENANCE': maintenance,
      'ASSEMBLY': assembly,
      'SYSTEM_DOCUMENTATION': systemDocumentation,
      'OPTIMATION_SERVER': optimationServer,
      'DEPLOYMENT_SERVER': deploymentServer,
      'TROUBLESHOOT_SERVER': troubleshootServer,
    };
  }
}

class TaskPriority {
  final int low;
  final int medium;
  final int high;
  final int urgent;

  TaskPriority({
    required this.low,
    required this.medium,
    required this.high,
    required this.urgent,
  });

  factory TaskPriority.fromJson(Map<String, dynamic> json) {
    return TaskPriority(
      low: json['LOW'],
      medium: json['MEDIUM'],
      high: json['HIGH'],
      urgent: json['URGENT'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LOW': low,
      'MEDIUM': medium,
      'HIGH': high,
      'URGENT': urgent,
    };
  }
}
