//Class for implementing the Circular chart
class Phases {
  final String? phase;
  final double? time;

  Phases(this.phase, this.time);
}

//Object Sleep in input returns a List containing objects that associate the sleep phase name and the duration in minutes
List<Phases> getChartData(Sleep) {
  final List<Phases> chartData = [
    Phases('wake', Sleep.wake/2),
    Phases('light', Sleep.light/2),
    Phases('rem', Sleep.rem/2),
    Phases('deep', Sleep.deep/2),
  ];
  return chartData;
}
