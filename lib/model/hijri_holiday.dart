class HijriHoliday {
  HijriHoliday({
    this.results,
  });

  List<Result> results;

  factory HijriHoliday.fromJson(Map<String, dynamic> json) => HijriHoliday(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.url,
    this.holidayName,
    this.description,
    this.day,
    this.month,
    this.hijriDay,
    this.hijriMonth,
    this.culturalOrigin,
    this.alias,
    this.countryOrigin,
    this.holidayDates,
  });

  String url;
  String holidayName;
  String description;
  dynamic day;
  dynamic month;
  int hijriDay;
  int hijriMonth;
  CulturalOrigin culturalOrigin;
  List<CulturalOrigin> alias;
  List<CulturalOrigin> countryOrigin;
  List<String> holidayDates;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        url: json["url"],
        holidayName: json["holiday_name"],
        description: json["description"],
        day: json["day"],
        month: json["month"],
        hijriDay: json["hijri_day"],
        hijriMonth: json["hijri_month"],
        culturalOrigin: CulturalOrigin.fromJson(json["cultural_origin"]),
        alias: List<CulturalOrigin>.from(
            json["alias"].map((x) => CulturalOrigin.fromJson(x))),
        countryOrigin: List<CulturalOrigin>.from(
            json["country_origin"].map((x) => CulturalOrigin.fromJson(x))),
        holidayDates: List<String>.from(json["holiday_dates"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "holiday_name": holidayName,
        "description": description,
        "day": day,
        "month": month,
        "hijri_day": hijriDay,
        "hijri_month": hijriMonth,
        "cultural_origin": culturalOrigin.toJson(),
        "alias": List<dynamic>.from(alias.map((x) => x.toJson())),
        "country_origin":
            List<dynamic>.from(countryOrigin.map((x) => x.toJson())),
        "holiday_dates": List<dynamic>.from(holidayDates.map((x) => x)),
      };

  int get comparator => (this.hijriMonth + 30) + hijriDay;
}

class CulturalOrigin {
  CulturalOrigin({
    this.name,
  });

  String name;

  factory CulturalOrigin.fromJson(Map<String, dynamic> json) => CulturalOrigin(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
