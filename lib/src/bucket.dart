import 'package:d_sample/d_sample.dart';

interface class Bucket {
  void selectInto(List<SamplingData> result) {
    throw Error();
  }

  void add(SamplingData e) {
    throw Error();
  }
}

interface class BucketFactory<B extends Bucket> {
  B newBucket() {
    throw Error();
  }

  B newBucketFromSize(int size) {
    throw Error();
  }

  B newBucketFromEvent(SamplingData e) {
    throw Error();
  }
}
