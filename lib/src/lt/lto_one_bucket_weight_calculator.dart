import '../weighted_event.dart';
import 'ltweight_calculator.dart';
import 'ltweighted_bucket.dart';
import 'triangle.dart';

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
