import '../weighted_event.dart';
import 'ltweighted_bucket.dart';
import 'triangle.dart';

interface class LTWeightCalculator {
  void calcWeight(DSTriangle triangle, List<LTWeightedBucket> buckets) {
    throw Error();
  }
}

class LTThreeBucketWeightCalculator implements LTWeightCalculator {
  @override
  void calcWeight(DSTriangle triangle, List<LTWeightedBucket> buckets) {
    for (int i = 1; i < buckets.length - 1; i++) {
      LTWeightedBucket bucket = buckets[i];
      WeightEvent last = buckets[i - 1].select()[0];
      WeightEvent next = buckets[i + 1].average();
      for (int j = 0; j < bucket.size(); j++) {
        WeightEvent? curr = bucket.get(j);
        triangle.calc2(last, curr, next);
      }
    }
  }
}

class LTOneBucketWeightCalculator implements LTWeightCalculator {
  @override
  void calcWeight(DSTriangle triangle, List<LTWeightedBucket> buckets) {
    for (LTWeightedBucket bucket in buckets) {
      for (WeightEvent? event in bucket.events) {
        triangle.calc(event);
      }
    }
  }
}
