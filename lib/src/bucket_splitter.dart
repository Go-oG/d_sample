import 'package:d_sample/d_sample.dart';

import 'bucket.dart';

interface class BucketSplitter<B extends Bucket, E extends SamplingData> {
  List<B> split(BucketFactory<B> factory, List<E> data, int threshold) {
    throw Error();
  }
}

class FixedNumBucketSplitter<B extends Bucket, E extends SamplingData>
    implements BucketSplitter<B, E> {
  @override
  List<B> split(BucketFactory<B> factory, List<E> data, int threshold) {
    int bucketNum = threshold - 2;
    int netSize = data.length - 2;
    int bucketSize = (netSize + bucketNum - 1) ~/ bucketNum;

    List<B?> buckets = [];
    for (int i = 0; i < threshold; i++) {
      buckets.add(null);
    }

    buckets[0] = factory.newBucketFromEvent(data[0]);
    buckets[threshold - 1] = factory.newBucketFromEvent(data[data.length - 1]);
    for (int i = 0; i < bucketNum; i++) {
      buckets[i + 1] = factory.newBucketFromSize(bucketSize);
    }
    double step = netSize * 1.0 / bucketNum;
    double curr = step;
    int bucketIndex = 1;
    for (int i = 1; i <= netSize; i++) {
      buckets[bucketIndex]!.add(data[i]);
      if (i > curr) {
        bucketIndex++;
        curr += step;
      }
    }

    List<B> resultList = [];
    for (var item in buckets) {
      if (item != null) {
        resultList.add(item);
      }
    }

    return resultList;
  }
}

class FixedTimeBucketSplitter<B extends Bucket, E extends SamplingData>
    implements BucketSplitter<B, E> {
  List<B> split2(BucketFactory<B> factory, List<E> data, int threshold) {
    List<B> buckets = [];
    num start = data[0].samplingOrder;
    num end = data[data.length - 1].samplingOrder;
    num span = end - start;
    double pice = span / threshold;
    double time = start.toDouble();
    int index = -1;
    for (int i = 0; i < data.length; i++) {
      SamplingData e = data[i];
      if (e.samplingOrder >= time) {
        time += pice;
        index++;
        buckets.add(factory.newBucket());
      }
      buckets[index].add(e);
    }
    return buckets;
  }

  @override
  List<B> split(BucketFactory<B> factory, List<E> data, int threshold) {
    List<B> buckets = [];
    for (int i = 0; i < threshold; i++) {
      buckets.add(factory.newBucket());
    }
    num start = data[0].samplingOrder;
    num end = data[data.length - 1].samplingOrder;
    num span = end - start;
    for (SamplingData e in data) {
      int bindex = (e.samplingOrder - start) * threshold ~/ span;
      bindex = bindex >= threshold ? threshold - 1 : bindex;
      buckets[bindex].add(e);
    }
    return buckets;
  }
}
