import 'package:allybike/class/domain.class.dart';

class TypeRoute extends Domain {
 
  TypeRoute({required super.id, required super.description});

  factory TypeRoute.fromJson(Map<String, dynamic> json) =>
      TypeRoute(id: json["id"], description: json["description"]);

  Map<String, dynamic> toJson() => {"id": id, "description": description};
}
  