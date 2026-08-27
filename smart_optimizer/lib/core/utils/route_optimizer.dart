class RouteOptimizer {
  static double calculateScore({
    required int time,
    required int cost,
    required int comfort,
    required int reliability,
    required int crowd,
  }) {
    double timeScore = (100 - time) * 0.30;
    double costScore = (100 - cost) * 0.20;
    double comfortScore = comfort * 0.20;
    double reliabilityScore = reliability * 0.20;
    double crowdPenalty = crowd * 0.10;

    return (
      timeScore +
      costScore +
      comfortScore +
      reliabilityScore -
      crowdPenalty
    ) /
        100;
  }
}