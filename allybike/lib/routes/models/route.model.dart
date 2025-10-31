import 'package:allybike/bike-rides/models/bike-ride.model.dart';
import 'package:allybike/comments/models/comments.model.dart';
import 'package:allybike/location/models/location.model.dart';
import 'package:allybike/participants/models/participant.model.dart';
import 'package:allybike/rattings/models/rattings.model.dart';

class AllyBikeRoute {
  int id;
  DateTime date;
  DateTime? update;
  String name;
  String descriptions;
  String type;
  int distance;
  String difficulty;
  int idUser;
  int idLocation;
  bool public;
  bool active;
  int elevationGain;
  bool hasPoints;
  bool routeAsync;
  List<Image> images;
  List<Comment> comments;
  List<Rating> ratings;
  Location location;
  List<Site> sites;
  Participant? user;
  int numberRatings;
  int ratingTotal;

  AllyBikeRoute({
    required this.id,
    required this.date,
    required this.update,
    required this.name,
    required this.descriptions,
    required this.type,
    required this.distance,
    required this.difficulty,
    required this.idUser,
    required this.idLocation,
    required this.public,
    required this.active,
    required this.elevationGain,
    required this.hasPoints,
    required this.routeAsync,
    required this.images,
    required this.location,
    required this.sites,
    required this.comments,
    required this.ratings,
    required this.user,
    required this.numberRatings,
    required this.ratingTotal,
  });

  factory AllyBikeRoute.fromJson(Map<String, dynamic> json) => AllyBikeRoute(
    id            : json["id"],
    date          : DateTime.parse(json["date"]),
    update        : json["update"] == null ? null : DateTime.parse(json["update"]),
    name          : json["name"],
    descriptions  : json["descriptions"],
    type          : json["type"],
    distance      : json["distance"],
    difficulty     : json["difficulty"],
    idUser        : json["idUser"],
    idLocation    : json["idLocation"],
    public        : json["public"],
    active        : json["active"],
    elevationGain : json["elevationGain"],
    hasPoints     : json["hasPoints"],
    routeAsync    : json["async"],
    numberRatings : json["numberRatings"] ?? 0,
    ratingTotal   : json["ratingTotal"] ?? 0,
    images        : List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    location      : Location.fromJson(json["location"]),
    sites         : List<Site>.from(json["sites"].map((x) => Site.fromJson(x))),
    comments      : json["comments"] == null
                    ? []
                    : List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    ratings       : json["ratings"] == null
                    ? []
                    : List<Rating>.from(json["ratings"].map((x) => Rating.fromJson(x))),
    user          : json["user"] == null ? null : Participant.fromJson(json["user"]),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date.toIso8601String(),
    "update": update?.toIso8601String(),
    "name": name,
    "descriptions": descriptions,
    "type": type,
    "distance": distance,
    "difficulty": difficulty,
    "idUser": idUser,
    "idLocation": idLocation,
    "public": public,
    "active": active,
    "elevationGain": elevationGain,
    "hasPoints": hasPoints,
    "async": routeAsync,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "location": location.toJson(),
    "sites": List<dynamic>.from(sites.map((x) => x.toJson())),
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
    "ratings": List<dynamic>.from(ratings.map((x) => x.toJson())),
  };
}
