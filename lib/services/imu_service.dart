import 'package:sensors_plus/sensors_plus.dart';

class ImuService {
  Stream<AccelerometerEvent> get accelStream => accelerometerEventStream();
  Stream<GyroscopeEvent> get gyroStream => gyroscopeEventStream();
}
