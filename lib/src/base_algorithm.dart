import 'dart:core';

import 'package:d_sample/d_sample.dart';
import 'package:meta/meta.dart';

import 'bucket.dart';
import 'bucket_splitter.dart';

abstract class BucketBasedAlgorithm<B extends Bucket, E extends SamplingData>
    implements DownSampling {
  @protected
  late BucketSplitter<B, E> splitter;
  @protected
  late BucketFactory<B> factory;

  @protected
  List<E> prepare(List<SamplingData> data);

  @protected
  void beforeSelect(List<B> buckets, int threshold);

  @override
  List<SamplingData> process(List<SamplingData> events, int threshold) {
    int dataSize = events.length;
    if (threshold >= dataSize || dataSize < 3) {
      return events;
    }

    List<E> preparedData = prepare(events);

    List<B> buckets = splitter.split(factory, preparedData, threshold);

    // calculating weight or something else
    beforeSelect(buckets, threshold);
    List<SamplingData> result = [];
    // select from every bucket
    for (Bucket bucket in buckets) {
      bucket.selectInto(result);
    }
    return result;
  }

  void setSplitter(BucketSplitter<B, E> spliter) {
    this.splitter = spliter;
  }

  void setBucketFactory(BucketFactory<B> factory) {
    this.factory = factory;
  }
}
