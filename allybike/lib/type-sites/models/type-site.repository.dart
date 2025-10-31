import 'package:allybike/class/domain.class.dart';

class TypeSite extends Domain {
  TypeSite({required super.id, required super.description});

  factory TypeSite.fromJson(Map<String, dynamic> json) =>
      TypeSite(id: json["id"], description: json["description"]);

  Map<String, dynamic> toJson() => {"id": id, "description": description};
}
  