import 'package:cloud_firestore/cloud_firestore.dart';

class WordModel {
  static const String ARABIC = "arabic", ARABIC_DESC = "arabic_desc",
      TURKISH = "turkish", TURKISH_DESC = "turkish_desc",
      LEVEL = "level", CREATED_AT = "created_at",
      LEARNED_USERS = "learned_users", ID = "id",
      QUIZZED_USERS = "quizzed_users", USERS = "users";

  String? id;
  String? arabic;
  String? arabicDesc;
  String? turkish;
  String? turkishDesc;
  String? level;
  Timestamp? createdAt;
  Map<String, int>? learnedUsers;
  Map<String, int>? quizzedUsers;
  List<String>? users;

  WordModel({
    required this.id,
    required this.arabic,
    required this.arabicDesc,
    required this.turkish,
    required this.turkishDesc,
    required this.level,
    required this.learnedUsers,
    required this.quizzedUsers,
    required this.users,
    required this.createdAt,
  });

  WordModel.updateLearnedUsers({
    required this.learnedUsers,
  });

  WordModel.updateQuizzedUsers({
    required this.quizzedUsers,
  });

  WordModel.users({
    required this.users
  });

  WordModel.fromSnapshot(DocumentSnapshot snapshot){
    id = snapshot.id;
    arabic = snapshot.get(ARABIC);
    arabicDesc = snapshot.get(ARABIC_DESC);
    turkish = snapshot.get(TURKISH);
    turkishDesc = snapshot.get(TURKISH_DESC);
    level = snapshot.get(LEVEL);
    learnedUsers = Map.from(snapshot.get(LEARNED_USERS));
    quizzedUsers = Map.from(snapshot.get(QUIZZED_USERS));
    users = List.from(snapshot.get(USERS));
    createdAt = snapshot.get(CREATED_AT);
  }

  Map<String, dynamic> userToJSON(){
    return {
      USERS: FieldValue.arrayUnion(users!)
    };
  }

}
