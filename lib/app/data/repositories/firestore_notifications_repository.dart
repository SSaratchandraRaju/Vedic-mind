import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationRecord {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool background;

  NotificationRecord({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.background = false,
  });

  factory NotificationRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return NotificationRecord(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      timestamp: (data['timestamp'] is Timestamp)
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      background: data['background'] ?? false,
    );
  }
}

class FirestoreNotificationsRepository {
  final FirebaseFirestore _firestore;
  FirestoreNotificationsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col() =>
      _firestore.collection('notifications');

  Stream<List<NotificationRecord>> watchUser(String userId, {int limit = 100}) {
    return _col()
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((qs) => qs.docs.map(NotificationRecord.fromDoc).toList());
  }

  Future<void> addNotification({
    required String userId,
    required String title,
    required String body,
    bool background = false,
  }) async {
    await _col().add({
      'userId': userId,
      'title': title,
      'body': body,
      'background': background,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNotification(String id) async {
    await _col().doc(id).delete();
  }

  Future<void> clearUserNotifications(String userId) async {
    final batch = _firestore.batch();
    final qs = await _col().where('userId', isEqualTo: userId).get();
    for (var doc in qs.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
