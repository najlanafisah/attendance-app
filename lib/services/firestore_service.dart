import 'package:attendence_app/models/attendance_records.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // get attamdance records for a user (realtime stream)
  Stream<List<AttendanceRecords>> getAttendanceRecords(String userId) {
    return 'hello wia';
  }
}