import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:JAFFA/components/order_API.dart';
import 'package:JAFFA/components/AppBarwithArrow.dart';
import 'package:JAFFA/constants.dart';
import 'package:flutter/material.dart';

//  Text("Order ID: ${order.id}"),
//               Text("Order Status: ${order.orderStatus}"),
//               Text(
//                   "Total Amount: ${order.paymentIntent.amount} ${order.paymentIntent.currency}"),
//               const SizedBox(height: 10),
//               Text("Products:"),
//               const SizedBox(height: 10),
//               Text("Discount: ${order.discount}"),
//               // Display additional information about each product
class orderHistory extends StatefulWidget {
  const orderHistory({super.key});

  @override
  _orderHistoryState createState() => _orderHistoryState();
}

class _orderHistoryState extends State<orderHistory> {
  List<int> discount = [];
  List<Order> ordersList = [];
  String prodId = '';
  int count = 0;
  String name = '';
  num price = 0.0;

  void _showDetailsDialog(Order order) async {
    // Fetch additional information for each product in the order
    List<Map<String, dynamic>> productInfoList = [];
    for (final product in order.products) {
      final info = await prodInfo(product.id);
      int count = product.count;
      String name = info['name'];
      num price = info['price'];
      productInfoList.add({'name': name, 'count': count, 'price': price});
    }

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            alignment: Alignment.topRight,
            child: const Text("تفاصيل الطلب"),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DataTable(
                  columns: const [
                    DataColumn(label: Text('name')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Count')),
                  ],
                  rows: productInfoList.map((data) {
                    return DataRow(
                      cells: [
                        DataCell(Text(data["name"])),
                        DataCell(Text(data["count"]
                            .toString())), // Use "count" instead of "quantity"
                        DataCell(Text('₪ ${data["price"]}')),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("إغلاق"),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> prodInfo(String productId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/product/$productId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract product data from the response

        final String name = responseData['name'];
        final num price = responseData['price'];

        // Return the product information
        return {'name': name, 'price': price};
      } else {
        // Handle error response
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return {};
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
      return {};
    }
  }

  Future<void> cartData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/cart/get-orders/651bf3ae54c72c4af30c10b5'),
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> responseData =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        // Iterate through each order in the response
        for (final orderData in responseData) {
          final Order order = Order(
            id: orderData['_id'],
            products: List<Product>.from(orderData['products'].map(
              (productData) => Product(
                count: productData['count'],
                id: productData['_id'],
              ),
            )),
            paymentIntent: PaymentIntent(
              id: orderData['paymentIntent']['id'],
              amount: orderData['paymentIntent']['amount'].toDouble(),
              status: orderData['paymentIntent']['status'],
              created: orderData['paymentIntent']['created'],
              currency: orderData['paymentIntent']['currency'],
            ),
            discount: orderData['discount'],
            orderStatus: orderData['orderStatus'],
            orderby: OrderBy(
              role: orderData['orderby']['role'],
              id: orderData['orderby']['_id'],
              email: orderData['orderby']['email'],
              fullName: orderData['orderby']['fullName'],
              // Add other necessary fields
            ),
            createdAt: DateTime.parse(orderData['createdAt']),
            updatedAt: DateTime.parse(orderData['updatedAt']),
          );

          // Add the order to the list
          ordersList.add(order);
        }
      } else {
        // Handle error response
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }

    // Return the list of orders
  }

  @override
  void initState() {
    super.initState();
    cartData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const CustomAppBarwithArrow(nav: 'cart'),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: ordersList.length,
                itemBuilder: (context, index) {
                  Order order = ordersList[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          width: 350,
                          height: 170,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(245, 223, 187, 0.612)
                                .withOpacity(
                                    0.2), // Set your desired background color
                            border: Border(
                              top: BorderSide(
                                color: order.orderStatus == 'Delivered'
                                    ? Colors.grey.withOpacity(0.6)
                                    : Colors.green.withOpacity(0.6),
                                width: 4.0,
                              ),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 3.0,
                                  right: 10.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      order.orderStatus,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Lateef',
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 10,
                                      width: 10,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 90,
                                width: 320,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  top: 3.0,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Add your onPressed logic here
                                    print("Button Pressed");
                                    _showDetailsDialog(order);
                                  },
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    child: const Stack(
                                      children: [
                                        Text(
                                          "عرض تفاصيل الطلب",
                                          style: TextStyle(
                                            fontFamily: 'Lateef',
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Positioned(
                                          top: 11,
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: 0.5,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
