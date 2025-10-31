class Location {
  String city;
  String departement;
  String country;
  int codeCity;
  int codeDeparment;
  int codeCountry;

  Location({
    required this.city,
    required this.departement,
    required this.country,
    required this.codeCity,
    required this.codeDeparment,
    required this.codeCountry,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    city: json["city"],
    departement: json["departement"],
    country: json["country"],
    codeCity: json["codeCity"],
    codeDeparment: json["codeDeparment"],
    codeCountry: json["codeCountry"],
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "departement": departement,
    "country": country,
    "codeCity": codeCity,
    "codeDeparment": codeDeparment,
    "codeCountry": codeCountry,
  };
}
