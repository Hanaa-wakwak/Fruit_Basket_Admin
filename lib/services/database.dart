import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_admin/helpers/project_configuration.dart';

abstract class Database {
  Stream<QuerySnapshot> getDataFromCollection(String path, [int length]);
  Stream<QuerySnapshot> getDataFromCollectionByUserID(String path, [int length]);
  Future<QuerySnapshot> getFutureCollection(String col);
  Future<QuerySnapshot>getFromCollectionGroupWithValueConditionByUserID( String collectionName,
      int length,
      String valueName,
      String value,
      String orderBy);

  Future<DocumentSnapshot> getFutureDataFromDocument(String path);

  Stream<QuerySnapshot> getFromCollectionGroupWithValueCondition(
      String collectionName,
      int length,
      String valueName,
      String value,
      String orderBy);

  Stream<DocumentSnapshot> getDataFromDocument(String path);

  Future<void> setData(Map<String, dynamic> data, String path);

  Future<void> removeData(String path);

  Future<void> removeCollection(String path);

  Future<void> updateData(Map<String, dynamic> data, String path);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final _service = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getFutureDataFromDocument(String path) {
    return _service.doc(path).get();
  }

  Future<QuerySnapshot> getFutureCollection(String col) {
    return _service.collection(col).get();
  }

  Stream<QuerySnapshot> getFromCollectionGroupWithValueCondition(
      String collectionName,
      int length,
      String valueName,
      String value,
      String orderBy) {
    return _service
        .collectionGroup(collectionName)
        .where(valueName, isEqualTo: value)
        .orderBy(orderBy, descending: value == "Processing" ? false : true)
        .limit(length)
        .snapshots();
  }

  Stream<QuerySnapshot> getDataFromCollectionByUserID(String path, [int length]) {
    Stream<QuerySnapshot> snapshots;
    if (length == null) {
      snapshots = _service.collection(path).where(
          ProjectConfiguration.USER_ID_FIELD_NAME,
          isEqualTo: FirebaseAuth?.instance?.currentUser?.uid ?? ""
      ).snapshots();
    } else {
      snapshots = _service.collection(path).where(
          ProjectConfiguration.USER_ID_FIELD_NAME,
          isEqualTo: FirebaseAuth?.instance?.currentUser?.uid ?? ""
      ).limit(length).snapshots();
    }
    return snapshots;
  }
  @override
  // ignore: missing_return
  Future<QuerySnapshot> getFromCollectionGroupWithValueConditionByUserID(
      String collectionName, int length, String valueName, String value, String orderBy)
  {
    Stream<QuerySnapshot> snapshots;
    if (length == null) {
      snapshots = _service.collection(collectionName).where(
          ProjectConfiguration.USER_ID_FIELD_NAME,
          isEqualTo: FirebaseAuth?.instance?.currentUser?.uid ?? ""
      ).snapshots();
    } else {
      snapshots = _service.collection(collectionName).where(
          ProjectConfiguration.USER_ID_FIELD_NAME,
          isEqualTo: FirebaseAuth?.instance?.currentUser?.uid ?? ""
      ).limit(length).snapshots();
    }
  }

  Stream<QuerySnapshot> getDataFromCollection(String path, [int length]) {
    Stream<QuerySnapshot> snapshots;
    if (length == null) {
      snapshots = _service.collection(path).snapshots();
    } else {
      snapshots = _service.collection(path).limit(length).snapshots();
    }
    return snapshots;
  }

  Stream<DocumentSnapshot> getDataFromDocument(String path) {
    final snapshots = _service.doc(path).snapshots();

    return snapshots;
  }

  Future<void> setData(Map<String, dynamic> data, String path) async {
    final snapshots = _service.doc(path);
    await snapshots.set(data);
  }

  Future<void> updateData(Map<String, dynamic> data, String path) async {
    final snapshots = _service.doc(path);
    await snapshots.update(data);
  }

  Future<void> removeData(String path) async {
    final snapshots = _service.doc(path);
    await snapshots.delete();
  }

  Future<void> removeCollection(String path) async {
    await _service.collection(path).get().then((snapshot) async {
      await Future.forEach(snapshot.docs, (doc) async {
        await doc.reference.delete();
      });
    });
  }


}
