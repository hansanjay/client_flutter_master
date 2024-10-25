import '../models/product_model.dart';

class Subscription {
  final int id;
  final int customerId;
  final int quantity;
  final int distributorId;
  final int productId;
  final int type;
  final int status;
  final int parent_id;
  final bool permanent;
  final String? dayOfWeek;
  final String? dayOfMonth;
  final DateTime start;
  final DateTime? stop;
  final DateTime? pause;
  final DateTime? resume;
  final Product product;

  Subscription({
    required this.id,
    required this.customerId,
    required this.quantity,
    required this.distributorId,
    required this.productId,
    required this.type,
    required this.status,
    required this.parent_id,
    required this.permanent,
    this.dayOfWeek,
    this.dayOfMonth,
    required this.start,
    this.stop,
    this.pause,
    this.resume,
    required this.product,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      customerId: json['customer_id'],
      quantity: json['quantity'],
      distributorId: json['distributor_id'],
      productId: json['product_id'],
      type: json['type'],
      status: json['status'],
      parent_id: json['parent_id'] != null ? json['parent_id'] : 0,
      permanent: json['permanent'],
      dayOfWeek: json['day_of_week'] ?? '',
      dayOfMonth: json['day_of_month'] ?? '',
      start: DateTime.parse(json['start']),
      stop: json['stop'] != null ? DateTime.parse(json['stop']) : null,
      pause: json['pause'] != null ? DateTime.parse(json['pause']) : null,
      resume: json['resume'] != null ? DateTime.parse(json['resume']) : null,
      product: Product.fromJson(json['product']),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'quantity': quantity,
      'distributor_id': distributorId,
      'product_id': productId,
      'type': type,
      'status': status,
      'parent_id' : parent_id,
      'permanent': permanent,
      'day_of_week': dayOfWeek,
      'day_of_month': dayOfMonth,
      'start': start.toIso8601String(),
      'stop': stop?.toIso8601String(),
      'pause': pause?.toIso8601String(),
      'resume': resume?.toIso8601String(),
      'product': product.toJson(),
    };
  }
}