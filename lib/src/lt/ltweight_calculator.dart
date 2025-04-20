import 'ltweighted_bucket.dart';
import 'triangle.dart';

interface class LTWeightCalculator {
  void calcWeight(DSTriangle triangle, List<LTWeightedBucket> buckets) {
    throw Error();
  }
}
