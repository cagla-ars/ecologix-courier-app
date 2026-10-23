class Shipment {
  final int id;
  final String barcode;
  final String trackingNumber;
  final String senderName;
  final String receiverName;
  final String deliveryAddress;
  final String status;
  final double? lat;
  final double? lon;
  final double? weight;
  final String? cargoType;
  final int? deliveryIndex;

  Shipment({
    required this.id,
    required this.barcode,
    required this.trackingNumber,
    required this.senderName,
    required this.receiverName,
    required this.deliveryAddress,
    required this.status,
    this.lat,
    this.lon,
    this.weight,
    this.cargoType,
    this.deliveryIndex,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      id: json['id'] ?? 0,
      barcode: json['barcode'] ?? '',
      trackingNumber: json['trackingNumber'] ?? '',
      senderName: json['senderName'] ?? '',
      receiverName: json['receiverName'] ?? '',
      deliveryAddress: json['deliveryAddress'] ?? '',
      status: json['status'] ?? '',
      lat: json['lat'] == null ? null : (json['lat'] as num).toDouble(),
      lon: json['lon'] == null ? null : (json['lon'] as num).toDouble(),
      weight: json['weight'] == null ? null : (json['weight'] as num).toDouble(),
      cargoType: json['cargoType'],
      deliveryIndex: json['deliveryIndex'],
    );
  }
}
