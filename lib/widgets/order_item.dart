import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  const OrderItem({Key key, this.order}) : super(key: key);

  final ord.OrderItem order;

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy/hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 15, 180)
                  : 0,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListView.builder(
                itemBuilder: (ctx, i) {
                  var prod = widget.order.products;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        prod[i].title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${prod[i].quantity}x \$${prod[i].price}',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  );
                },
                itemCount: widget.order.products.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
