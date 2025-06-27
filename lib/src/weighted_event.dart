import 'package:d_sample/d_sample.dart';

import 'plain_event.dart';

class WeightEvent implements SamplingData {
  late final SamplingData event;
  double _weight = 0;

  WeightEvent.of(int time, double value) {
    event = PlainEvent(time, value);
  }

  WeightEvent(this.event);

  SamplingData getEvent() {
    return event;
  }

  @override
  int get samplingOrder => event.samplingOrder;

  @override
  double get samplingValue => event.samplingValue;

  double getWeight() {
    return _weight;
  }

  void setWeight(double weight) {
    _weight = weight;
  }

  @override
  int get hashCode {
    return Object.hash(event.samplingOrder, event.samplingValue);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! WeightEvent) {
      return false;
    }
    if (event.samplingOrder != other.event.samplingOrder) {
      return false;
    }
    if (event.samplingValue != other.event.samplingValue) {
      return false;
    }

    return true;
  }
}
