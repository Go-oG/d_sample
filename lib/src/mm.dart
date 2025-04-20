import 'package:d_sample/d_sample.dart';
import 'package:meta/meta.dart';

import 'base_algorithm.dart';
import 'bucket.dart';
import 'bucket_splitter.dart';

class MMAlgorithm extends BucketBasedAlgorithm<MMBucket, SamplingData> {
  MMAlgorithm() {
    setBucketFactory(MMBucketFactory());
    setSplitter(FixedTimeBucketSplitter<MMBucket, SamplingData>());
  }

  @protected
  @override
  List<SamplingData> prepare(List<SamplingData> data) {
    return data;
  }

  @protected
  @override
  void beforeSelect(List<MMBucket> buckets, int threshold) {}
}

class MMBucket implements Bucket {
  @protected
  List<SamplingData> events = [];

  MMBucket();

  MMBucket.of(SamplingData e) {
    events.add(e);
  }

  @override
  void selectInto(List<SamplingData> result) {
    if (events.length <= 1) {
      result.addAll(events);
      return;
    }
    SamplingData? maxEvt;
    SamplingData? minEvt;
    double max = double.minPositive;
    double min = double.maxFinite;
    for (SamplingData e in events) {
      double val = e.samplingValue;
      if (val > max) {
        maxEvt = e;
        max = e.samplingValue;
      }
      if (val < min) {
        minEvt = e;
        min = e.samplingValue;
      }
    }
    if (maxEvt != null && minEvt != null) {
      bool maxFirst = maxEvt.samplingOrder < minEvt.samplingOrder;
      if (maxFirst) {
        result.add(maxEvt);
        result.add(minEvt);
      } else {
        result.add(minEvt);
        result.add(maxEvt);
      }
    } else if (maxEvt == null && minEvt != null) {
      result.add(minEvt);
    } else if (maxEvt != null && minEvt == null) {
      result.add(maxEvt);
    }
  }

  @override
  void add(SamplingData e) {
    events.add(e);
  }
}

class MMBucketFactory implements BucketFactory<MMBucket> {
  @override
  MMBucket newBucket() {
    return MMBucket();
  }

  @override
  MMBucket newBucketFromSize(int size) {
    return MMBucket();
  }

  @override
  MMBucket newBucketFromEvent(SamplingData e) {
    return MMBucket.of(e);
  }
}

class PIPlotAlgorithm extends BucketBasedAlgorithm<PIPlotBucket, SamplingData> {
  PIPlotAlgorithm() {
    setBucketFactory(PIPlotBucketFactory());
    setSplitter(FixedTimeBucketSplitter<PIPlotBucket, SamplingData>());
  }

  @protected
  @override
  List<SamplingData> prepare(List<SamplingData> data) {
    return data;
  }

  @protected
  @override
  void beforeSelect(List<PIPlotBucket> buckets, int threshold) {}
}

class PIPlotBucket extends MMBucket {
  PIPlotBucket();

  PIPlotBucket.fromSize(int size) : super();

  PIPlotBucket.of(super.e) : super.of();

  @override
  void selectInto(List<SamplingData> result) {
    List<SamplingData> temp = [];
    super.selectInto(temp);
    Set<SamplingData> set = <SamplingData>{};
    if (temp.isNotEmpty) {
      set.add(events[0]);
      set.addAll(temp);
      set.add(events.last);
    }
    result.addAll(set);
  }
}

class PIPlotBucketFactory implements BucketFactory<PIPlotBucket> {
  @override
  PIPlotBucket newBucket() {
    return PIPlotBucket();
  }

  @override
  PIPlotBucket newBucketFromSize(int size) {
    return PIPlotBucket();
  }

  @override
  PIPlotBucket newBucketFromEvent(SamplingData e) {
    return PIPlotBucket.of(e);
  }
}
