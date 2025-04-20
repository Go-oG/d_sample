
import 'package:d_sample/d_sample.dart';
import 'package:meta/meta.dart';

import '../base_algorithm.dart';
import '../weighted_event.dart';
import 'ltweight_calculator.dart';
import 'ltweighted_bucket.dart';
import 'triangle.dart';

class LTAlgorithm extends BucketBasedAlgorithm<LTWeightedBucket, WeightEvent> {
  @protected
  DSTriangle triangle = DSTriangle();

  late LTWeightCalculator wcalc;

  LTAlgorithm();

  @protected
  @override
  List<WeightEvent> prepare(List<OrderData> data) {
    List<WeightEvent> result = [];
    for (OrderData event in data) {
      result.add(WeightEvent(event));
    }
    return result;
  }

  @protected
  @override
  void beforeSelect(List<LTWeightedBucket> buckets, int threshold) {
    wcalc.calcWeight(triangle, buckets);
  }
}
