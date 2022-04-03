/// Should be used as a change notifier,
/// since we choose rides filters in a different page
/// than where we apply the filter (in the Dashboard page) ?
class RidesFilterModel {
  // minimum ride distance (e.g. user wants to ride for at least 15km)
  final int? minRideDistance;
  // maximum ride distance (e.g. user wants to ride for at most 80km)
  final int? maxRideDistance;

  const RidesFilterModel(this.minRideDistance, this.maxRideDistance);
}