import 'dart:async';
import 'dart:convert';

// --------- Exercise 1 ---------
class Product {
  int id;
  String name;
  double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() => "Product(id: $id, name: $name, price: $price)";
}

class ProductRepository {
  final List<Product> _products = [
    Product(1, "Laptop", 999.99),
    Product(2, "Phone", 499.99),
  ];

  final StreamController<Product> _controller = StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(milliseconds: 500));
    return _products;
  }

  Stream<Product> liveAdded() {
    return _controller.stream;
  }

  void addProduct(Product p) {
    _products.add(p);
    _controller.add(p);
  }
}

Future<void> exercise1() async {
  print("===== Exercise 1 =====");
  final repo = ProductRepository();

  repo.liveAdded().listen((p) {
    print("Thông báo: Sản phẩm mới được thêm -> $p");
  });

  List<Product> products = await repo.getAll();
  print("Danh sách sản phẩm ban đầu:");
  for (var p in products) {
    print(p);
  }

  repo.addProduct(Product(3, "Tablet", 299.99));
  // Chờ một chút để Stream nhận được dữ liệu
  await Future.delayed(Duration(milliseconds: 100));
}

// --------- Exercise 2 ---------
class User {
  String name;
  String email;

  User(this.name, this.email);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['name'], json['email']);
  }

  @override
  String toString() => "User(name: $name, email: $email)";
}

class UserRepository {
  Future<List<User>> fetchUsers() async {
    await Future.delayed(Duration(milliseconds: 300));

    String jsonString = '''
    [
      {"name": "An", "email": "an@example.com"},
      {"name": "Bình", "email": "binh@example.com"}
    ]
    ''';

    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((item) => User.fromJson(item)).toList();
  }
}

Future<void> exercise2() async {
  final repo = UserRepository();
  List<User> users = await repo.fetchUsers();

  print("\n===== Exercise 2 =====");
  print("Danh sách user lấy từ JSON:");
  for (var u in users) {
    print(u);
  }
}

// --------- Exercise 3 ---------
void exercise3() {
  print("\n===== Exercise 3 =====");
  print("1. Bắt đầu Main (Đồng bộ)");

  Future(() {
    print("4. Future (Event Queue) thực thi");
  });

  scheduleMicrotask(() {
    print("3. Microtask thực thi");
  });

  print("2. Kết thúc Main (Đồng bộ)");
}

// --------- Exercise 4 ---------
Future<void> exercise4() async {
  print("\n===== Exercise 4 =====");
  print("Biến đổi Stream (1-5 -> bình phương -> lấy số chẵn):");
  
  Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

  await for (var value in numbers
      .map((n) => n * n)
      .where((n) => n % 2 == 0)) {
    print("Giá trị nhận được: $value");
  }
}

// --------- Exercise 5 ---------
class Settings {
  String appName = "Dart Lab App";
  
  // Instance tĩnh duy nhất
  static final Settings _instance = Settings._internal();

  // Private constructor
  Settings._internal() {
    print("Khởi tạo Settings (Internal)");
  }

  // Factory constructor trả về instance duy nhất
  factory Settings() {
    return _instance;
  }
}

void exercise5() {
  print("\n===== Exercise 5 =====");
  var s1 = Settings();
  var s2 = Settings();

  print("Tên ứng dụng: ${s1.appName}");
  print("Kiểm tra Singleton: identical(s1, s2) -> ${identical(s1, s2)}");
}

// --------- Main ---------
void main() async {
  print("CHƯƠNG TRÌNH DART NÂNG CAO - LAB 3\n");

  await exercise1();
  await exercise2();
  
  // Chờ cho output của Future/Stream bài 1&2 in ra hết
  await Future.delayed(Duration(milliseconds: 200));
  
  exercise3();
  
  // Chờ cho Microtask/Future của bài 3 chạy xong
  await Future.delayed(Duration(milliseconds: 100));
  
  await exercise4();
  exercise5();
  
  print("\n--- Kết thúc toàn bộ bài Lab ---");
}
