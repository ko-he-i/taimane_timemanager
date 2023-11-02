import 'package:cloud_firestore/cloud_firestore.dart';

class Timer {
  final String id;
  final String timerName;
  final String total;

  Timer({
    required this.id,
    required this.timerName,
    required this.total,
  });

  factory Timer.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Timer(
      id: doc.id,
      timerName: data['timerName'],
      total: data['total'],
    );
  }
}
