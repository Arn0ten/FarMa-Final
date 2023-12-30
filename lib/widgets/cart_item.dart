import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../../models/product.dart';
import '../services/cart/cart_service.dart';

class CartItem extends StatefulWidget {
  const CartItem({Key? key, required this.cartItem}) : super(key: key);

  final Product cartItem;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        child: const Icon(
          IconlyLight.delete,
          color: Colors.white,
          size: 25,
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        // Show a confirmation dialog if needed
        return true;
      },
      onDismissed: (DismissDirection direction) {
        // Remove the item from the cart here
        CartService().removeFromCart(widget.cartItem);

        // Show a snackbar to indicate the item has been removed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Item removed from cart'),
          ),
        );
      },
      child: SizedBox(
        height: 125,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          elevation: 0.1,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 90,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(widget.cartItem.image),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cartItem.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.cartItem.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\₱${widget.cartItem.price}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    // Decrease quantity
                                    setState(() {
                                      CartService().decreaseQuantity(widget.cartItem);
                                    });
                                  },
                                ),
                                Text("${widget.cartItem.quantity}"),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    // Increase quantity
                                    setState(() {
                                      CartService().increaseQuantity(widget.cartItem);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
