class Rating {
  int id;
  int idRoute;
  int idUser;
  dynamic idAlly;
  dynamic idAccompaniment;
  dynamic idPickup;
  int rating;

  Rating({
    required this.id,
    required this.idRoute,
    required this.idUser,
    required this.idAlly,
    required this.idAccompaniment,
    required this.idPickup,
    required this.rating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    id: json["id"],
    idRoute: json["idRoute"],
    idUser: json["idUser"],
    idAlly: json["idAlly"],
    idAccompaniment: json["idAccompaniment"],
    idPickup: json["idPickup"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idRoute": idRoute,
    "idUser": idUser,
    "idAlly": idAlly,
    "idAccompaniment": idAccompaniment,
    "idPickup": idPickup,
    "rating": rating,
  };
}
