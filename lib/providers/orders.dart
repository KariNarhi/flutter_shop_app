import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String domain =
    "flutter-dart-course-200d4-default-rtdb.europe-west1.firebasedatabase.app";

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(domain, "/orders.json");
    final timestamp = DateTime.now();
    final res = await http.post(url,
        body: json.encode({
          "amount": total,
          "dateTime": timestamp.toIso8601String(),
          "products": cartProducts
              .map((cartItem) => {
                    "id": cartItem.id,
                    "title": cartItem.title,
                    "quantity": cartItem.quantity,
                    "price": cartItem.price,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(res.body)["name"],
          amount: total,
          dateTime: timestamp,
          products: cartProducts,
        ));
    notifyListeners();
  }
}
