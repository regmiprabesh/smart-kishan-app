class SoilData {
  Coordinates? coord;
  String? parentsoil;
  double? ph;
  String? clay;
  double? organicMatter;
  double? totalNitrogen;
  String? boron;
  double? p2o5;
  String? sand;

  SoilData(
      {this.coord,
      this.parentsoil,
      this.ph,
      this.clay,
      this.organicMatter,
      this.totalNitrogen,
      this.boron,
      this.p2o5,
      this.sand});

  SoilData.fromJson(Map<String, dynamic> json) {
    coord = json['coord'] != null ? Coordinates.fromJson(json['coord']) : null;
    parentsoil = json['parentsoil'];
    ph = json['ph'];
    clay = json['clay'];
    organicMatter = extractNumbers(json['organicMatter']);
    totalNitrogen = extractNumbers(json['totalNitrogen']);
    boron = json['boron'];
    p2o5 = extractNumbers(json['p2o5']);
    sand = json['sand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (coord != null) {
      data['coord'] = coord!.toJson();
    }
    data['parentsoil'] = parentsoil;
    data['ph'] = ph;
    data['clay'] = clay;
    data['organicMatter'] = organicMatter;
    data['totalNitrogen'] = totalNitrogen;
    data['boron'] = boron;
    data['p2o5'] = p2o5;
    data['sand'] = sand;
    return data;
  }

  double? extractNumbers(String? input) {
    if (input != null) {
      final regExp = RegExp(r'[0-9.]+');
      final matches = regExp.allMatches(input);

      if (matches.isEmpty) {
        return null;
      }

      return double.tryParse(matches.map((match) => match.group(0)).join());
    }
    return null;
  }
}

class Coordinates {
  double? lat;
  double? lng;

  Coordinates({this.lat, this.lng});

  Coordinates.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
