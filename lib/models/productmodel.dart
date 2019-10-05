class ProductModel {
  String product_id,
      product_name,
      product_category,
      product_des,
      product_size,
      product_barcode,
      product_image,
      product_count,
      product_price_buy,
      product_price_sell;

  ProductModel(
      {this.product_id,
      this.product_name,
      this.product_category,
      this.product_des,
      this.product_size,
      this.product_barcode,
      this.product_image,
      this.product_count,
      this.product_price_buy,
      this.product_price_sell});

  factory ProductModel.proJson(Map<String, dynamic> json) {
    return ProductModel(
        product_id: json['product_id'],
        product_name: json['product_name'],
        product_category: json['product_category'],
        product_des: json['product_des'],
        product_size: json['product_size'],
        product_barcode: json['product_barcode'],
        product_image: json['product_image'],
        product_count: json['product_count'],
        product_price_buy: json['product_price_buy'],
        product_price_sell: json['product_price_sell']);
  }
}
