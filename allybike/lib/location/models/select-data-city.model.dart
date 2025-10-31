class SelectDataCity {
  String description;
  int idLocation;

  SelectDataCity({required this.description, required this.idLocation});

  factory SelectDataCity.fromJson(Map<String, dynamic> json) => SelectDataCity(
    description: json["description"],
    idLocation: json["idLocation"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "idLocation": idLocation,
  };
}
