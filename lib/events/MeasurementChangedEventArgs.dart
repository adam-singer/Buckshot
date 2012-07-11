// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


class MeasurementChangedEventArgs extends EventArgs {
  final ElementRect oldMeasurement;
  final ElementRect newMeasurement;

  BuckshotObject makeMe() => null;

  MeasurementChangedEventArgs(this.oldMeasurement, this.newMeasurement);

  String get type() => "MeasurementChangedEventArgs";
}
