import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  if (kIsWeb) {
    // Nếu chạy trên Chrome, điền thông số từ Firebase Console -> Project Settings -> General -> Web App
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyYOUR_API_KEY_HERE",
        appId: "1:YOUR_APP_ID_HERE:web:abcdef",
        messagingSenderId: "YOUR_SENDER_ID",
        projectId: "YOUR_PROJECT_ID",
      ),
    );
  } else {
    // Trên Android sẽ tự động đọc từ google-services.json
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.4 - Firebase Google Sign-In',
      home: GoogleAuthScreen(),
    );
  }
}

class GoogleAuthScreen extends StatefulWidget {
  const GoogleAuthScreen({super.key});

  @override
  State<GoogleAuthScreen> createState() => _GoogleAuthScreenState();
}

class _GoogleAuthScreenState extends State<GoogleAuthScreen> {
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Kiểm tra xem đã có tài khoản lưu phiên sẵn chưa
    _user = FirebaseAuth.instance.currentUser;
  }

  // Luồng đăng nhập bằng Google Sign-In
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      GoogleSignInAccount? googleUser;

      if (kIsWeb) {
        googleUser = await GoogleSignIn().signIn();
      } else {
        googleUser = await GoogleSignIn().signIn();
      }

      if (googleUser == null) {
        // Người dùng tắt popup, huỷ đăng nhập
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập vào Firebase bằng thông tin từ Google
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        _user = userCredential.user;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng nhập: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Đăng xuất
  Future<void> _signOut() async {
    setState(() => _isLoading = true);
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    setState(() {
      _user = null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.4 - Google Sign-In'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _isLoading
              ? const CircularProgressIndicator()
              : _user == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle_outlined, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Đăng nhập bằng tài khoản Google',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_user?.photoURL != null)
                CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(_user!.photoURL!),
                )
              else
                const CircleAvatar(radius: 45, child: Icon(Icons.person, size: 45)),
              const SizedBox(height: 16),
              Text(
                _user?.displayName ?? 'Không có tên hiển thị',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _user?.email ?? 'Không có email',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(
                'UID: ${_user?.uid}',
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _signOut,
                icon: const Icon(Icons.logout),
                label: const Text('Đăng xuất'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}