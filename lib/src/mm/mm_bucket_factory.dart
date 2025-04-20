import 'package:d_sample/d_sample.dart';
import '../bucket.dart';
import 'mm_bucket.dart';

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
  MMBucket newBucketFromEvent(OrderData e) {
    return MMBucket.of(e);
  }
}
