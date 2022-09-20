import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class CartItem extends StatelessWidget {
  final String id;
  final String resourceId;
  final double price;
  final int quantity;
  final String title;
  CartItem({this.id, this.resourceId, this.price, this.quantity, this.title});

  void sendWhatsAppMessage({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=$message";
      }
    }

    await canLaunch(url())
        ? launch(url())
        : print("No whatsapp on your device!");
  }

  @override
  Widget build(BuildContext context) {
    //removable (swipe activity)
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(resourceId);
      },
      child: Card(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
                leading: CircleAvatar(
                  child: Text('$quantity'),
                ),
                title: Text(title),
                subtitle: Text('Total: \INR ${price * quantity}'),
                trailing: IconButton(
                  icon: Icon(
                    Icons.message,
                    color: Colors.green.shade600,
                    size: 40,
                  ),
                  onPressed: () {
                    print("Go to whatsapp");
                    sendWhatsAppMessage(
                        phone: '+917330783925',
                        message:
                            'REQUEST FROM COVID RESOURCES APP:\n NAME- $title,\nQTY- $quantity');
                  },
                )),
          )),
    );
  }
}
