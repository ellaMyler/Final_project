class CityData {
  final String city;
  final int numSoftwareDeveloperJobs;
  final int meanSoftwareDeveloperSalaryAdjusted;
  final double costOfLivingPlusRentAvg;

  CityData({
    required this.city,
    required this.numSoftwareDeveloperJobs,
    required this.meanSoftwareDeveloperSalaryAdjusted,
    required this.costOfLivingPlusRentAvg,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      city: json['City'],
      numSoftwareDeveloperJobs: json['Number of Software Developer Jobs'],
      meanSoftwareDeveloperSalaryAdjusted: json['Mean Software Developer Salary (adjusted)'],
      costOfLivingPlusRentAvg: (json['Cost of Living Plus Rent avg'] is int)
          ? (json['Cost of Living Plus Rent avg'] as int).toDouble()
          : json['Cost of Living Plus Rent avg'], // Handle both int and double
    );
  }
}


