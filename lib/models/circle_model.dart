class CircleModel {
  String id;
  String deviceId;
  String name;
  String number;

  CircleModel({this.id, this.deviceId, this.name, this.number});

  factory CircleModel.fromJson(Map<String, dynamic> json) {
    return CircleModel(
      id: json['id'],
      deviceId: json['device_id'],
      name: json['contact_name'],
      number: json['contact_number'],
    );
  }
}
