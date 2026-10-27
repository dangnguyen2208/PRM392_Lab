import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RealApiLoginScreen(),
    );
  }
}

class RealApiLoginScreen extends StatefulWidget {
  const RealApiLoginScreen({super.key});

  @override
  State<RealApiLoginScreen> createState() => _RealApiLoginScreenState();
}

class _RealApiLoginScreenState extends State<RealApiLoginScreen> {
  // DummyJSON dùng username và password để xác thực
  final TextEditingController _usernameController = TextEditingController(text: 'emilys');
  final TextEditingController _passwordController = TextEditingController(text: 'emilyspass');
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackBar('Vui lòng nhập đầy đủ Username và Password!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Gửi POST request tới API DummyJSON
      final url = Uri.parse('https://dummyjson.com/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      // 2. Xử lý phản hồi từ server
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['accessToken'] ?? data['token'];
        final fullName = '${data['firstName']} ${data['lastName']}';
        final email = data['email'] ?? '';

        // 3. Chuyển sang màn hình Home khi thành công
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              fullName: fullName,
              email: email,
              token: token,
            ),
          ),
        );
      } else {
        // Xử lý khi server trả về lỗi (400, 401...)
        final errorData = jsonDecode(response.body);
        _showSnackBar(errorData['message'] ?? 'Đăng nhập không thành công!');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackBar('Không thể kết nối máy chủ hoặc lỗi mạng: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.2 - Real API Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person_outlined, size: 70, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'DummyJSON Authentication',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.key),
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Đăng nhập (REST API)', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String fullName;
  final String email;
  final String token;

  const HomeScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Đăng nhập thành công qua REST API!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
            const Divider(height: 32),
            Text('Họ và tên: $fullName', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Email: $email', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text('Access Token:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                token,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const RealApiLoginScreen()),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Đăng xuất'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}