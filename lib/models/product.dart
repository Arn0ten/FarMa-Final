class Product {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final String unit;
  final PostedByUser postedByUser;
  int quantity; // Add quantity property
  String? cartId; // Add cartId property

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.unit,
    required this.postedByUser,
    this.quantity = 1, // Set default quantity to 1
    this.cartId, // Initialize cartId
  });

  factory Product.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      // If map is null, return a default instance or throw an exception
      // You can modify this based on your requirements
      return Product(
        id: '',
        name: '',
        description: '',
        image: '',
        price: 0.0,
        unit: '',
        postedByUser: PostedByUser(uid: '', email: ''),
        quantity: 1,
        cartId: null,
      );
    }

    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      unit: map['unit'] ?? '',
      postedByUser: PostedByUser.fromMap(map['postedByUser']),
      quantity: map['quantity'] ?? 1,
      cartId: map['cartId'], // Set cartId from the map (it can be null)
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'unit': unit,
      'postedByUser': postedByUser.toMap(),
      'quantity': quantity, // Include quantity in the map
      'cartId': cartId, // Include cartId in the map
    };
  }
}

class PostedByUser {
  final String uid;
  final String email;

  PostedByUser({
    required this.uid,
    required this.email,
  });

  factory PostedByUser.fromMap(Map<String, dynamic> map) {
    return PostedByUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }
}

