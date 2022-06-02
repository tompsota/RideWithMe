
// maps List<T> to List<U> and applies filter, if specified
// intended for mapping DTOs to models (List<Ride> => List<RideModel> etc.)
List<U> dtosToModels<T, U>(List<T> dtos, U Function(T dto) mapper, [bool Function(U)? filter]) {
  return dtos
      .map(mapper)
      .where(filter ?? (_) => true)
      .toList();
}

// maps stream from Stream<List<T>> to Stream<List<U>>
// intended for mapping DTOs to models (Stream<List<Ride>> => Stream<List<RideModel>>)
Stream<List<U>> transformStream<T, U>(Stream<List<T>> dtosStream, U Function(T dto) mapper, [bool Function(U)? filter]) {
  return dtosStream
      .map((dtos) => dtosToModels(dtos, mapper, filter))
      .asBroadcastStream();
}
