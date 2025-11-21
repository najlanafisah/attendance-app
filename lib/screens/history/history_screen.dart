import 'package:attendence_app/models/attendance_records.dart';
import 'package:attendence_app/screens/history/widgets/record_card.dart';
import 'package:attendence_app/services/auth_services.dart';
import 'package:attendence_app/services/firestore_service.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final AuthServices _authServices = AuthServices();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = _authServices.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Attendance History')),
        body: Center(child: Text('Please login to view history'),),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Attendance History')),
      body: StreamBuilder<List<AttendanceRecords>>(
        stream: _firestoreService.getAttendanceRecords(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {  // kalo masih nunggu jawaban dari firebase
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final record = snapshot.data ?? [];

          if (record.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: record.length,
            itemBuilder: (context, index) => RecordCard(record: record[index]),
          );
        },
      )
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No attendance records yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600]
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Check in to start tracking your attendance',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500]
            ),
          )
        ],
      ),
    );
  }
}