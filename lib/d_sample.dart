library;

import 'package:d_sample/src/mm.dart';

import 'src/lt/lta_builder.dart';
import 'src/order_sort.dart';
import 'src/weighted_event.dart';

abstract interface class SamplingData {
  int get samplingOrder;

  double get samplingValue;
}

interface class DownSampling {
  List<SamplingData> process(List<SamplingData> data, int threshold) {
    throw Error();
  }
}

class DSAlgorithms implements DownSampling {
  late final DownSampling _delegate;

  DSAlgorithms.piplot() {
    _delegate = PIPlotAlgorithm();
  }

  DSAlgorithms.lttb() {
    _delegate = LTABuilder().threeBucket().fixed().build();
  }

  DSAlgorithms.ltob() {
    _delegate = LTABuilder().oneBucket().fixed().build();
  }

  DSAlgorithms.ltd() {
    _delegate = LTABuilder().threeBucket().dynamic().build();
  }

  DSAlgorithms.maxmin() {
    _delegate = MMAlgorithm();
  }

  @override
  List<SamplingData> process(List<SamplingData> data, int threshold) {
    return _delegate.process(data, threshold);
  }
}

class MixedAlgorithm implements DownSampling {
  final Map<DownSampling, double> _map = {};

  void add(DownSampling da, double rate) {
    _map[da] = rate;
  }

  @override
  List<SamplingData> process(List<SamplingData> data, int threshold) {
    if (_map.isEmpty) {
      return data;
    }
    Set<SamplingData> set = <SamplingData>{};
    for (DownSampling da in _map.keys) {
      List<SamplingData> subList = da.process(data, (threshold * _map[da]!).toInt());
      set.addAll(subList);
    }
    List<SamplingData> result = [];
    result.addAll(set);
    result.sort(orderAsc);
    return result;
  }
}

class TimeGapAlgorithm implements DownSampling {
  final double _rate = 1;

  @override
  List<SamplingData> process(List<SamplingData> data, int threshold) {
    if (data.isEmpty || threshold >= data.length) {
      return data;
    }
    List<SamplingData> result = [];

    List<WeightEvent> weighted = [];
    double avg = (data.last.samplingOrder - data.first.samplingOrder) * 1.0 / (data.length - 1);
    for (int i = 0; i < data.length; i++) {
      WeightEvent we = WeightEvent(data[i]);
      if (i < data.length - 1) {
        num delta = data[i + 1].samplingOrder - data[i].samplingOrder;
        we.setWeight(delta - avg);
      }
      weighted.add(we);
    }

    Set<SamplingData> set = <SamplingData>{};
    int max = (threshold * _rate).toInt();
    int multiple = 1024;
    int limit = (double.maxFinite - 2).toInt();
    A:
    while (multiple > 2) {
      for (int i = 0; i < weighted.length; i++) {
        WeightEvent e = weighted[i];
        double m = e.getWeight() / avg;
        if (m > multiple && m <= limit) {
          set.add(e.getEvent());
          if (i + 1 < weighted.length) {
            set.add(weighted[i + 1].getEvent());
          }
        }
        if (set.length >= max) {
          break A;
        }
      }
      limit = multiple;
      multiple >>= 2;
    }
    result.addAll(set);
    result.sort(orderAsc);
    return result;
  }
}
