class Participant {
  int id;
  String name;
  dynamic image;

  Participant({required this.id, required this.name, required this.image});

  factory Participant.fromJson(Map<String, dynamic> json) =>
      Participant(id: json["id"], name: json["name"], image: json["image"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "image": image};
}
