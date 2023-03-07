import 'package:appointnet/models/link_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LinksRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection("links");



  Future<LinkDetails?> getByInvitationCode(String code) async {
    LinkDetails? link;
    DocumentSnapshot snapshot =
      await collection.doc(code).get();
      if (snapshot.data() == null) return null;
      link =LinkDetails.fromJson(snapshot.data() as Map<String, dynamic>);
      return link;
  }


  Future<bool> createLink(LinkDetails linkDetails) async {
    return update(linkDetails);
  }

  Future<bool> deleteLink({required String code}) async {
    return collection.doc(code).delete().then((value) {
      return true;
    }).catchError((error) {
      return false;
    });
  }

  Future<bool> update(LinkDetails link) async {
    bool success = true;
    await collection.doc(link.code).set(link.toJson())
        .onError((error, stackTrace) => success = false );
    return success;
  }
}