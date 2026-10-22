import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Lab9App());
}

class Lab9App extends StatelessWidget {
  const Lab9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 - Local JSON Storage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// Model chung
class Product {
  final int id;
  final String name;
  final String category;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
    };
  }
}

// Màn hình điều hướng 3 Lab
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    Lab91AssetScreen(),
    Lab92StorageScreen(),
    Lab93CrudScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.file_present),
            label: '9.1 Assets',
          ),
          NavigationDestination(
            icon: Icon(Icons.save),
            label: '9.2 Storage',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage),
            label: '9.3 CRUD DB',
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// LAB 9.1: ĐỌC JSON TỪ ASSETS (Local Embedded File)
// -------------------------------------------------------------
class Lab91AssetScreen extends StatefulWidget {
  const Lab91AssetScreen({super.key});

  @override
  State<Lab91AssetScreen> createState() => _Lab91AssetScreenState();
}

class _Lab91AssetScreenState extends State<Lab91AssetScreen> {
  List<Product> _products = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadAssetJson();
  }

  Future<void> _loadAssetJson() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final String jsonString =
      await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      setState(() {
        _products = jsonList.map((e) => Product.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Lỗi nạp file assets: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9.1 - Read Assets JSON')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final p = _products[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(child: Text('${p.id}')),
              title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${p.category} | \$${p.price.toStringAsFixed(2)}'),
            ),
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------------
// LAB 9.2: LƯU & ĐỌC DỮ LIỆU TỪ BỘ NHỚ THIẾT BỊ
// -------------------------------------------------------------
class Lab92StorageScreen extends StatefulWidget {
  const Lab92StorageScreen({super.key});

  @override
  State<Lab92StorageScreen> createState() => _Lab92StorageScreenState();
}

class _Lab92StorageScreenState extends State<Lab92StorageScreen> {
  List<Product> _storageItems = [];
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFromStorage();
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/lab92_data.json');
  }

  Future<void> _loadFromStorage() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          final List<dynamic> list = jsonDecode(content);
          setState(() {
            _storageItems = list.map((e) => Product.fromJson(e)).toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Lỗi đọc: $e');
    }
  }

  Future<void> _saveToStorage() async {
    final file = await _getFile();
    final jsonStr = jsonEncode(_storageItems.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonStr);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu dữ liệu vào bộ nhớ máy thành công!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _addItem() {
    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0.0;
    if (name.isEmpty) return;

    final newId = _storageItems.isEmpty
        ? 1
        : _storageItems.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

    setState(() {
      _storageItems.add(Product(id: newId, name: name, category: 'Storage', price: price));
    });
    _nameCtrl.clear();
    _priceCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2 - Device Storage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Lưu vào máy',
            onPressed: _saveToStorage,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Tên mục', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _priceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Giá (\$)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _addItem,
                            icon: const Icon(Icons.add),
                            label: const Text('Thêm vào danh sách'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _saveToStorage,
                          icon: const Icon(Icons.save_alt),
                          label: const Text('Lưu file'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _storageItems.length,
              itemBuilder: (context, index) {
                final item = _storageItems[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${item.id}')),
                  title: Text(item.name),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// LAB 9.3: MINI DATABASE LOCAL JSON (CRUD + Search + Auto-Save)
// -------------------------------------------------------------
class Lab93CrudScreen extends StatefulWidget {
  const Lab93CrudScreen({super.key});

  @override
  State<Lab93CrudScreen> createState() => _Lab93CrudScreenState();
}

class _Lab93CrudScreenState extends State<Lab93CrudScreen> {
  List<Product> _db = [];
  List<Product> _displayList = [];
  String _search = '';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initMiniDatabase();
  }

  Future<File> _getDbFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/lab93_minidb.json');
  }

  Future<void> _initMiniDatabase() async {
    final file = await _getDbFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.isNotEmpty) {
        final List<dynamic> list = jsonDecode(content);
        _db = list.map((e) => Product.fromJson(e)).toList();
      }
    } else {
      // Nạp từ assets làm dữ liệu khởi đầu
      final str = await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> list = jsonDecode(str);
      _db = list.map((e) => Product.fromJson(e)).toList();
      await _autoSave();
    }
    _applyFilter();
  }

  Future<void> _autoSave() async {
    final file = await _getDbFile();
    await file.writeAsString(jsonEncode(_db.map((e) => e.toJson()).toList()));
  }

  void _applyFilter() {
    setState(() {
      if (_search.isEmpty) {
        _displayList = List.from(_db);
      } else {
        _displayList = _db
            .where((item) =>
        item.name.toLowerCase().contains(_search.toLowerCase()) ||
            item.category.toLowerCase().contains(_search.toLowerCase()))
            .toList();
      }
    });
  }

  void _openForm({Product? editItem}) {
    final isEdit = editItem != null;
    final nameCtrl = TextEditingController(text: isEdit ? editItem.name : '');
    final catCtrl = TextEditingController(text: isEdit ? editItem.category : '');
    final priceCtrl = TextEditingController(text: isEdit ? editItem.price.toString() : '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Sửa mục' : 'Thêm mục mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên')),
            TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'Danh mục')),
            TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Giá (\$')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              final cat = catCtrl.text.trim();
              final price = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
              if (name.isEmpty) return;

              if (isEdit) {
                final idx = _db.indexWhere((e) => e.id == editItem.id);
                if (idx != -1) {
                  _db[idx] = Product(id: editItem.id, name: name, category: cat, price: price);
                }
              } else {
                final newId = _db.isEmpty ? 1 : _db.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
                _db.add(Product(id: newId, name: name, category: cat, price: price));
              }

              await _autoSave();
              _applyFilter();
              if (!mounted) return;
              Navigator.pop(ctx);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(Product p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${p.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              setState(() {
                _db.removeWhere((e) => e.id == p.id);
              });
              await _autoSave();
              _applyFilter();
              if (!mounted) return;
              Navigator.pop(ctx);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9.3 - CRUD & Search')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Tìm theo tên hoặc danh mục...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                _search = val;
                _applyFilter();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _displayList.length,
              itemBuilder: (context, index) {
                final item = _displayList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${item.id}')),
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${item.category} • \$${item.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _openForm(editItem: item)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteItem(item)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}