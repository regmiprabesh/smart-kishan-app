import 'package:smart_kishan/models/product.dart';
import 'package:smart_kishan/repositories/repository.dart';

class LocalProductService {
  late Repository _repository;

  Future<void> init() async {
    _repository = Repository();
  }

  //create product
  saveProduct(Product product) async {
    return await _repository.insertData('products', product.toJson());
  }

  //read product
  readProducts() async {
    return await _repository.readData('products');
  }

  //read product by id
  readProductById(productId) async {
    return await _repository.readDataById('products', productId);
  }

  //read product by id
  updateProduct(Product product) async {
    return await _repository.updateData('products', product.toJson());
  }

  //delete product
  deleteProduct(productId) async {
    return await _repository.deleteData('products', productId);
  }
}
