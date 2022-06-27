
class Phases {
  final String? phase;
  final double? time;

  Phases(this.phase, this.time);
}

List<Phases> getChartData(Sleep) {
  final List<Phases> chartData = [
    Phases('wake', Sleep.wake/2),
    Phases('light', Sleep.light/2),
    Phases('rem', Sleep.rem/2),
    Phases('deep', Sleep.deep/2),
  ];
  return chartData;
}
