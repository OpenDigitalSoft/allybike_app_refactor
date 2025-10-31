import 'package:allybike/comments/models/comments.model.dart';
import 'package:allybike/participants/models/participant.model.dart';
import 'package:allybike/routes/models/route.model.dart';

class BikeRide {
  int id;
  String description;
  String title;
  String meetingPoint;
  DateTime date;
  String time;
  int idRoute;
  int idUser;
  List<Comment> comments;
  AllyBikeRoute route;
  List<Participant> participants;

  BikeRide({
    required this.id,
    required this.description,
    required this.title,
    required this.meetingPoint,
    required this.date,
    required this.time,
    required this.idRoute,
    required this.idUser,
    required this.comments,
    required this.route,
    required this.participants,
  });

  factory BikeRide.fromJson(Map<String, dynamic> json) => BikeRide(
    id: json["id"],
    description: json["description"],
    title: json["title"],
    meetingPoint: json["meetingPoint"] ?? "",
    date: DateTime.parse(json["date"]),
    time: json["time"],
    idRoute: json["idRoute"],
    idUser: json["idUser"],
    comments: List<Comment>.from(
      json["comments"].map((x) => Comment.fromJson(x)),
    ),
    route: AllyBikeRoute.fromJson(json["route"]),
    participants: List<Participant>.from(
      json["participants"].map((x) => Participant.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "title": title,
    "meetingPoint": meetingPoint,
    "date": date.toIso8601String(),
    "time": time,
    "idRoute": idRoute,
    "idUser": idUser,
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
    "route": route.toJson(),
    "participants": List<dynamic>.from(participants.map((x) => x.toJson())),
  };
}




class Image {
  int id;
  String name;
  String url;

  Image({required this.id, required this.name, required this.url});

  factory Image.fromJson(Map<String, dynamic> json) =>
      Image(id: json["id"], name: json["name"], url: json["url"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "url": url};
}



class Site {
  int id;
  String description;
  int idRoute;
  String latitude;
  String longitude;
  int idType;
  List<Image> images;
  Type type;

  Site({
    required this.id,
    required this.description,
    required this.idRoute,
    required this.latitude,
    required this.longitude,
    required this.idType,
    required this.images,
    required this.type,
  });

  factory Site.fromJson(Map<String, dynamic> json) => Site(
    id: json["id"],
    description: json["description"],
    idRoute: json["idRoute"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    idType: json["idType"],
    images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    type: Type.fromJson(json["type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "idRoute": idRoute,
    "latitude": latitude,
    "longitude": longitude,
    "idType": idType,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "type": type.toJson(),
  };
}

class Type {
  int id;
  String description;

  Type({required this.id, required this.description});

  factory Type.fromJson(Map<String, dynamic> json) =>
      Type(id: json["id"], description: json["description"]);

  Map<String, dynamic> toJson() => {"id": id, "description": description};
}
