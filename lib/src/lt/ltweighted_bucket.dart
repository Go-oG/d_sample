import 'dart:core';

import 'package:d_sample/d_sample.dart';

import '../bucket.dart';
import '../weighted_event.dart';

class LTWeightedBucket implements Bucket {
  int _index = 0;
  List<WeightEvent?> events = [];
  WeightEvent? _selected;
  WeightEvent? _average;
  double sse = -1;

  LTWeightedBucket();

  LTWeightedBucket.of(WeightEvent event) {
    _index = 1;
    events.add(event);
  }

  LTWeightedBucket.ofSize(int size) {
    if (size <= 0) {
      throw ArgumentError("Bucket size must be positive");
    }
    events = List.filled(size, null, growable: true);
  }

  LTWeightedBucket copy() {
    LTWeightedBucket b = LTWeightedBucket.ofSize(events.length);
    b._index = _index;
    for (int i = 0; i < _index; i++) {
      b.events[i] = WeightEvent(events[i]!.getEvent());
    }
    return b;
  }

  @override
  void selectInto(List<OrderData> result) {
    for (WeightEvent e in select()) {
      result.add(e.getEvent());
    }
  }

  @override
  void add(OrderData e) {
    if (_index < events.length) {
      events[_index++] = e as WeightEvent;
    }
  }

  WeightEvent? get(int i) {
    return i < _index ? events[i] : null;
  }

  int size() {
    return _index;
  }

  WeightEvent average() {
    if (null == _average) {
      if (_index == 1) {
        _average = events[0];
      } else {
        double valueSum = 0;
        num timeSum = 0;
        for (int i = 0; i < _index; i++) {
          OrderData e = events[i]!;
          valueSum += e.getValue();
          timeSum += e.getOrder();
        }
        _average = WeightEvent.of(timeSum ~/ _index, valueSum / _index);
      }
    }
    return _average!;
  }

  List<WeightEvent> select() {
    if (_index == 0) {
      return [];
    }
    if (null == _selected) {
      if (_index == 1) {
        _selected = events[0];
      } else {
        double max = double.minPositive;
        int maxIndex = 0;
        for (int i = 0; i < _index; i++) {
          double w = events[i]!.getWeight();
          if (w > max) {
            maxIndex = i;
            max = w;
          }
        }
        _selected = events[maxIndex];
      }
    }
    return [_selected!];
  }

  double calcSSE(LTWeightedBucket last, LTWeightedBucket next) {
    if (sse == -1) {
      double lastVal = last.get(last.size() - 1)!.getValue();
      double nextVal = next.get(0)!.getValue();
      double avg = lastVal + nextVal;
      for (int i = 0; i < _index; i++) {
        OrderData e = events[i]!;
        avg += e.getValue();
      }
      avg = avg / (_index + 2);
      double lastSe = _sequarErrors(lastVal, avg);
      double nextSe = _sequarErrors(nextVal, avg);
      sse = lastSe + nextSe;
      for (int i = 0; i < _index; i++) {
        OrderData e = events[i]!;
        sse += _sequarErrors(e.getValue(), avg);
      }
    }
    return sse;
  }

  @override
  int get hashCode {
    return Object.hash(Object.hashAll(events), _index);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! LTWeightedBucket) {
      return false;
    }
    if (other._index != _index) {
      return false;
    }
    if (events.length != other.events.length) {
      return false;
    }
    for (int i = 0; i < events.length; i++) {
      if (events[i] != other.events[i]) {
        return false;
      }
    }

    return true;
  }

  double _sequarErrors(double d, double avg) {
    double e = d - avg;
    return e * e;
  }
}
