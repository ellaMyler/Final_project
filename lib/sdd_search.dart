import 'dart:convert';
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



class RegionData {
  final String? location;
  final String? company;
  final String? title;
  final double? salary;

  RegionData({
    required this.location,
    required this.company,
    required this.title,
    required this.salary,
  });

  factory RegionData.fromJson(Map<String, dynamic> json) {
    return RegionData(
      location: json['Location'] as String?,
      company: json['Company'] as String?,
      title: json['Title'] as String?, salary: json['Salary'] != null ? (json['Salary'] is int ? (json['Salary'] as int).toDouble() : json['Salary'] as double?) : null
    );
  }
}

class skillData{
  final String? location;
  final String? company;
  final String? title;
  final double? salary;
  final List<String>? skills2;



  skillData({
    required this.location,
    required this.company,
    required this.title,
    required this.salary,
    required this.skills2,

});

  factory skillData.fromJson(Map<String, dynamic> json) {
    List<String>? parseSkills(dynamic skills) {
      if (skills == null) {
        return [];
      } else if (skills is String) {
        // Handles string encoded list
        try {
          return jsonDecode(skills)
              .map((s) => s.toString().trim())
              .toList();
        } catch (e) {

          return skills.replaceAll(RegExp(r"^\[|\]$"), '') // Remove brackets
              .split(',') // Split by comma
              .map((s) => s.trim().replaceAll(RegExp(r"^'|'$"), '')) // Trim and remove single quotes
              .toList();
        }
      } else if (skills is List) {
        // Directly handles lists
        return skills.map((s) => s.toString().trim()).toList();
      } else {
        throw FormatException('Unsupported type for skills');
      }
    }

    return skillData(
      location: json['Location'] as String?,
      company: json['Company'] as String?,
      title: json['Title'] as String?,
      salary: json['Salary'] != null ? (json['Salary'] is int ? (json['Salary'] as int).toDouble() : json['Salary'] as double?) : null,
      skills2: parseSkills(json['Identified_Skills']),
    );
  }
}


