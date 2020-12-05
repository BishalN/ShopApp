import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static final routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    print('building..');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              ////..Do something///
              return Center(
                child: Text('Something went wrong'),
              );
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) {
                return ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]));
              });
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
