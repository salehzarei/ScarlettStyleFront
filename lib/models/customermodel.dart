class CustomerModel {
  String customerId;
  String customerName;
  String customerAddress;
  String customerPhone;
  String customerState;
  String customerRank;

  CustomerModel(
      {this.customerId,
      this.customerName,
      this.customerAddress,
      this.customerPhone,
      this.customerState,
      this.customerRank});

  factory CustomerModel.customerJson(Map<String, dynamic> json) {
    return CustomerModel(
        customerId: json['customer_id'],
        customerName: json['customer_name'],
        customerAddress: json['customer_address'],
        customerPhone: json['customer_phone'],
        customerState: json['customer_state'],
        customerRank: json['customer_rank']);
  }
}
