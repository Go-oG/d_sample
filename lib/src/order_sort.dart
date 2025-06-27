import 'dart:core';

import 'package:d_sample/d_sample.dart';

typedef OrderSort = int Function(SamplingData? e1, SamplingData? e2);

int orderAsc(SamplingData? e1, SamplingData? e2) {
  if (e1 == null && e2 == null) {
    return 0;
  }
  if (e1 == null) {
    return -1;
  }
  if (e2 == null) {
    return 1;
  }
  return e1.samplingOrder < e2.samplingOrder ? -1 : 1;
}

int valueAsc(SamplingData? e1, SamplingData? e2) {
  if (e1 == null && e2 == null) {
    return 0;
  }
  if (e1 == null) {
    return -1;
  }
  if (e2 == null) {
    return 1;
  }
  return e1.samplingValue < e2.samplingValue ? -1 : 1;
}

int valueDesc(SamplingData? e1, SamplingData? e2) {
  if (e1 == null && e2 == null) {
    return 0;
  }
  if (e1 == null) {
    return -1;
  }
  if (e2 == null) {
    return 1;
  }
  return e1.samplingValue < e2.samplingValue ? 1 : -1;
}

int valueAbsAsc(SamplingData? e1, SamplingData? e2) {
  if (e1 == null && e2 == null) {
    return 0;
  } else if (e1 == null) {
    return -1;
  } else if (e2 == null) {
    return 1;
  }
  return (e1.samplingValue.abs()) < (e2.samplingValue.abs()) ? -1 : 1;
}

int valueAbsDesc(SamplingData? e1, SamplingData? e2) {
  if (e1 == null && e2 == null) {
    return 0;
  }
  if (e1 == null) {
    return -1;
  }
  if (e2 == null) {
    return 1;
  }
  return (e1.samplingValue.abs()) < (e2.samplingValue.abs()) ? 1 : -1;
}
