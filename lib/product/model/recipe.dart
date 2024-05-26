import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String? image;
  List<String>? ingredients;
  List<String>? steps;
  String? title;
  String? userid;

  Recipe({
    this.image,
    this.ingredients,
    this.steps,
    this.title,
    this.userid,
  });

  Recipe copyWith({
    String? image,
    List<String>? ingredients,
    List<String>? steps,
    String? title,
    String? userid,
  }) {
    return Recipe(
      image: image ?? this.image,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      title: title ?? this.title,
      userid: userid ?? this.userid,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'ingredients': ingredients,
      'steps': steps,
      'title': title,
      'userid': userid,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'ingredients': ingredients,
      'steps': steps,
      'userid': userid,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      image: json['image'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      steps:
          (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList(),
      title: json['title'] as String?,
      userid: json['userid'] as String?,
    );
  }

  factory Recipe.fromDocument(DocumentSnapshot doc) {
    return Recipe(
      image: doc['image'] as String?,
      userid: doc['userid'] as String?,
      ingredients: doc['ingredients'] as List<String>?,
      title: doc['title'] as String?,

      // Diğer alanları da al
      steps: doc['steps'] as List<String>?, // Örnek olarak adımlar
      // Örnek olarak malzemeler
    );
  }

  @override
  String toString() =>
      "Recipe(image: $image,ingredients: $ingredients,steps: $steps,title: $title,userid: $userid)";

  @override
  int get hashCode => Object.hash(image, ingredients, steps, title, userid);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recipe &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          ingredients == other.ingredients &&
          steps == other.steps &&
          title == other.title &&
          userid == other.userid;
}
