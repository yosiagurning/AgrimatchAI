class SoilAnalysis {
  final String id;
  final String landName;
  final String predictedSoilType;
  final String recommendedCrop;
  final int recommendationScore;
  final String imageUrl;
  final DateTime createdAt;
  final Map<String, dynamic> details;

  SoilAnalysis({
    required this.id,
    required this.landName,
    required this.predictedSoilType,
    required this.recommendedCrop,
    required this.recommendationScore,
    required this.imageUrl,
    required this.createdAt,
    required this.details,
  });

  factory SoilAnalysis.fromJson(Map<String, dynamic> json) {
    return SoilAnalysis(
      id: json['id']?.toString() ?? '',
      landName: json['land_name'] ?? '',
      predictedSoilType: json['predicted_soil_type'] ?? '',
      recommendedCrop: json['recommended_crop'] ?? '',
      recommendationScore: (json['recommendation_score'] ?? 0) as int,
      imageUrl: json['soil_image_url'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      details: (json['details'] ?? {}) as Map<String, dynamic>,
    );
  }
}
