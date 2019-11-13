import 'package:scarlettstayle/models/productmodel.dart';

class OrderModel {
  String orderId;
  String customerId;
  List<ProductModel> productList;
  String orderDate;
  String orderState;
  String transId;
  String paymentId;

  OrderModel(
      {this.orderId,
      this.customerId,
      this.productList,
      this.orderDate,
      this.orderState,
      this.transId,
      this.paymentId});

  factory OrderModel.orderJson(Map<String, dynamic> json) {
    return OrderModel(
        orderId: json['orderId'],
        customerId: json['customerId'],
        productList: (json['productList'] as List)
            .map((g) => ProductModel.proJson(g))
            .toList(),
        orderDate: json['orderDate'],
        orderState: json['orderState'],
        transId: json['transId'],
        paymentId: json['paymentId']);
  }
}
