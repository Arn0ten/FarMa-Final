import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agriplant/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProductService {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Product>> getProducts() async {
    try {
      QuerySnapshot querySnapshot = await _productsCollection.get();
      List<Product> products = [];

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        products.add(Product(
          id: doc.id,
          name: data['name'],
          description: data['description'],
          image: data['image'],
          price: data['price'].toDouble(),
          unit: data['unit'],
          postedByUser: PostedByUser.fromMap(data['postedByUser']),
          deliveryMethod: data['deliveryMethod'] ?? '',
          availableQuantity: data['availableQuantity'] ?? 0,
          location: data['location'] ?? '',
        ));
      });

      return products;
    } catch (e) {
      print('Error getting products: $e');
      throw e;
    }
  }

  Future<void> addProduct(
    Product product,
    String deliveryMethod,
    int availableQuantity,
    String location,
  ) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        bool productExists = await doesProductExist(product.name);

        if (productExists) {
          print('Product with the same name already exists.');
        } else {
          await _productsCollection.doc(product.id).set({
            'name': product.name,
            'description': product.description,
            'image': product.image,
            'price': product.price,
            'unit': product.unit,
            'postedByUser': {
              'uid': currentUser.uid,
              'email': currentUser.email,
              'fullName': currentUser.displayName,
            },
            'deliveryMethod': deliveryMethod,
            'availableQuantity': availableQuantity,
            'location': location,
          });
        }
      } else {
        print('User is not authenticated.');
      }
    } catch (e) {
      print('Error adding product: $e');
      throw e;
    }
  }

  Future<bool> doesProductExist(String productName) async {
    try {
      QuerySnapshot<Object?> snapshot = await _productsCollection
          .where('name', isEqualTo: productName.toLowerCase())
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking product existence: $e');
      throw e;
    }
  }

  Stream<List<Product>> getProductsStream() {
    return _productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Product(
          id: doc.id,
          name: data['name'],
          description: data['description'],
          image: data['image'],
          price: data['price'].toDouble(),
          unit: data['unit'],
          postedByUser: PostedByUser.fromMap(data['postedByUser']),
          deliveryMethod: data['deliveryMethod'] ?? '',
          availableQuantity: data['availableQuantity'] ?? 0,
          location: data['location'] ?? '',
        );
      }).toList();
    });
  }

  Future<List<Product>> fetchProducts() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs.map((doc) {
      return Product.fromMap({
        'id': doc.id,
        'name': doc['name'],
        'description': doc['description'],
        'price': doc['price']?.toDouble() ?? 0.0,
        'image': doc['image'],
        'unit': doc['unit'] ?? '',
      });
    }).toList();
  }

  Future<List<Product>> fetchSimilarProducts(Product product) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('products')
          .where('unit', isEqualTo: product.unit)
          .get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Product(
          id: doc.id,
          name: data['name'],
          price: data['price'].toDouble(),
          unit: data['unit'],
          description: data['description'],
          image: data['image'],
          postedByUser: PostedByUser.fromMap(data['postedByUser']),
          deliveryMethod: data['deliveryMethod'] ?? '',
          availableQuantity: data['availableQuantity'] ?? 0,
          location: data['location'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching similar products: $e');
      throw e;
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      String imageId = DateTime.now().millisecondsSinceEpoch.toString();

      Reference storageReference =
          _storage.ref().child('product_images/$imageId.jpg');

      UploadTask uploadTask = storageReference.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;

      if (taskSnapshot.state == TaskState.success) {
        String downloadUrl = await storageReference.getDownloadURL();
        return downloadUrl;
      } else {
        throw ('Image upload failed');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Stream<List<Product>> getUserProducts(String userId) {
    try {
      return _productsCollection
          .where('postedByUser.uid', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          return Product(
            id: doc.id,
            name: data['name'],
            description: data['description'],
            image: data['image'],
            price: data['price'].toDouble(),
            unit: data['unit'],
            postedByUser: PostedByUser.fromMap(data['postedByUser']),
            deliveryMethod: data['deliveryMethod'] ?? '',
            availableQuantity: data['availableQuantity'] ?? 0,
            location: data['location'] ?? '',
          );
        }).toList();
      });
    } catch (e) {
      print('Error getting user products: $e');
      throw e;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      QuerySnapshot<Object?> snapshot = await _productsCollection
          .where('name', isEqualTo: query.toLowerCase())
          .limit(1)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Product(
          id: doc.id,
          name: data['name'],
          price: data['price'].toDouble(),
          unit: data['unit'],
          description: data['description'],
          image: data['image'],
          postedByUser: PostedByUser.fromMap(data['postedByUser']),
          deliveryMethod: data['deliveryMethod'] ?? '',
          availableQuantity: data['availableQuantity'] ?? 0,
          location: data['location'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error searching products: $e');
      throw e;
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    try {
      DocumentReference productRef = _productsCollection.doc(updatedProduct.id);

      await productRef.update({
        'name': updatedProduct.name,
        'description': updatedProduct.description,
        'price': updatedProduct.price,
        'availableQuantity': updatedProduct.availableQuantity,
        'unit': updatedProduct.unit,
        'image': updatedProduct.image,
        'postedByUser': {
          'uid': updatedProduct.postedByUser.uid,
          'email': updatedProduct.postedByUser.email,
        },
        'deliveryMethod': updatedProduct.deliveryMethod,
        'location': updatedProduct.location,
      });
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _productsCollection.doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      throw e;
    }
  }
}
