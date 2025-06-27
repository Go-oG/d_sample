import '../weighted_event.dart';

class DSTriangle {
  WeightEvent? last;
  WeightEvent? curr;
  WeightEvent? next;

  void _updateWeight() {
    var last = this.last;
    var curr = this.curr;
    var next = this.next;

    if (last == null || curr == null || next == null) {
      return;
    }
    num dx1 = curr.samplingOrder - last.samplingOrder;
    num dx2 = last.samplingOrder - next.samplingOrder;
    num dx3 = next.samplingOrder - curr.samplingOrder;
    double y1 = next.samplingValue;
    double y2 = curr.samplingValue;
    double y3 = last.samplingValue;
    double s = 0.5 * (y1 * dx1 + y2 * dx2 + y3 * dx3).abs();
    curr.setWeight(s);
  }

  void calc(WeightEvent? e) {
    last = curr;
    curr = next;
    next = e;
    _updateWeight();
  }

  void calc2(WeightEvent? last, WeightEvent? curr, WeightEvent? next) {
    this.last = last;
    this.curr = curr;
    this.next = next;
    _updateWeight();
  }
}
