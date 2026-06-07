class Expense {
  int? id;
  int? productId;
  String? price;
  int? quantity;
  int? userId;
  String? date;

  Expense(
      {this.id,
      this.productId,
      this.price,
      this.quantity,
      this.userId,
      this.date});

  Expense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    price = json['price'];
    quantity = json['quantity'];
    userId = json['user_id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['product_id'] = productId;
    data['price'] = price;
    data['quantity'] = quantity;
    data['user_id'] = userId;
    data['date'] = date;
    return data;
  }
}
