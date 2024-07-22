import 'package:flutter/material.dart';
import 'package:portone_flutter_package/dto/requests/order_details.dart';

class CartDetails extends StatefulWidget {
  CartDetails({Key? key, required this.productList, required this.currency})
      : super(key: key);
  List<OrderDetails> productList;
  String currency;

  @override
  State<CartDetails> createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {
  bool expandCartElement = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              const Text(
                "My Cart (2 items)",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  expandCartElement = !expandCartElement;
                  setState(() {});
                },
                child: const Icon(
                  Icons.arrow_drop_down,
                  size: 30,
                ),
              )
            ],
          ),
          if (expandCartElement)
            CartItem(
              productList: widget.productList,
              currency: widget.currency,
            )
        ],
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  CartItem({Key? key, required this.productList, required this.currency})
      : super(key: key);
  List<OrderDetails> productList;
  String currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          color: Colors.grey,
                          child: productList[index].image != null &&
                                  productList[index].image!.isNotEmpty
                              ? Image.network(
                                  productList[index].image!,
                                  height: 80,
                                  width: 80,
                                )
                              : Container(
                                  color: Colors.black,
                                  height: 80,
                                  width: 80,
                                  // You can customize the black placeholder as needed.
                                ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  productList[index].price.toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                                Text(" $currency",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ))
                              ],
                            ),
                            SizedBox(
                              width: 240,
                              child: Text(productList[index].name!,
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                            ),
                            Text("Qty ${productList[index].quantity}")
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
              // separatorBuilder: (context, index) => VerticalDivider(),
              itemCount: productList.length),
        )
      ],
    );
  }
}
