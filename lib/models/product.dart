class Product {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final String unit;
  final PostedByUser postedByUser;
  int quantity;
  String? cartId;
  String deliveryMethod; // New property
  int availableQuantity; // New property
  String location; // New property
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.unit,
    required this.postedByUser,
    this.quantity = 1,
    this.cartId,
    required this.deliveryMethod,
    required this.availableQuantity,
    required this.location,
  });

  factory Product.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return Product(
        // Default values or throw an exception based on your requirements
        id: '',
        name: '',
        description: '',
        image: '',
        price: 0.0,
        unit: '',
        postedByUser: PostedByUser(uid: '', email: ''),
        quantity: 1,
        deliveryMethod: '',
        availableQuantity: 0,
        location: '',
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
      deliveryMethod: map['deliveryMethod'] ?? '',
      availableQuantity: map['availableQuantity'] ?? 0,
      location: map['location'] ?? '',
      cartId: map['cartId'],
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
      'quantity': quantity,
      'cartId': cartId,
      'deliveryMethod': deliveryMethod,
      'availableQuantity': availableQuantity,
      'location': location,
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

