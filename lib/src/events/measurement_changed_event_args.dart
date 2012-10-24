part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.


class MeasurementChangedEventArgs extends EventArgs {
  final ElementRect oldMeasurement;
  final ElementRect newMeasurement;

  MeasurementChangedEventArgs(this.oldMeasurement, this.newMeasurement);
}
