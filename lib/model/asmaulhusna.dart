class AsmaUlHusna {
  AsmaUlHusna({
    this.names,
  });

  List<Name> names;

  factory AsmaUlHusna.fromJson(Map<String, dynamic> json) => AsmaUlHusna(
        names: List<Name>.from(json["names"].map((x) => Name.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "names": List<dynamic>.from(names.map((x) => x.toJson())),
      };
}

class Name {
  Name({
    this.name,
    this.transliteration,
    this.number,
    this.en,
  });

  String name;
  String transliteration;
  int number;
  En en;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        name: json["name"],
        transliteration: json["transliteration"],
        number: json["number"],
        en: En.fromJson(json["en"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "transliteration": transliteration,
        "number": number,
        "en": en.toJson(),
      };
}

class En {
  En({
    this.meaning,
  });

  String meaning;

  factory En.fromJson(Map<String, dynamic> json) => En(
        meaning: json["meaning"],
      );

  Map<String, dynamic> toJson() => {
        "meaning": meaning,
      };
}
