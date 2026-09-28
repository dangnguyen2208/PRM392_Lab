class User {
  int id;
  String name;
  // TODO 1: Khai báo biến email có thể mang giá trị null (nullable variable)
  String? email;

  // Constructor
  User({required this.id, required this.name, this.email});

  // TODO 2: Khai báo factory User.fromJson(Map<String, dynamic> json)
  // - Lấy id từ json['id']
  // - Lấy name từ json['name']. Nếu null, dùng toán tử ?? để gán mặc định là "Khách"
  // - Lấy email từ json['email']
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? "Khách",
      email: json['email'],
    );
  }

  void showProfile() {
    // TODO 3: In ra thông tin. Dùng toán tử ?? để xử lý email nếu bị null.
    // Gợi ý chuỗi in ra: "ID: $id | Tên: $name | Email: ..."
    print("ID: $id | Tên: $name | Email: ${email ?? 'Chưa cập nhật'}");
  }
}

void main() {
  // Giả lập dữ liệu JSON trả về từ API
  Map<String, dynamic> rawData1 = {"id": 1, "name": "Đăng", "email": "dangnhhe186696@fpt.edu.vn"};
  Map<String, dynamic> rawData2 = {"id": 2, "name": null, "email": null};

  // TODO 4: Khởi tạo user1 và user2 từ 2 Map trên bằng User.fromJson và gọi showProfile()
  User user1 = User.fromJson(rawData1);
  User user2 = User.fromJson(rawData2);

  user1.showProfile();
  user2.showProfile();
}
