/**
 * Lab 2 - Dart Essentials Practice Lab
 * Sinh viên: Nguyễn Hải Đăng
 */

import 'dart:async';

void main() async {
  print('--- BÀI THỰC HÀNH LAB 2 - DART ESSENTIALS ---');
  print('Họ và tên: Nguyễn Hải Đăng\n');

  // Thực thi các bài tập
  exercise1();
  printDivider();

  exercise2();
  printDivider();

  exercise3();
  printDivider();

  exercise4();
  printDivider();

  await exercise5();
  print('\n--- KẾT THÚC BÀI LAB ---');
}

void printDivider() {
  print('\n' + '=' * 40 + '\n');
}

// --- Exercise 1: Basic Syntax & Data Types ---
void exercise1() {
  print('Exercise 1: Basic Syntax & Data Types');
  int age = 20;
  double score = 8.5;
  String name = 'Nguyễn Hải Đăng';
  bool isStudent = true;
  print('Tên: $name');
  print('Tuổi: $age');
  print('Điểm số: $score');
  print('Là sinh viên: ${isStudent ? "Đúng" : "Sai"}');
}

// --- Exercise 2: Collections & Operators ---
void exercise2() {
  print('Exercise 2: Collections & Operators');
  List<int> numbers = [10, 20, 30, 40];
  int sum = numbers[0] + numbers[1];
  bool isGreater = numbers[2] > numbers[3];
  
  print('Tổng hai số đầu: $sum');
  print('30 có lớn hơn 40 không? $isGreater');
  Set<String> fruits = {'Apple', 'Banana', 'Orange', 'Apple'}; // Apple sẽ bị loại bỏ nếu trùng
  Map<String, String> capitals = {
    'Vietnam': 'Hanoi',
    'Japan': 'Tokyo',
    'USA': 'Washington D.C.'
  };
  numbers.add(50);
  fruits.remove('Banana');
  
  print('List sau khi add: $numbers');
  print('Set sau khi remove Banana: $fruits');
  print('Thủ đô của Việt Nam: ${capitals['Vietnam']}');
}

// --- Exercise 3: Control Flow & Functions ---
void exercise3() {
  print('Exercise 3: Control Flow & Functions');
  double score = 7.5;
  if (score >= 8.0) {
    print('Xếp loại: Giỏi');
  } else if (score >= 6.5) {
    print('Xếp loại: Khá');
  } else {
    print('Xếp loại: Trung bình/Yếu');
  }
  int day = 2;
  switch (day) {
    case 2:
      print('Hôm nay là Thứ Hai');
      break;
    case 3:
      print('Hôm nay là Thứ Ba');
      break;
    default:
      print('Ngày khác trong tuần');
  }
  List<String> colors = ['Red', 'Green', 'Blue'];
  print('Duyệt bằng for-in:');
  for (var color in colors) {
    print('- $color');
  }
  int add(int a, int b) {
    return a + b;
  }
  
  int multiply(int a, int b) => a * b; // Arrow syntax

  print('Kết quả hàm add(5, 3): ${add(5, 3)}');
  print('Kết quả hàm multiply(5, 3): ${multiply(5, 3)}');
}

// --- Exercise 4: Intro to OOP ---
class Car {
  String brand;
  Car(this.brand);
  Car.special(this.brand) {
    print('Đang tạo một chiếc xe đặc biệt hãng $brand');
  }

  void drive() {
    print('Xe $brand đang chạy...');
  }
}
class ElectricCar extends Car {
  double batteryCapacity;

  ElectricCar(String brand, this.batteryCapacity) : super(brand);

  @override
  void drive() {
    print('Xe điện $brand đang chạy êm ái với pin $batteryCapacity kWh...');
  }
}

void exercise4() {
  print('Exercise 4: Intro to OOP');

  // 4. Khởi tạo đối tượng và in kết quả
  Car myCar = Car('Toyota');
  myCar.drive();

  Car specialCar = Car.special('BMW');
  specialCar.drive();

  ElectricCar myTesla = ElectricCar('Tesla', 100.0);
  myTesla.drive();
}

// --- Exercise 5: Async, Future, Null Safety & Streams ---
Future<void> exercise5() async {
  print('Exercise 5: Async, Future, Null Safety & Streams');
  print('Đang tải dữ liệu...');
  await Future.delayed(Duration(seconds: 1));
  print('Dữ liệu đã tải xong!');
  String? nullableName;
  print('Tên (mặc định): ${nullableName ?? "Khách"}');
  
  nullableName = 'Hải Đăng';
  print('Tên sau khi gán: ${nullableName!}');
  print('Bắt đầu Stream đếm số:');
  Stream<int> countStream = Stream.periodic(Duration(milliseconds: 500), (i) => i + 1).take(3);
  
  await for (int value in countStream) {
    print('Giá trị từ stream: $value');
  }
}
