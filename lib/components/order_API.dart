class Order {
  final String id;
  final List<Product> products;
  final PaymentIntent paymentIntent;
  final int discount;
  final String orderStatus;
  final OrderBy orderby;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.products,
    required this.paymentIntent,
    required this.discount,
    required this.orderStatus,
    required this.orderby,
    required this.createdAt,
    required this.updatedAt,
  });
}

class Product {
  final int count;
  final String id;

  Product({
    required this.count,
    required this.id,
  });
}

class PaymentIntent {
  final String id;
  final double amount;
  final String status;
  final int created;
  final String currency;

  PaymentIntent({
    required this.id,
    required this.amount,
    required this.status,
    required this.created,
    required this.currency,
  });
}

class OrderBy {
  final String role;
  final String id;
  final String email;
  final String fullName;
  // Add other necessary fields

  OrderBy({
    required this.role,
    required this.id,
    required this.email,
    required this.fullName,
    // Add other necessary fields
  });
}
