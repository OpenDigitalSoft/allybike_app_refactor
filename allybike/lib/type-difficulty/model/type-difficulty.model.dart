import 'package:allybike/class/domain.class.dart';

class TypeDifficulty extends Domain {
  
  TypeDifficulty({required super.id, required super.description});

  factory TypeDifficulty.fromJson(Map<String, dynamic> json) =>
      TypeDifficulty(id: json["id"], description: json["description"]);

  Map<String, dynamic> toJson() => {"id": id, "description": description};
}
