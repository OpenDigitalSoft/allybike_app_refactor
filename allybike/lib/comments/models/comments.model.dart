import 'package:allybike/participants/models/participant.model.dart';

class Comment {
  String comment;
  DateTime date;
  Participant user;

  Comment({required this.comment, required this.date, required this.user});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    comment: json["comment"],
    date: DateTime.parse(json["date"]),
    user: Participant.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "comment": comment,
    "date": date.toIso8601String(),
    "user": user.toJson(),
  };
}
