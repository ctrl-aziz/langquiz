import 'package:langquiz/models/user_model.dart';
import 'package:langquiz/models/word_model.dart';
import 'package:langquiz/providers/main_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class Database{
  final _userCollection = FirebaseFirestore.instance.collection("Users");
  final _wordCollection = FirebaseFirestore.instance.collection("Words");

  String? id;

  String? level;

  BuildContext? context;

  Database.id(this.id);

  Database.level(this.level, this.id, this.context);

  Database();

  UserModel _userDataFromSnapshot(DocumentSnapshot snapshot){
    try{
      return UserModel.fromSnapshot(snapshot);
    }catch(e){
      if (kDebugMode) {
        print("_userDataFromSnapshot Error: $e");
      }
      rethrow;
    }
  }

  Stream<UserModel> get userData{
    assert(id != null, "User id must not be null");
    return _userCollection.doc(id).snapshots().map(_userDataFromSnapshot);
  }

  Future setNewUserData() async {
    try{
      bool _userExist = (await _userCollection.doc(id).get()).exists;
      if(_userExist){
        if (kDebugMode) {
          print("User is exist");
        }
        return;
      }else{
        return _userCollection.doc(id).set(
          UserModel.data(successRate: 0).toJson()
        );
      }
    }catch(e){
      if (kDebugMode) {
        print("setNewUserData Error: $e");
      }
      rethrow;
    }
  }

  Future updateUserData(double score) async {
    assert(id != null, "User id must not be null");
    try{
      return await _userCollection.doc(id).update(
          UserModel.data(successRate: score).toJson()
      );
    }catch(e){
      if (kDebugMode) {
        print("updateUserData Error: $e");
      }
      rethrow;
    }
  }


  List<WordModel> _wordsFromSnapshot(QuerySnapshot snapshot){
    try{
      return snapshot.docs.map((doc) {
        return WordModel.fromSnapshot(doc);
      }).toList();
    }catch(e){
      if (kDebugMode) {
        print("WordsFromSnapshot Error: $e");
      }
      rethrow;
    }
  }

  Stream<List<WordModel>> get allWords{
    assert(level != null && id != null, "Level and user id must not be null user Database.level() constructor");
    return _wordCollection
        .where(WordModel.LEVEL, isEqualTo: level)
        .orderBy('${WordModel.QUIZZED_USERS}.users', descending: true)
        .limit(10)
        .snapshots()
        .map(_wordsFromSnapshot);
  }
  Future<List<WordModel>> get allLearningWords async{
    assert(level != null && id != null, "Level and user id must not be null user Database.level() constructor");
    var data = await _wordCollection
        .where(WordModel.LEVEL, isEqualTo: level)
        .orderBy('${WordModel.LEARNED_USERS}.users', descending: false)
        .limit(12)
        .get();
    if(data.docs.isNotEmpty) {
      Provider.of<MainProvider>(context!, listen: false).lastDoc = data.docs.last;
    }
    return _wordsFromSnapshot(data);
  }
  Future<List<WordModel>> get allLearningWordsMore async{
    var _lastDoc = Provider.of<MainProvider>(context!, listen: false).lastDoc;
    assert(level != null && _lastDoc != null, "Level and _lastDoc must not be null user Database.level() constructor");
    var data = await _wordCollection
        .where(WordModel.LEVEL, isEqualTo: level)
        .orderBy('${WordModel.LEARNED_USERS}.users', descending: false)
        .startAfterDocument(_lastDoc!)
        .limit(12)
        .get();
    return _wordsFromSnapshot(data);
  }

  Future<int> get userLearnedWords async {
    assert(id != null, "id must not be null try use Database.id() constructor");
    try{
      int len = (await _wordCollection.where(WordModel.USERS, arrayContains: id).get()).size;
      return len;
    }catch(e){
      if (kDebugMode) {
        print("userWords Error: $e");
      }
      rethrow;
    }
  }

  Future updateWordUsers(String docID) async {
    assert(id != null, "User id must not be null");
    try{
      return await _wordCollection.doc(docID).update(WordModel.users(users: [id!]).userToJSON());
    }catch(e){
      if (kDebugMode) {
        print("updateUserData Error: $e");
      }
      rethrow;
    }
  }

  Future updateLearnedWordsUser(String docID, int learnedCount, int users) async {
    assert(id != null, "User id must not be null");
    try{
      return await _wordCollection.doc(docID).update({
        WordModel.LEARNED_USERS: {
          id!: ++learnedCount,
          'users': ++users
        },
      });
    }catch(e){
      if (kDebugMode) {
        print("updateUserData Error: $e");
      }
      rethrow;
    }
  }

  Future updateQuizzedWordsUser(String docID, int quizzedCount, int users) async {
    assert(id != null, "User id must not be null");
    try{
      return await _wordCollection.doc(docID).update({
        WordModel.QUIZZED_USERS: {
          id!: ++quizzedCount,
          'users': ++users
        },
      });
    }catch(e){
      if (kDebugMode) {
        print("updateUserData Error: $e");
      }
      rethrow;
    }
  }
}