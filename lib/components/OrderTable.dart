import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:JAFFA/constants.dart';
import 'package:flutter/material.dart';

class OrderTable extends StatefulWidget {
  const OrderTable({Key? key}) : super(key: key);

  @override
  State<OrderTable> createState() => _OrderTableState();
}

class _OrderTableState extends State<OrderTable> {
  List<Map<String, dynamic>> rowData = [
    // Add more data as needed
  ];
  bool _isLoading = true;
  double totalPrice = 0.0;
  double afterDiscount = 0.0;
  int discount = 0;
  String name = '';
  double deliveredCost = 10.0;

  Future<void> cartData() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/user/cart/651bf3ae54c72c4af30c10b5'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Extract product data from the response

      for (var product in responseData['products']) {
        String name = product['product']['name'];
        num count = product['count'];
        num price = product['price'];

        // Store the data in the rowData list
        rowData.add({'name': name, 'count': count, 'price': price});
      }

      // Print or use rowData as needed
      print(rowData);
      setState(() {
        _isLoading = false;
      });
      total();
    } else {
      // Handle error response
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  Future<void> getCouponByName(String name) async {
    final String apiUrl =
        '$baseUrl/api/coupon/$name'; // Replace with your actual API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          discount = responseData['discount'];
          afterDiscount = totalPrice * ((100 - discount) / 100);
        });
        print(discount);
      } else {
        // Handle error response
        print('Failed to fetch coupon. Status code: ${response.statusCode}');
        print('error' 'Failed to fetch coupon');
      }
    } catch (error) {
      print('Error: $error');
      print('error' 'Internal Server Error');
    }
  }

  Future<void> createOrder() async {
    final String apiUrl =
        '$baseUrl/api/user/cart/cash-order/651bf3ae54c72c4af30c10b5/$discount'; // Replace with your actual API endpoint

    try {
      final response = await http.post(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData['order']['total']);
      } else {
        // Handle error response
        print('Failed to fetch coupon. Status code: ${response.statusCode}');
        print('error' 'Failed to create order');
      }
    } catch (error) {
      print('Error: $error');
      print('error' 'Internal Server Error');
    }
  }

  void total() {
    for (var item in rowData) {
      int count = item['count'];
      num price = item['price'];
      setState(() {
        totalPrice += count * price;
      });

      //Use the values as needed
      print(' Quantity: $count, Price: $price');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartData();
  }

  List<DataRow> buildDataRows() {
    return rowData.map((data) {
      return DataRow(
        cells: [
          DataCell(Text(data["name"])),
          DataCell(Text(
              data["count"].toString())), // Use "count" instead of "quantity"
          DataCell(Text('₪ ${data["price"]}')),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : DataTable(
                  columns: const [
                    DataColumn(
                      label: Text('الاسـم'),
                    ),
                    DataColumn(
                      label: Text('الكـمية'),
                    ),
                    DataColumn(
                      label: Text('الـسعر'),
                    ),
                  ],
                  rows: buildDataRows(),
                ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align text to the right
              children: [
                Row(
                  children: [
                    if (discount != 0)
                      Text(
                        '₪ ${afterDiscount.toStringAsFixed(2)}    ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: "Lateef",
                          color: Colors.grey,
                        ),
                      ),
                    Stack(
                      children: [
                        Text(
                          '₪ ${totalPrice.toStringAsFixed(2)}    ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "Lateef",
                            color: Colors.grey,
                          ),
                        ),
                        if (discount != 0)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              child: const Divider(
                                thickness: 1,
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const Text(
                  'الاجمالي',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Lateef",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align text to the right
              children: [
                Text(
                  '₪ $deliveredCost    ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "Lateef",
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  'تكلفة الشحن',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Lateef",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align text to the right
              children: [
                Row(
                  children: [
                    if (discount != 0)
                      Text(
                        '₪ ${(afterDiscount + deliveredCost).toStringAsFixed(2)}    ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: "Lateef",
                          color: Colors.grey,
                        ),
                      ),
                    Stack(children: [
                      Text(
                        '₪ ${(totalPrice + deliveredCost).toStringAsFixed(2)}    ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: "Lateef",
                          color: Colors.grey,
                        ),
                      ),
                      if (discount != 0)
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            child: const Divider(
                              thickness: 1,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ]),
                  ],
                ),
                const Text(
                  'الاجمالي النهائي',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Lateef",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "? هل لديك خصم",
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 150,
                  height: 37,
                  child: TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 15,
                      ), // Adjust the vertical padding as needed
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: 'كود الخصم ان وُجد',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lateef',
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    // Add your onChanged or controller logic here
                    onChanged: (save) {
                      name = save;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.all(10.0),
                    textStyle:
                        const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  onPressed: () {
                    getCouponByName(name);
                  },
                  child: const Text(
                    'تفعيل',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                createOrder();
              },
              style: ElevatedButton.styleFrom(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: const Color.fromRGBO(245, 223, 187, 0.612),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'الدفع عند الاستلام',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Lateef",
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
