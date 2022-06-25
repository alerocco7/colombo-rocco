
class Phases {
  final String? phase;
  final int? time;

  Phases(this.phase, this.time);
}

List<Phases> getChartData(Sleep) {
  final List<Phases> chartData = [
    Phases('deep', Sleep.deep),
    Phases('rem', Sleep.rem),
    Phases('wake', Sleep.wake),
    Phases('light', Sleep.light),
  ];
  return chartData;
}
