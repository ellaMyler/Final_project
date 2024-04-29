class CityCompare {
  final String city;
  final int meanSoftwareDeveloperSalaryAdjusted;
  final double localPurchasingPower;

  CityCompare({
    required this.city,
    required this.meanSoftwareDeveloperSalaryAdjusted,
    required this.localPurchasingPower,
  });

  factory CityCompare.fromJson(Map<String, dynamic> json) {
    return CityCompare(
      city: json['City'],
      meanSoftwareDeveloperSalaryAdjusted: json['Mean Software Developer Salary (adjusted)'],
      localPurchasingPower: (json["Local Purchasing Power avg"] is int)
        ? (json['Local Purchasing Power avg'] as int).toDouble()
        : json['Local Purchasing Power avg'], // Handle both int and double
    );
  }
}