import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('User');

class FirebaseCrud {
//CRUD method here
  static Future<Response> addEmployee({
    String name,
    String age,
    String gender,
    String address,
    //  String Mobile,
    String contactno,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "age": age,
      "gender": gender,
      "address": address,
      //  "Mobile" :Mobile,
      "contact_no": contactno
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Your data is successdully stored";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Stream<QuerySnapshot> readEmployee() {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }

  static Future<Response> updateEmployee({
    String name,
    String age,
    String gender,
    String address,
    //  String Mobile,
    String contactno,
    String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "age": age,
      "gender": gender,
      "address": address,
      //  "Mobile" :Mobile,
      "contact_no": contactno
    };

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully updated Employee";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  // delete record
  static Future<Response> deleteEmployee({
    String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully Deleted Employee";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
}
