import 'package:d_sample/d_sample.dart';

class PlainEvent implements SamplingData {
  final int _time;
  final double _value;

  const PlainEvent(this._time, this._value);

  @override
  int get samplingOrder => _time;

  @override
  double get samplingValue => _value;

  @override
  int get hashCode {
    return Object.hash(_time, _value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    return other is PlainEvent && other._time == _time;
  }
}
