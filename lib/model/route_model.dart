// ignore_for_file: unnecessary_new, prefer_collection_literals

class RouteModel {
  late String startingPoint;
  late String endingPoint;
  late List<String> intermediatePoint;

  RouteModel(this.startingPoint, this.endingPoint, this.intermediatePoint);

  RouteModel.fromJson(Map<String, dynamic> json) {
    startingPoint = json['StartingPoint'];
    endingPoint = json['EndingPoint'];
    intermediatePoint = json['IntermediatePoint'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StartingPoint'] = startingPoint;
    data['EndingPoint'] = endingPoint;
    data['IntermediatePoint'] = intermediatePoint;
    return data;
  }
}
