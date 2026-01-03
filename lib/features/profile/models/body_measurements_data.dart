class BodyMeasurementsData {
  const BodyMeasurementsData({this.weightKg, this.heightCm, this.waistCm});

  final double? weightKg;
  final double? heightCm;
  final double? waistCm;

  BodyMeasurementsData copyWith({
    double? weightKg,
    double? heightCm,
    double? waistCm,
  }) {
    return BodyMeasurementsData(
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      waistCm: waistCm ?? this.waistCm,
    );
  }
}
