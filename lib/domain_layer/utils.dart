
/// Maps list from List<T> to List<U>, and applies filter, if provided.
/// Use: Intended for mapping lists of DTOs to lists of models,
///      e.g. List<Ride> => List<RideModel>
List<U> dtosToModels<T, U>(List<T> dtos, U Function(T dto) mapper, [bool Function(U)? filter]) {
  return dtos
      .map(mapper)
      .where(filter ?? (_) => true)
      .toList();
}

/// Maps stream from Stream<List<T>> to Stream<List<U>>, and applies filter,
/// if provided.
/// Use: Intended for mapping streams of DTOs to stream of models,
///      e.g. Stream<List<Ride>> => Stream<List<RideModel>>
Stream<List<U>> transformStream<T, U>(Stream<List<T>> dtosStream, U Function(T dto) mapper, [bool Function(U)? filter]) {
  return dtosStream
      .map((dtos) => dtosToModels(dtos, mapper, filter))
      .asBroadcastStream();
}
