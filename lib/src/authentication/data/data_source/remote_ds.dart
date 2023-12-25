import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:house_rental/src/authentication/data/data_source/local_ds.dart';
import 'package:house_rental/src/authentication/data/models/user_model.dart';
import 'package:house_rental/src/authentication/domain/entities/user.dart';

abstract class AuthenticationRemoteDatasource {
  Future<QueryDocumentSnapshot<UserModel>> signin(Map<String, dynamic> params);
  Future<DocumentReference<UserModel>?> signup(Map<String, dynamic> params);
  Future<auth.User> verifyOTP(auth.PhoneAuthCredential credential);
  Future<void> updateUser(Map<String, dynamic> params);
  Future<QuerySnapshot<UserModel>> addId(Map<String, dynamic> params);
}

class AuthenticationRemoteDatasourceImpl
    implements AuthenticationRemoteDatasource {
  final auth.FirebaseAuth firebaseAuth;
  final AuthenticationLocalDatasource localDatasource;
  AuthenticationRemoteDatasourceImpl(
      {required this.localDatasource, required this.firebaseAuth});
  final usersRef = FirebaseFirestore.instance
      .collection('houseRentalAccount')
      .withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toMap(),
      );
  @override
  Future<QueryDocumentSnapshot<UserModel>> signin(
      Map<String, dynamic> params) async {
    //if (numberSignin == false) {
    final response = await usersRef
        .where("phone_number", isEqualTo: params["phone_number"])
        .get();
    //.snapshots()
    //.first;

    // final data = response.docs.first.data();

    if (response.docs.isNotEmpty) {
      return response.docs.first;
    } else {
      throw Exception("No user found");
    }
  }

  @override
  Future<DocumentReference<UserModel>?> signup(
      Map<String, dynamic> params) async {
    final response = usersRef.add(UserModel.fromJson(params));
    localDatasource.cacheUserData(UserModel.fromJson(params));
    return response;
  }

  @override
  Future<auth.User> verifyOTP(auth.PhoneAuthCredential credential) async {
    final response = await firebaseAuth.signInWithCredential(credential);

    if (kDebugMode) {
      print(response.user?.uid);
    }

    return response.user!;
  }

  @override
  Future<void> updateUser(Map<String, dynamic> params) async {
    await usersRef.doc(params["id"]).update(params);
  }

  @override
  Future<QuerySnapshot<UserModel>> addId(Map<String, dynamic> params) async {
    return await usersRef
        .where("phone_number", isEqualTo: params["phone_number"])
        .get()
        .then((value) {
      var userData = value.docs.first;

      User? data;

      data = userData.data();
      data.id = userData.id;
      debugPrint(data.toMap().toString());
      debugPrint(data.toString());
      localDatasource.cacheUserData(UserModel.fromJson(data.toMap()));

      debugPrint(data.id);
      debugPrint(data.uid);
      debugPrint(data.toMap().toString());

      return value;
    });
  }
}
